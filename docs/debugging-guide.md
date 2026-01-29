# Debugging Guide for Tlang

This guide explains how to debug Tlang programs using GDB (GNU Debugger) or LLDB (LLVM Debugger).

## Overview

Tlang compiles to C code, which means you can use standard C debuggers (GDB/LLDB) to debug your Tlang programs. The compiler generates `#line` directives that map the generated C code back to your original Tlang source files, allowing debuggers to show you the correct source locations.

## Prerequisites

- **GDB** (GNU Debugger) - Available on Linux, macOS (via Homebrew), and Windows (via MinGW/MSYS2)
- **LLDB** - Available on macOS (default) and can be installed on Linux
- **C Compiler** with debug support (GCC or Clang)

## Compiling with Debug Symbols

To enable debugging, you need to compile your Tlang program with debug symbols. The Tlang compiler automatically includes `#line` directives for source mapping, but you need to pass the `-g` flag when compiling the generated C code.

### Step 1: Compile Tlang to C

```bash
tlangc program.tl output.c
```

Or using the wrapper:

```bash
tlang compile program.tl output
# This produces an executable binary directly
```

### Step 2: Compile C with Debug Symbols

**Using GCC:**
```bash
gcc -g -o program output.c -lm
```

**Using Clang:**
```bash
clang -g -o program output.c -lm
```

**With OpenSSL support:**
```bash
gcc -g -DUSE_OPENSSL -o program output.c -lm -lssl -lcrypto
```

The `-g` flag tells the compiler to include debug information (DWARF format) in the executable.

### Additional Debug Flags

For more detailed debug information:

- `-g3` - Maximum debug information (includes macro definitions)
- `-O0` - Disable optimizations (recommended for debugging)
- `-fno-omit-frame-pointer` - Preserve frame pointers (helps with stack traces)

**Example:**
```bash
gcc -g3 -O0 -fno-omit-frame-pointer -o program output.c -lm
```

## Using GDB

### Starting GDB

```bash
gdb ./program
```

Or start with arguments:
```bash
gdb --args ./program arg1 arg2
```

### Basic GDB Commands

#### Running the Program

- `run` or `r` - Start the program
- `run <args>` - Run with arguments
- `continue` or `c` - Continue execution after stopping
- `step` or `s` - Step into function calls
- `next` or `n` - Step over function calls
- `finish` - Execute until current function returns

#### Setting Breakpoints

- `break <function>` or `b <function>` - Set breakpoint at function
  ```gdb
  (gdb) break adhi
  (gdb) break #add  # For functions starting with #
  ```

- `break <file>:<line>` - Set breakpoint at specific line
  ```gdb
  (gdb) break program.tl:10
  ```

- `break <line>` - Set breakpoint at line in current file
  ```gdb
  (gdb) break 15
  ```

- `info breakpoints` - List all breakpoints
- `delete <num>` - Delete breakpoint by number
- `disable <num>` - Disable breakpoint
- `enable <num>` - Enable breakpoint

#### Inspecting Variables

- `print <variable>` or `p <variable>` - Print variable value
  ```gdb
  (gdb) print x
  (gdb) p @myVar  # For variables with @ prefix
  ```

- `print <expression>` - Evaluate expression
  ```gdb
  (gdb) print x + 1
  ```

- `display <variable>` - Automatically display variable at each stop
- `undisplay <num>` - Stop displaying variable

#### Stack and Frames

- `backtrace` or `bt` - Show call stack
- `frame <num>` - Switch to frame number
- `up` - Move up one frame
- `down` - Move down one frame
- `info locals` - Show local variables in current frame
- `info args` - Show function arguments

#### Viewing Source Code

- `list` or `l` - Show source code around current line
- `list <function>` - Show source for function
- `list <file>:<line>` - Show specific line
- `list <start>,<end>` - Show range of lines

### Example GDB Session

```bash
$ gdb ./program
(gdb) break adhi
Breakpoint 1 at 0x401234: file program.tl, line 5.
(gdb) run
Starting program: ./program

Breakpoint 1, adhi () at program.tl:5
5       @x int = 10;
(gdb) print x
$1 = 0
(gdb) next
6       @y int = x + 5;
(gdb) print x
$2 = 10
(gdb) continue
Continuing.
[Program output]
Program exited normally.
(gdb) quit
```

## Using LLDB

LLDB is the default debugger on macOS and can be used similarly to GDB.

### Starting LLDB

```bash
lldb ./program
```

### Basic LLDB Commands

LLDB commands are similar to GDB but with some differences:

#### Running the Program

- `run` or `r` - Start the program
- `continue` or `c` - Continue execution
- `step` or `s` - Step into
- `next` or `n` - Step over
- `finish` - Finish current function

#### Setting Breakpoints

- `breakpoint set --name <function>` or `b <function>`
  ```lldb
  (lldb) b adhi
  ```

- `breakpoint set --file <file> --line <line>`
  ```lldb
  (lldb) breakpoint set --file program.tl --line 10
  ```

- `breakpoint list` - List breakpoints
- `breakpoint delete <num>` - Delete breakpoint

#### Inspecting Variables

- `print <variable>` or `p <variable>`
- `frame variable` or `fr v` - Show all local variables
- `frame variable <name>` - Show specific variable

#### Stack

- `bt` - Backtrace
- `frame select <num>` - Select frame
- `up` / `down` - Navigate frames

### Example LLDB Session

```bash
$ lldb ./program
(lldb) breakpoint set --name adhi
Breakpoint 1: where = program`adhi, address = 0x0000000100001234
(lldb) run
Process 12345 launched: './program' (x86_64)
Process 12345 stopped
* thread #1, stop reason = breakpoint 1.1
    frame #0: 0x0000000100001234 program`adhi at program.tl:5
   2    dhimpu "fmt";
   3    
   4    #prarambham() {
-> 5       @x int = 10;
   6       @y int = x + 5;
   7       fmt.Printf("x = %d, y = %d\n", x, y);
   8    }
(lldb) print x
(int) $0 = 0
(lldb) next
(lldb) print x
(int) $1 = 10
```

## Source Mapping with #line Directives

The Tlang compiler automatically generates `#line` directives in the C output to map generated code back to your Tlang source. This allows debuggers to:

- Show correct line numbers from your `.tl` files
- Set breakpoints using Tlang source line numbers
- Display source code from your original files

**Example generated C code:**
```c
#line 1 "program.tl"
#include <stdio.h>
// ... runtime code ...

#line 5 "program.tl"
void adhi() {
#line 5 "program.tl"
    int x = 10;
#line 6 "program.tl"
    int y = x + 5;
    // ...
}
```

When debugging, GDB/LLDB will show `program.tl:5` instead of `output.c:123`.

## Debugging Tips

### 1. Disable Optimizations

Always compile with `-O0` (no optimizations) when debugging:
```bash
gcc -g -O0 -o program output.c -lm
```

Optimizations can reorder code and eliminate variables, making debugging difficult.

### 2. Use Meaningful Variable Names

Tlang variable names (with `@` prefix) are preserved in the generated C code, making it easier to identify variables in the debugger.

### 3. Check Generated C Code

If breakpoints aren't working as expected, check the generated C code to see how your Tlang code was translated:
```bash
tlangc program.tl output.c
cat output.c
```

### 4. Debug Standard Library Functions

Standard library functions (from `fmt`, `strings`, `http`, etc.) are included in the generated C code. You can set breakpoints in them, but they won't have `#line` directives pointing back to Tlang source.

### 5. Watch for Inlined Code

Some simple expressions might be inlined or optimized away. Use `-O0` to prevent this.

## Common Issues

### Breakpoints Not Working

- Ensure you compiled with `-g` flag
- Check that the source file path in `#line` directives is correct
- Verify the function/line exists in your source

### Wrong Line Numbers

- The `#line` directives are approximate for some constructs
- Complex expressions might span multiple C statements
- Check the generated C code to see the actual mapping

### Variables Not Found

- Some temporary variables might be optimized away (use `-O0`)
- Variable names with special characters might be mangled
- Check `info locals` in GDB to see all available variables

## Advanced: Debugging with VS Code

You can configure VS Code to use GDB/LLDB for debugging Tlang programs:

### `.vscode/launch.json` (GDB on Linux)

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Tlang",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/program",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "build"
        }
    ]
}
```

### `.vscode/tasks.json` (Build Task)

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build",
            "type": "shell",
            "command": "tlangc program.tl output.c && gcc -g -O0 -o program output.c -lm",
            "problemMatcher": []
        }
    ]
}
```

## See Also

- [GDB Documentation](https://www.gnu.org/software/gdb/documentation/)
- [LLDB Documentation](https://lldb.llvm.org/)
- [Getting Started Guide](getting-started.md)
