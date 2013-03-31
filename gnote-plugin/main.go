package main

import ( 
	. "./globals/rc"
	. "./globals/ui"
	"os"
	"github.com/ogier/pflag"
	"log"
	"github.com/GutenYe/tagen.go/os2"
	"github.com/GutenYe/tagen.go/path2/filepath2"
	"launchpad.net/goyaml"
	"io/ioutil"
	"path/filepath"
)
import . "github.com/GutenYe/tagen.go/pd"; var pd = Pd

const VERSION = "0.0.1"
var homeRc = filepath.Join(os.Getenv("HOME"), ".gnoterc")
var homeConfig = filepath.Join(os.Getenv("HOME"), ".gnote")
var USAGE = `$ gnote <cmd> [options]

COMMAND:
	tags
	watch

GENERIC OPTIONS
	-v, --version
	-h, --help
`
func main(){
	pflag.Usage = func() {
		Ui.Print(USAGE)
	}
	var version = pflag.BoolP("version", "v", false, "print version number")
	var dir = pflag.StringP("dir", "", "~/note", "note directory")
	var output = pflag.StringP("output", "", "", "output file")
	var cache = pflag.StringP("cache", "", "", "cahce directory")
	var mark = pflag.StringP("mark", "", "", "mark character")
	pflag.Parse()
	if *version {
		Ui.Printf("gnote %s", VERSION)
		os.Exit(0)
	}

	Ui = log.New(os.Stdout, "", 0)
	if os2.IsExist(homeRc) {
		d, e := ioutil.ReadFile(homeRc)
		if e != nil { Ui.Fatal(e) }
		goyaml.Unmarshal(d, &Rc)
	}
	Rc.Cache = "~/.cache/gnote"
	if *dir != "" { Rc.Dir = *dir }
	if *output != "" { Rc.Output = *output }
	if *cache != "" { Rc.Cache = *cache }
	if *mark != "" { Rc.Mark = *mark }
	Rc.Dir, Rc.Output, Rc.Cache = filepath2.ExtendAbs2(Rc.Dir), filepath2.ExtendAbs2(Rc.Output), filepath2.ExtendAbs2(Rc.Cache)
	Rc.Usertags = filepath.Join(homeConfig, "tags")

	switch pflag.Arg(0) {
	case "tags":
		Tags()
	case "watch":
		Tags()
		Watch()
	default:
		pflag.Usage()
	}
}
