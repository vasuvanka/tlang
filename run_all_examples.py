#!/usr/bin/env python3
"""
Script to run all Tlang examples and log output as comments in each file.
"""

import os
import subprocess
import sys
from pathlib import Path

# Get the project root directory
PROJECT_ROOT = Path(__file__).parent.absolute()
EXAMPLES_DIR = PROJECT_ROOT / "examples"

def run_command(cmd, cwd=None, timeout=30):
    """Run a command and return stdout, stderr, and return code."""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd or PROJECT_ROOT,
            capture_output=True,
            text=True,
            timeout=timeout
        )
        return result.stdout, result.stderr, result.returncode
    except subprocess.TimeoutExpired:
        return "", "Command timed out after {} seconds".format(timeout), -1
    except Exception as e:
        return "", str(e), -1

def compile_and_run_tl_file(tl_file, extra_args=""):
    """Compile a .tl file to executable and run it, returning the output."""
    file_path = EXAMPLES_DIR / tl_file
    
    # Step 1: Use 'cargo run -- compile' which creates output.exe at root
    compile_cmd = f'cargo run -- compile "{file_path}"'
    stdout, stderr, retcode = run_command(compile_cmd, timeout=5)

    if retcode == -1:  # Timeout
        return f"TIMEOUT: Compilation timed out after 5 seconds\n{stdout}\n{stderr}", False
    if retcode != 0:
        return f"COMPILATION ERROR:\n{stdout}\n{stderr}", False
    
    # Step 2: Check if output.exe was created
    exe_name = "output.exe" if sys.platform == 'win32' else "output"
    exe_path = PROJECT_ROOT / exe_name
    if not exe_path.exists():
        return f"ERROR: Executable not found at {exe_path}", False

    # Step 3: Run the executable
    # Run with extra args if provided (for examples that need command-line arguments)
    run_cmd = f'"{exe_path}" {extra_args}'.strip()
    stdout, stderr, retcode = run_command(run_cmd, timeout=5)
    
    # Handle timeout
    if retcode == -1:  # Timeout
        # Clean up before returning
        try:
            if exe_path.exists():
                os.remove(exe_path)
            c_file = PROJECT_ROOT / "output.c"
            if c_file.exists():
                os.remove(c_file)
        except:
            pass
        return f"TIMEOUT: Execution timed out after 5 seconds\n{stdout}\n{stderr}", False
    
    # Clean up temporary executable and C file
    try:
        if exe_path.exists():
            os.remove(exe_path)
        # Also clean up .c file if it exists
        c_file = PROJECT_ROOT / "output.c"
        if c_file.exists():
            os.remove(c_file)
    except Exception as e:
        pass  # Ignore cleanup errors
    
    return stdout, retcode == 0

def append_output_as_comments(file_path, output, success):
    """Append the output as comments to the file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if output already exists (to avoid duplicates)
        if "=== OUTPUT ===" in content:
            # Remove old output
            content = content.split("=== OUTPUT ===")[0].rstrip()
        
        # Format output as comments
        comment_lines = ["\n", "// === OUTPUT ===\n"]
        if not success:
            comment_lines.append("// ERROR: Execution failed\n")
        
        for line in output.split('\n'):
            if line.strip():
                comment_lines.append(f"// {line}\n")
            else:
                comment_lines.append("//\n")
        
        # Append to file
        new_content = content.rstrip() + "\n" + "".join(comment_lines)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        return True
    except Exception as e:
        print(f"Error appending output to {file_path}: {e}")
        return False

def main():
    """Main function to process all example files."""
    # Get all .tl files in examples directory
    tl_files = sorted([f.name for f in EXAMPLES_DIR.glob("*.tl")])
    
    print(f"Found {len(tl_files)} example files to process.\n")
    
    success_count = 0
    error_count = 0
    errors_to_fix = []
    
    for i, tl_file in enumerate(tl_files, 1):
        file_path = EXAMPLES_DIR / tl_file 
        print(f"[{i}/{len(tl_files)}] Processing {tl_file}...", end=" ", flush=True)
        
       
        
        # Some examples need command-line arguments
        extra_args = ""
        if tl_file == "args_example.tl":
            extra_args = "--help"  # Run with --help flag
        elif tl_file == "flag_example.tl":
            extra_args = "--name Test --count 5"  # Example flags
        
        try:
            output, success = compile_and_run_tl_file(tl_file, extra_args)
        except Exception as e:
            output = f"UNEXPECTED ERROR: {str(e)}"
            success = False
        
        if success:
            print("OK")
            success_count += 1
        else:
            print("ERROR")
            error_count += 1
            errors_to_fix.append((tl_file, output))
        
        # Append output as comments
        try:
            append_output_as_comments(file_path, output, success)
        except Exception as e:
            print(f" (Failed to append output: {e})", end="")
    
    print(f"\n{'='*60}")
    print(f"Summary: {success_count} succeeded, {error_count} failed")
    print(f"{'='*60}\n")
    
    if errors_to_fix:
        print("Files with errors:")
        for filename, error_msg in errors_to_fix:
            print(f"  - {filename}")
            print(f"    {error_msg[:100]}...")
        print("\nAttempting to fix errors...")
        # TODO: Add error fixing logic here
    
    return error_count == 0

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
