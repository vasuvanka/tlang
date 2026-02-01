// utils.tl - Example utility package

@fmt = #dhimpu("std/fmt");

// Utility function to calculate sum of array
#sum(numbers []int) int {
    @total int = 0;
    @i int = 0;
    malli i < len(numbers); i = i + 1 {
        total = total + numbers[i];
    }
    mallinchu total;
}

// Utility function to find maximum value
#max(numbers []int) int {
    @maxVal int = numbers[0];
    @i int = 1;
    malli i < len(numbers); i = i + 1 {
        okavela numbers[i] > maxVal {
            maxVal = numbers[i];
        }
    }
    mallinchu maxVal;
}

// Utility function to find minimum value
#min(numbers []int) int {
    @minVal int = numbers[0];
    @i int = 1;
    malli i < len(numbers); i = i + 1 {
        okavela numbers[i] < minVal {
            minVal = numbers[i];
        }
    }
    mallinchu minVal;
}

// Utility function to calculate average
#average(numbers []int) float {
    @sum int = sum(numbers);
    @count int = len(numbers);
    mallinchu (sum * 1.0) / count;
}

//

//

//

// === OUTPUT ===
// ERROR: Execution failed
// COMPILATION ERROR:
//
//     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.31s
//      Running `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\utils.tl`
//
// Parser Error at C:\Users\vanka\github.com\vasuvanka\tlang\examples\utils.tl:11:32: Cannot assign to variable 'i': variables are immutable by default. Use '@!i' to declare a mutable variable, or use a new variable declaration instead.
//
// Context (most recent call last):
//   1: while parsing function declaration
//
//
//   11 |     malli i < len(numbers); i = i + 1 {
//    |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// error: process didn't exit successfully: `target\debug\tlangc.exe compile C:\Users\vanka\github.com\vasuvanka\tlang\examples\utils.tl` (exit code: 1)
//
