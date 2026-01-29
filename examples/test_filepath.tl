// Test cases for filepath library

dhimpu "fmt" as fmt;
dhimpu "filepath" as filepath;

#prarambham() {
    fmt.Printf("=== filepath Library Tests ===\n");
    
    // Join tests
    @joined1 string = filepath.Join("/usr", "local");
    @joined2 string = filepath.Join("dir1", "dir2");
    @joined3 string = filepath.Join("/", "usr", "local");
    @joined4 string = filepath.Join("", "relative");
    @joined5 string = filepath.Join("absolute", "");
    
    fmt.Printf("Join('/usr', 'local'): %s\n", joined1);
    fmt.Printf("Join('dir1', 'dir2'): %s\n", joined2);
    fmt.Printf("Join('/', 'usr', 'local') (chained): %s\n", joined3);
    fmt.Printf("Join('', 'relative'): %s\n", joined4);
    fmt.Printf("Join('absolute', ''): %s\n", joined5);
    
    // Base tests
    fmt.Printf("Base('/usr/local/bin'): %s\n", filepath.Base("/usr/local/bin"));
    fmt.Printf("Base('file.txt'): %s\n", filepath.Base("file.txt"));
    fmt.Printf("Base('/'): %s\n", filepath.Base("/"));
    fmt.Printf("Base(''): %s\n", filepath.Base(""));
    fmt.Printf("Base('dir/file.txt'): %s\n", filepath.Base("dir/file.txt"));
    
    // Dir tests
    fmt.Printf("Dir('/usr/local/bin'): %s\n", filepath.Dir("/usr/local/bin"));
    fmt.Printf("Dir('file.txt'): %s\n", filepath.Dir("file.txt"));
    fmt.Printf("Dir('/'): %s\n", filepath.Dir("/"));
    fmt.Printf("Dir('dir/file.txt'): %s\n", filepath.Dir("dir/file.txt"));
    
    // Ext tests
    fmt.Printf("Ext('file.txt'): %s\n", filepath.Ext("file.txt"));
    fmt.Printf("Ext('file.tar.gz'): %s\n", filepath.Ext("file.tar.gz"));
    fmt.Printf("Ext('noextension'): %s\n", filepath.Ext("noextension"));
    fmt.Printf("Ext('.hidden'): %s\n", filepath.Ext(".hidden"));
    fmt.Printf("Ext('file.'): %s\n", filepath.Ext("file."));
    
    // Clean tests
    fmt.Printf("Clean('/usr/../local/./bin'): %s\n", filepath.Clean("/usr/../local/./bin"));
    fmt.Printf("Clean('./dir/../file'): %s\n", filepath.Clean("./dir/../file"));
    fmt.Printf("Clean('../../etc'): %s\n", filepath.Clean("../../etc"));
    fmt.Printf("Clean('/./usr/./local'): %s\n", filepath.Clean("/./usr/./local"));
    fmt.Printf("Clean(''): %s\n", filepath.Clean(""));
    
    // IsAbs tests
    fmt.Printf("IsAbs('/absolute/path'): %d\n", filepath.IsAbs("/absolute/path"));
    fmt.Printf("IsAbs('relative/path'): %d\n", filepath.IsAbs("relative/path"));
    fmt.Printf("IsAbs(''): %d\n", filepath.IsAbs(""));
    fmt.Printf("IsAbs('./relative'): %d\n", filepath.IsAbs("./relative"));
    
    // Split tests
    @split1 string = filepath.Split("/usr/local/bin");
    @split2 string = filepath.Split("file.txt");
    @split3 string = filepath.Split("/");
    
    fmt.Printf("Split('/usr/local/bin'): %s\n", split1);
    fmt.Printf("Split('file.txt'): %s\n", split2);
    fmt.Printf("Split('/'): %s\n", split3);
    
    // Abs tests
    @abs1 string = filepath.Abs("test.txt");
    @abs2 string = filepath.Abs(".");
    @abs3 string = filepath.Abs("..");
    
    fmt.Printf("Abs('test.txt'): %s\n", abs1);
    fmt.Printf("Abs('.'): %s\n", abs2);
    fmt.Printf("Abs('..'): %s\n", abs3);
    fmt.Printf("All absolute paths are absolute: %d, %d, %d\n", 
               filepath.IsAbs(abs1), filepath.IsAbs(abs2), filepath.IsAbs(abs3));
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.28s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_filepath.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_filepath.tl:75:1: Unexpected token: Newline
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   75 |                filepath.IsAbs(abs1), filepath.IsAbs(abs2), filepath.IsAbs(abs3));
//    |    ^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\test_filepath.tl` (exit code: 1)
//
