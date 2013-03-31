package main 

import ( 
	. "./globals/rc"
	. "./globals/ui"
	"os"
	"path/filepath"
	"github.com/howeyc/fsnotify"
	"github.com/GutenYe/tagen.go/os2"
)

func skipFile(path string) bool {
	info, _ := os.Lstat(path)
	fileName := filepath.Base(path)

	// tags 
	// .*
	// backup~
	return info.IsDir() ||
		info.Mode() & os.ModeSymlink != 0 ||
		filepath.Ext(path) != ".gnote" ||
		fileName == "tags" ||
		fileName[0] == '.' ||
		fileName[len(fileName)-1] == '~'
}

func Tags() {
	err := os.MkdirAll(Rc.Cache, 0755)
	if err != nil { Ui.Panic(err) }
	err = os2.EmptyAll(Rc.Cache)
	if err != nil { Ui.Panic(err) }

	// generate cache tags
	err = filepath.Walk(Rc.Dir, func(p string, i os.FileInfo, e error) error {
		if e != nil { return e } 
		if skipFile(p) { 
			return nil 
		}

		rel, e := filepath.Rel(Rc.Dir, p)
		if e != nil { return e }
		e = GenerateCacheTags(rel, Rc.Dir, Rc.Cache, Rc.Mark)
		if e != nil { return e }

		return nil
	})
	if err != nil { Ui.Panic(err) }

	// concat cache tags
	err = ConcatCacheTags(Rc.Cache, Rc.Usertags, Rc.Output)
	if err != nil { Ui.Panic(err) }
	Ui.Printf("CREATED %s\n", Rc.Output)
}

func Watch() {
	Ui.Printf("Watching %s\n", Rc.Dir)
	watcher, err := fsnotify.NewWatcher()
	if err != nil { Ui.Panic(err) }
	err = filepath.Walk(Rc.Dir, func(p string, i os.FileInfo, e error) error {
		if err != nil { return err }
		if i.IsDir() {
			err = watcher.Watch(p)
			if err != nil { return err }
		}
		return nil
	})
	if err != nil { Ui.Panic(err) }
	for {
		select {
		case ev := <-watcher.Event:
			Ui.Print(ev)
			if ev.IsCreate() {
				info, err := os.Stat(ev.Name)
				if err != nil { Ui.Panic(err) }
				if info.IsDir() {
					watcher.Watch(ev.Name)
				}
			}

			rel, err := filepath.Rel(Rc.Dir, ev.Name)
			if err != nil { Ui.Panic(err) }
			switch {
			case ev.IsCreate() || ev.IsModify():
				if skipFile(ev.Name) {
					continue
				}
				err := GenerateCacheTags(rel, Rc.Dir, Rc.Cache, Rc.Mark)
				if err != nil { Ui.Panic(err) }
			case ev.IsDelete():
				err := os.Remove(filepath.Join(Rc.Cache, rel))
				if err != nil { Ui.Panic(err) }
			}
			err = ConcatCacheTags(Rc.Cache, Rc.Usertags, Rc.Output)
			if err != nil { Ui.Panic(err) }
		case err := <-watcher.Error:
			Ui.Panic(err)
		}
	}
}