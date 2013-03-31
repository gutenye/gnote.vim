#!/bin/bash

# Build binary for distribution.
#
# Usage:
#
#   ./build.sh [options] [platform ...]
#     -d <assets_dir>
#     -p              # packaging the binary
#
# Example:
#
#   ./build.sh -d /usr/share/milkd    # build with system go
#   ./build.sh release                # build $RELEASEs with user complied go and upload the package to s3.

APP="gnote"
EXTRA_FILES=""
RELEASE="homebrew/amd64 homebrew/386 windows/386 windows/amd64"
VERSION=$(sed -rn 's/.*const VERSION.*"([0-9.]+)".*/\1/p' main.go)
declare -A OS_MAP=(
	[homebrew]="darwin"
)
declare -A DIR_MAP=(
	[homebrew]="/usr/share/milkd"
)

platform=""
os=""
arch=""
assets_dir=""

function cgo_enabled { [ "$1" == "$GOHOSTOS" ] && echo 1 || echo 0; }
function ext { [ $1 == "windows" ] && echo .exe || echo ""; }

function removeFmt() {
}


# dist{platform, os, arch, assets_dir}
function dist {
	rm -r dist 2>/dev/null
	mkdir dist

	if [ ! -z $EXTRA_FILES ]; then
		cp -r $EXTRA_FILES dist
	fi
	build
}

# build{platform, os, arch, assets_dir}
function build {
	echo -e "\nbuilding $platform/$arch"
	#rsync -v -a --del --exclude '.*' . "/tmp/$APP/"

	#sed -i '/^var HOME/s/.*/var HOME = os.Getenv("HOME")/' main.go
	#sed -i 's/^import . "github.com/GutenYe/tagen.go/pd".*//' **/*.go
	CGO_ENABLED=$(cgo_enabled $os) GOOS=$os GOARCH=$arch $GOROOT/bin/go build -o "dist/milkd$(ext $os)"

	#rsync -v -a "/tmp/$APP/" .
}

# package{platform, os, arch}
function package {
	echo "packing $platform/$arch" 
	mkdir dist/milkd-$VERSION
	cp -r dist/* dist/milkd-$VERSION 2>/dev/null

	case $os in
		linux | darwin )
			tar zcvf milkd.$platform.$arch-$VERSION.tar.gz -C dist milkd-$VERSION;;
		windows ) 
			rm ../milkd.$platform.$arch.zip 2>/dev/null
			cd dist && zip -r ../milkd.$platform.$arch.zip milkd-$VERSION && cd ..
			;;
	esac
}

function upload {
	for file in $*; do
		s3cmd put --acl-public $file s3://downloads.gutenye.com/milkd/
		#current=$(echo $file | sed -r 's/(.*)-[0-9.]+(\..*)$/\1\2/')
		#s3cmd copy s3://downloads.gutenye.com/milkd/$file s3://downloads.gutenye.com/milkd/$current
	done
}

#
# ¤main
# ----

eval "$(go env)"

o_assets_dir="runtime"
o_package=false
while getopts "d:p" opt; do
  case $opt in
    d ) o_assets_dir=$OPTARG ;;
		p ) o_package=true ;;
  esac
done
shift $(( OPTIND - 1 ))

case $1 in
	"" )
		platform=$GOOS; os=$GOOS; arch=$GOARCH; assets_dir=$o_assets_dir
		dist
		[ $o_package == true ] && package
		;;
	release )
		GOROOT="/home/guten/dev/src/go/go"
		rm *.zip *.tar.gz 2>/dev/null
		for release in $RELEASE; do
			platform=${release%/*}; arch=${release#*/}; os=${OS_MAP[$platform]-$platform}
			assets_dir=${DIR_MAP[$platform]-$o_assets_dir}
			dist
			package
		done
		upload *.zip *.tar.gz
		;;
	upload )
		shift
		upload $*
		;;
	* )
		GOROOT="/home/guten/dev/src/go/go"
		platform=${1%/*}; arch=${1#*/}; os=${OS_MAP[$platform]-$platform}
		dist
		[ $o_package == true ] && package
		;;
esac

exit 0
