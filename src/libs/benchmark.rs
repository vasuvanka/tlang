// testing/benchmark - Benchmarking library
// Provides benchmarking functionality similar to Go's testing/benchmark

pub fn generate_benchmark_lib() -> String {
    let mut code = String::new();
    
    // Include necessary headers
    code.push_str("#include <stdio.h>\n");
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n");
    code.push_str("#include <time.h>\n");
    code.push_str("\n");
    
    // Benchmark context structure
    code.push_str("// Benchmark context structure\n");
    code.push_str("typedef struct {\n");
    code.push_str("    char name[256];\n");
    code.push_str("    clock_t start_time;\n");
    code.push_str("    clock_t end_time;\n");
    code.push_str("    int running;\n");
    code.push_str("} BenchmarkContext;\n\n");
    
    // Global benchmark storage (max 100 benchmarks)
    code.push_str("#define MAX_BENCHMARKS 100\n");
    code.push_str("static BenchmarkContext benchmarks[MAX_BENCHMARKS];\n");
    code.push_str("static int benchmark_count = 0;\n\n");
    
    // Helper: Find or create benchmark
    code.push_str("static int find_or_create_benchmark(const char* name) {\n");
    code.push_str("    // Find existing benchmark\n");
    code.push_str("    for (int i = 0; i < benchmark_count; i++) {\n");
    code.push_str("        if (strcmp(benchmarks[i].name, name) == 0) {\n");
    code.push_str("            return i;\n");
    code.push_str("        }\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    // Create new benchmark\n");
    code.push_str("    if (benchmark_count >= MAX_BENCHMARKS) return -1;\n");
    code.push_str("    \n");
    code.push_str("    int idx = benchmark_count++;\n");
    code.push_str("    strncpy(benchmarks[idx].name, name, sizeof(benchmarks[idx].name) - 1);\n");
    code.push_str("    benchmarks[idx].name[sizeof(benchmarks[idx].name) - 1] = '\\0';\n");
    code.push_str("    benchmarks[idx].running = 0;\n");
    code.push_str("    \n");
    code.push_str("    return idx;\n");
    code.push_str("}\n\n");
    
    // benchmark.Start - Start benchmark
    code.push_str("// benchmark.Start - Start benchmark\n");
    code.push_str("void benchmark_Start(const char* name) {\n");
    code.push_str("    int idx = find_or_create_benchmark(name);\n");
    code.push_str("    if (idx < 0) return;\n");
    code.push_str("    \n");
    code.push_str("    benchmarks[idx].start_time = clock();\n");
    code.push_str("    benchmarks[idx].running = 1;\n");
    code.push_str("    benchmarks[idx].end_time = 0;\n");
    code.push_str("}\n\n");
    
    // benchmark.Stop - Stop benchmark and return duration in seconds
    code.push_str("// benchmark.Stop - Stop benchmark and return duration in seconds\n");
    code.push_str("double benchmark_Stop(const char* name) {\n");
    code.push_str("    int idx = find_or_create_benchmark(name);\n");
    code.push_str("    if (idx < 0) return -1.0;\n");
    code.push_str("    \n");
    code.push_str("    if (!benchmarks[idx].running) return -1.0;\n");
    code.push_str("    \n");
    code.push_str("    benchmarks[idx].end_time = clock();\n");
    code.push_str("    benchmarks[idx].running = 0;\n");
    code.push_str("    \n");
    code.push_str("    double duration = ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;\n");
    code.push_str("    \n");
    code.push_str("    return duration;\n");
    code.push_str("}\n\n");
    
    // benchmark.Report - Report benchmark results
    code.push_str("// benchmark.Report - Report benchmark results\n");
    code.push_str("void benchmark_Report(const char* name) {\n");
    code.push_str("    int idx = find_or_create_benchmark(name);\n");
    code.push_str("    if (idx < 0) return;\n");
    code.push_str("    \n");
    code.push_str("    if (benchmarks[idx].running) {\n");
    code.push_str("        printf(\"BENCHMARK %s: still running\\n\", name);\n");
    code.push_str("        return;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    if (benchmarks[idx].end_time == 0) {\n");
    code.push_str("        printf(\"BENCHMARK %s: not started\\n\", name);\n");
    code.push_str("        return;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    double duration = ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;\n");
    code.push_str("    printf(\"BENCHMARK %s: %.6f seconds\\n\", name, duration);\n");
    code.push_str("}\n\n");
    
    // benchmark.Reset - Reset benchmark
    code.push_str("// benchmark.Reset - Reset benchmark\n");
    code.push_str("void benchmark_Reset(const char* name) {\n");
    code.push_str("    int idx = find_or_create_benchmark(name);\n");
    code.push_str("    if (idx < 0) return;\n");
    code.push_str("    \n");
    code.push_str("    benchmarks[idx].running = 0;\n");
    code.push_str("    benchmarks[idx].start_time = 0;\n");
    code.push_str("    benchmarks[idx].end_time = 0;\n");
    code.push_str("}\n\n");
    
    // benchmark.GetDuration - Get duration without stopping
    code.push_str("// benchmark.GetDuration - Get current duration without stopping\n");
    code.push_str("double benchmark_GetDuration(const char* name) {\n");
    code.push_str("    int idx = find_or_create_benchmark(name);\n");
    code.push_str("    if (idx < 0) return -1.0;\n");
    code.push_str("    \n");
    code.push_str("    if (!benchmarks[idx].running) {\n");
    code.push_str("        if (benchmarks[idx].end_time > 0) {\n");
    code.push_str("            return ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;\n");
    code.push_str("        }\n");
    code.push_str("        return -1.0;\n");
    code.push_str("    }\n");
    code.push_str("    \n");
    code.push_str("    clock_t current = clock();\n");
    code.push_str("    return ((double)(current - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;\n");
    code.push_str("}\n\n");
    
    code
}
