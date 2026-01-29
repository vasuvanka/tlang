// sort - Sorting library
// Ported from Go's sort package

pub fn generate_sort_lib() -> String {
    let mut code = String::new();
    
    code.push_str("#include <stdlib.h>\n");
    code.push_str("#include <string.h>\n\n");
    
    // Comparison function for qsort
    code.push_str("// Comparison function for integers\n");
    code.push_str("int int_compare(const void* a, const void* b) {\n");
    code.push_str("    int ia = *(const int*)a;\n");
    code.push_str("    int ib = *(const int*)b;\n");
    code.push_str("    return (ia > ib) - (ia < ib);\n");
    code.push_str("}\n\n");
    
    code.push_str("// Comparison function for floats\n");
    code.push_str("int float_compare(const void* a, const void* b) {\n");
    code.push_str("    double fa = *(const double*)a;\n");
    code.push_str("    double fb = *(const double*)b;\n");
    code.push_str("    return (fa > fb) - (fa < fb);\n");
    code.push_str("}\n\n");
    
    code.push_str("// Comparison function for strings\n");
    code.push_str("int string_compare(const void* a, const void* b) {\n");
    code.push_str("    const char** sa = (const char**)a;\n");
    code.push_str("    const char** sb = (const char**)b;\n");
    code.push_str("    return strcmp(*sa, *sb);\n");
    code.push_str("}\n\n");
    
    // Ints
    code.push_str("// sort.Ints - Sort integer array\n");
    code.push_str("void sort_Ints(int* arr, int len) {\n");
    code.push_str("    qsort(arr, len, sizeof(int), int_compare);\n");
    code.push_str("}\n\n");
    
    // Float64s
    code.push_str("// sort.Float64s - Sort float array\n");
    code.push_str("void sort_Float64s(double* arr, int len) {\n");
    code.push_str("    qsort(arr, len, sizeof(double), float_compare);\n");
    code.push_str("}\n\n");
    
    // Strings
    code.push_str("// sort.Strings - Sort string array\n");
    code.push_str("void sort_Strings(char** arr, int len) {\n");
    code.push_str("    qsort(arr, len, sizeof(char*), string_compare);\n");
    code.push_str("}\n\n");
    
    code
}
