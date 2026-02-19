// Minimal benchmark: math operations (used by run_benchmarks.sh / run_tests_and_benchmarks)
@fmt = #dhimpu("std/fmt");
@benchmark = #dhimpu("std/benchmark");
@math = #dhimpu("std/math");

#prarambham() {
    fmt.Printf("=== Benchmarks (math) ===\n");
    benchmark.Start("sqrt_loop");
    @!n int = 0;
    malli n < 50000; n = n + 1 {
        @x float = math.Sqrt(float(n));
        okavela x != x { fmt.Printf("nan"); }
    }
    @d float = benchmark.Stop("sqrt_loop");
    benchmark.Report("sqrt_loop");
    fmt.Printf("  (%.4fs)\n", d);
    fmt.Printf("OK\n");
}
