#line 1 "examples/hello.tl"
#ifdef _WIN32
#include <winsock2.h>
#include <windows.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

// import std/fmt as fmt

// Forward declarations for runtime types
typedef struct Slice Slice;
typedef struct MapEntry MapEntry;
typedef struct Map Map;
typedef struct MapIterator MapIterator;

// Forward declarations for runtime functions
Slice* slice_create(void* data, int len, int cap);
Map* map_create(int key_type, int value_type);
int map_len(Map* m);
void* map_get(Map* m, void* key);
void map_set(Map* m, void* key, void* value);
MapIterator* map_iter(Map* m);
int map_next(MapIterator* iter, void** key_ptr, void** value_ptr);
void map_iter_free(MapIterator* iter);
char* json_UnmarshalString(const char* json);
Slice* json_UnmarshalArray(const char* json, const char* elem_type);
Map* json_UnmarshalMap(const char* json, int key_type, int value_type);
char* http_PostWithHeaders(const char* url, const char* data, const char* headers);
char* http_GetWithRedirects(const char* url, int max_redirects);
int net_Init(void);
void net_Cleanup(void);
int net_Dial(const char* host, int port);
int net_Send(int sockfd, const char* data, int len);
int net_Recv(int sockfd, char* buf, int len);
void net_Close(int sockfd);
int net_Listen(int port);
int net_Accept(int listenfd);

// Forward declarations for POSIX functions (Windows compatibility)
#ifdef _WIN32
// Windows: setenv is not available, use _putenv instead
int _putenv(const char* envstring);
#else
// POSIX: forward declare setenv
int setenv(const char* name, const char* value, int overwrite);
char* strptime(const char* s, const char* format, struct tm* tm);
#endif

// Slice structure for dynamic arrays
struct Slice {
    void* data;
    int len;
    int cap;
};

// Slice helper functions
int slice_len(Slice* s) { return s ? s->len : 0; }
int slice_cap(Slice* s) { return s ? s->cap : 0; }
void* slice_data(Slice* s) { return s ? s->data : NULL; }

// Create slice from array literal
Slice* slice_create(void* data, int len, int cap) {
    Slice* s = (Slice*)malloc(sizeof(Slice));
    if (!s) return NULL;
    s->data = data;
    s->len = len;
    s->cap = cap;
    return s;
}

// Append to slice (simplified implementation)
Slice* slice_append(Slice* s, void* elem, size_t elem_size) {
    if (!s) {
        s = slice_create(malloc(elem_size), 0, 1);
        if (!s) return NULL;
    }
    if (s->len >= s->cap) {
        int new_cap = s->cap == 0 ? 1 : s->cap * 2;
        s->data = realloc(s->data, new_cap * elem_size);
        if (!s->data) return NULL;
        s->cap = new_cap;
    }
    memcpy((char*)s->data + s->len * elem_size, elem, elem_size);
    s->len++;
    return s;
}

// Create slice from array/slice expression [start:end]
Slice* slice_create_slice(Slice* s, int start, int end) {
    if (!s || start < 0 || end < start) return NULL;
    if (end > s->len) end = s->len;
    Slice* new_slice = (Slice*)malloc(sizeof(Slice));
    if (!new_slice) return NULL;
    new_slice->data = (char*)s->data + start * sizeof(int); // Simplified - assumes int
    new_slice->len = end - start;
    new_slice->cap = s->cap - start;
    return new_slice;
}

// Create slice from array literal
Slice* slice_from_literal(void* arr, int len, size_t elem_size) {
    void* data = malloc(len * elem_size);
    if (!data) return NULL;
    memcpy(data, arr, len * elem_size);
    return slice_create(data, len, len);
}

// Map structure for key-value storage
struct MapEntry {
    void* key;
    void* value;
    struct MapEntry* next;  // For chaining in hash table
};

struct Map {
    MapEntry** buckets;
    int bucket_count;
    int size;
    int key_type;  // 0=string, 1=int, 2=float
    int value_type; // 0=int, 1=float, 2=string, 3=bool
    size_t key_size;
    size_t value_size;
};

// Map helper functions
Map* map_create(int key_type, int value_type) {
    Map* m = (Map*)malloc(sizeof(Map));
    if (!m) return NULL;
    m->bucket_count = 16;
    m->size = 0;
    m->key_type = key_type;
    m->value_type = value_type;
    m->buckets = (MapEntry**)calloc(m->bucket_count, sizeof(MapEntry*));
    m->key_size = (key_type == 0) ? sizeof(char*) : ((key_type == 1) ? sizeof(int) : sizeof(double));
    m->value_size = (value_type == 0) ? sizeof(int) : ((value_type == 1) ? sizeof(double) : ((value_type == 2) ? sizeof(char*) : sizeof(int)));
    return m;
}

int map_len(Map* m) { return m ? m->size : 0; }

static unsigned int map_hash_string(const char* s) {
    unsigned int hash = 5381;
    int c;
    while ((c = *s++)) hash = ((hash << 5) + hash) + c;
    return hash;
}

void* map_get(Map* m, void* key) {
    if (!m || !key) return NULL;
    unsigned int hash;
    if (m->key_type == 0) {  // string key
        hash = map_hash_string(*(char**)key) % m->bucket_count;
    } else if (m->key_type == 1) {  // int key
        hash = (*(int*)key) % m->bucket_count;
    } else {  // float key
        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;
    }
    MapEntry* entry = m->buckets[hash];
    while (entry) {
        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {
            return entry->value;
        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {
            return entry->value;
        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {
            return entry->value;
        }
        entry = entry->next;
    }
    return NULL;
}

void map_set(Map* m, void* key, void* value) {
    if (!m || !key) return;
    unsigned int hash;
    if (m->key_type == 0) {  // string key
        hash = map_hash_string(*(char**)key) % m->bucket_count;
    } else if (m->key_type == 1) {  // int key
        hash = (*(int*)key) % m->bucket_count;
    } else {  // float key
        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;
    }
    MapEntry* entry = m->buckets[hash];
    while (entry) {
        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {
            memcpy(entry->value, value, m->value_size);
            return;
        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {
            memcpy(entry->value, value, m->value_size);
            return;
        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {
            memcpy(entry->value, value, m->value_size);
            return;
        }
        entry = entry->next;
    }
    // Create new entry
    MapEntry* new_entry = (MapEntry*)malloc(sizeof(MapEntry));
    new_entry->key = malloc(m->key_size);
    new_entry->value = malloc(m->value_size);
    memcpy(new_entry->key, key, m->key_size);
    memcpy(new_entry->value, value, m->value_size);
    new_entry->next = m->buckets[hash];
    m->buckets[hash] = new_entry;
    m->size++;
}

// Delete key from map
void map_delete(Map* m, void* key) {
    if (!m || !key) return;
    unsigned int hash;
    if (m->key_type == 0) {  // string key
        hash = map_hash_string(*(char**)key) % m->bucket_count;
    } else if (m->key_type == 1) {  // int key
        hash = (*(int*)key) % m->bucket_count;
    } else {  // float key
        hash = ((unsigned int)(*(double*)key)) % m->bucket_count;
    }
    MapEntry* entry = m->buckets[hash];
    MapEntry* prev = NULL;
    while (entry) {
        int match = 0;
        if (m->key_type == 0 && strcmp(*(char**)entry->key, *(char**)key) == 0) {
            match = 1;
        } else if (m->key_type == 1 && *(int*)entry->key == *(int*)key) {
            match = 1;
        } else if (m->key_type == 2 && *(double*)entry->key == *(double*)key) {
            match = 1;
        }
        if (match) {
            if (prev) {
                prev->next = entry->next;
            } else {
                m->buckets[hash] = entry->next;
            }
            free(entry->key);
            free(entry->value);
            free(entry);
            m->size--;
            return;
        }
        prev = entry;
        entry = entry->next;
    }
}

// Map iteration helpers
struct MapIterator {
    Map* map;
    int bucket_index;
    MapEntry* current_entry;
};

// Initialize map iterator
MapIterator* map_iter(Map* m) {
    if (!m) return NULL;
    MapIterator* iter = (MapIterator*)malloc(sizeof(MapIterator));
    if (!iter) return NULL;
    iter->map = m;
    iter->bucket_index = 0;
    iter->current_entry = NULL;
    // Find first entry
    for (int i = 0; i < m->bucket_count; i++) {
        if (m->buckets[i]) {
            iter->bucket_index = i;
            iter->current_entry = m->buckets[i];
            break;
        }
    }
    return iter;
}

// Get next key-value pair from iterator
int map_next(MapIterator* iter, void** key, void** value) {
    if (!iter || !iter->map) return 0;
    if (!iter->current_entry) return 0;
    
    *key = iter->current_entry->key;
    *value = iter->current_entry->value;
    
    // Move to next entry
    if (iter->current_entry->next) {
        iter->current_entry = iter->current_entry->next;
    } else {
        // Move to next bucket
        iter->bucket_index++;
        iter->current_entry = NULL;
        for (int i = iter->bucket_index; i < iter->map->bucket_count; i++) {
            if (iter->map->buckets[i]) {
                iter->bucket_index = i;
                iter->current_entry = iter->map->buckets[i];
                break;
            }
        }
    }
    return 1;
}

// ========== Standard Library ==========
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

// ========== fmt library ==========
// fmt.Print - Prints arguments without newline
void fmt_Print(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
}

// fmt.Println - Prints arguments with newline
void fmt_Println(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    printf("\n");
    va_end(args);
}

// fmt.Printf - Formatted printing
void fmt_Printf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
}

// fmt.Sprint - Returns formatted string
char* fmt_Sprint(const char* format, ...) {
    static char buffer[1024];
    va_list args;
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);
    return buffer;
}

// fmt.Sprintf - Returns formatted string
char* fmt_Sprintf(const char* format, ...) {
    static char buffer[1024];
    va_list args;
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);
    return buffer;
}

// fmt.Scan - Reads from stdin
int fmt_Scan(const char* format, ...) {
    va_list args;
    va_start(args, format);
    int result = vscanf(format, args);
    va_end(args);
    return result;
}

// fmt.Scanf - Formatted input
int fmt_Scanf(const char* format, ...) {
    va_list args;
    va_start(args, format);
    int result = vscanf(format, args);
    va_end(args);
    return result;
}


// ========== strings library ==========
#include <string.h>
#include <ctype.h>

// strings.Contains - Checks if string contains substring
int strings_Contains(const char* s, const char* substr) {
    return strstr(s, substr) != NULL ? 1 : 0;
}

// strings.HasPrefix - Checks if string has prefix
int strings_HasPrefix(const char* s, const char* prefix) {
    size_t len = strlen(prefix);
    return strncmp(s, prefix, len) == 0 ? 1 : 0;
}

// strings.HasSuffix - Checks if string has suffix
int strings_HasSuffix(const char* s, const char* suffix) {
    size_t len_s = strlen(s);
    size_t len_suffix = strlen(suffix);
    if (len_suffix > len_s) return 0;
    return strcmp(s + len_s - len_suffix, suffix) == 0 ? 1 : 0;
}

// strings.Index - Returns index of substring
int strings_Index(const char* s, const char* substr) {
    char* pos = strstr(s, substr);
    return pos ? (int)(pos - s) : -1;
}

// strings.ToUpper - Converts to uppercase
char* strings_ToUpper(const char* s) {
    static char buffer[1024];
    strncpy(buffer, s, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0';
    for (int i = 0; buffer[i]; i++) {
        buffer[i] = toupper(buffer[i]);
    }
    return buffer;
}

// strings.ToLower - Converts to lowercase
char* strings_ToLower(const char* s) {
    static char buffer[1024];
    strncpy(buffer, s, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0';
    for (int i = 0; buffer[i]; i++) {
        buffer[i] = tolower(buffer[i]);
    }
    return buffer;
}

// strings.TrimSpace - Removes leading and trailing whitespace
char* strings_TrimSpace(const char* s) {
    static char buffer[1024];
    int start = 0;
    int end = strlen(s) - 1;
    while (isspace(s[start]) && start <= end) start++;
    while (isspace(s[end]) && end >= start) end--;
    int len = end - start + 1;
    if (len < 0) len = 0;
    strncpy(buffer, s + start, len);
    buffer[len] = '\0';
    return buffer;
}


// ========== math library ==========
#include <math.h>

// math.Pi - Pi constant
double math_Pi() { return 3.14159265358979323846; }

// math.E - Euler's number
double math_E() { return 2.71828182845904523536; }

// math.Abs - Absolute value
double math_Abs(double x) { return fabs(x); }

// math.Max - Maximum of two values
double math_Max(double x, double y) { return x > y ? x : y; }

// math.Min - Minimum of two values
double math_Min(double x, double y) { return x < y ? x : y; }

// math.Sqrt - Square root
double math_Sqrt(double x) { return sqrt(x); }

// math.Pow - Power (x^y)
double math_Pow(double x, double y) { return pow(x, y); }

// math.Exp - e^x
double math_Exp(double x) { return exp(x); }

// math.Log - Natural logarithm
double math_Log(double x) { return log(x); }

// math.Log10 - Base 10 logarithm
double math_Log10(double x) { return log10(x); }

// math.Sin - Sine
double math_Sin(double x) { return sin(x); }

// math.Cos - Cosine
double math_Cos(double x) { return cos(x); }

// math.Tan - Tangent
double math_Tan(double x) { return tan(x); }

// math.Asin - Arc sine
double math_Asin(double x) { return asin(x); }

// math.Acos - Arc cosine
double math_Acos(double x) { return acos(x); }

// math.Atan - Arc tangent
double math_Atan(double x) { return atan(x); }

// math.Atan2 - Arc tangent of y/x
double math_Atan2(double y, double x) { return atan2(y, x); }

// math.Ceil - Ceiling (round up)
double math_Ceil(double x) { return ceil(x); }

// math.Floor - Floor (round down)
double math_Floor(double x) { return floor(x); }

// math.Round - Round to nearest integer
double math_Round(double x) { return round(x); }

// math.Trunc - Truncate (remove fractional part)
double math_Trunc(double x) { return trunc(x); }


// ========== strconv library ==========
#include <stdlib.h>
#include <stdio.h>

// strconv.Atoi - String to integer
int strconv_Atoi(const char* s) {
    return atoi(s);
}

// strconv.Itoa - Integer to string
char* strconv_Itoa(int i) {
    static char buffer[32];
    snprintf(buffer, sizeof(buffer), "%d", i);
    return buffer;
}

// strconv.ParseFloat - String to float
double strconv_ParseFloat(const char* s) {
    return atof(s);
}

// strconv.FormatFloat - Float to string
char* strconv_FormatFloat(double f, int prec) {
    static char buffer[64];
    char format[16];
    snprintf(format, sizeof(format), "%%.%df", prec);
    snprintf(buffer, sizeof(buffer), format, f);
    return buffer;
}

// strconv.ParseBool - String to boolean
int strconv_ParseBool(const char* s) {
    if (strcmp(s, "true") == 0 || strcmp(s, "1") == 0) return 1;
    if (strcmp(s, "false") == 0 || strcmp(s, "0") == 0) return 0;
    return -1; // error
}

// strconv.FormatBool - Boolean to string
char* strconv_FormatBool(int b) {
    return b ? "true" : "false";
}


// ========== os library ==========
#include <stdlib.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#include <io.h>
#else
#include <unistd.h>
#endif

// os.Getenv - Get environment variable
char* os_Getenv(const char* key) {
    char* value = getenv(key);
    return value ? value : "";
}

// os.Setenv - Set environment variable
int os_Setenv(const char* key, const char* value) {
#ifdef _WIN32
    // Windows: use _putenv_s or SetEnvironmentVariable
    char* env_str = (char*)malloc(strlen(key) + strlen(value) + 2);
    if (!env_str) return -1;
    sprintf(env_str, "%s=%s", key, value);
    int result = _putenv(env_str);
    free(env_str);
    return result == 0 ? 0 : -1;
#else
    return setenv(key, value, 1);
#endif
}

// os.Exit - Exit program with status code
void os_Exit(int code) {
    exit(code);
}

// os.Getwd - Get current working directory
char* os_Getwd() {
    static char buffer[1024];
    if (getcwd(buffer, sizeof(buffer)) != NULL) {
        return buffer;
    }
    return "";
}

// os.Chdir - Change directory
int os_Chdir(const char* path) {
    return chdir(path);
}


// ========== time library ==========
#include <time.h>
#include <stdio.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

// time.Now - Current time as Unix timestamp
long time_Now() {
    return (long)time(NULL);
}

// time.Sleep - Sleep for specified seconds
void time_Sleep(int seconds) {
#ifdef _WIN32
    Sleep(seconds * 1000);
#else
    sleep(seconds);
#endif
}

// time.SleepMilliseconds - Sleep for milliseconds
void time_SleepMilliseconds(int ms) {
#ifdef _WIN32
    Sleep(ms);
#else
    usleep(ms * 1000);
#endif
}

// time.Format - Format Unix timestamp to string
char* time_Format(long timestamp, const char* format) {
    static char buffer[128];
    struct tm* timeinfo;
    time_t t = (time_t)timestamp;
    timeinfo = localtime(&t);
    strftime(buffer, sizeof(buffer), format, timeinfo);
    return buffer;
}

// time.Parse - Parse time string to Unix timestamp
long time_Parse(const char* timeStr, const char* format) {
#ifdef _WIN32
    // Windows: strptime is not available, use sscanf as fallback
    // This is a simplified implementation - full strptime would be more complex
    struct tm tm = {0};
    // Try common formats: "%Y-%m-%d %H:%M:%S" or "%Y-%m-%d"
    if (sscanf(timeStr, "%d-%d-%d %d:%d:%d", &tm.tm_year, &tm.tm_mon, &tm.tm_mday, &tm.tm_hour, &tm.tm_min, &tm.tm_sec) == 6) {
        tm.tm_year -= 1900;
        tm.tm_mon -= 1;
        return (long)mktime(&tm);
    } else if (sscanf(timeStr, "%d-%d-%d", &tm.tm_year, &tm.tm_mon, &tm.tm_mday) == 3) {
        tm.tm_year -= 1900;
        tm.tm_mon -= 1;
        return (long)mktime(&tm);
    }
    return -1; // error
#else
    struct tm tm = {0};
    if (strptime(timeStr, format, &tm) != NULL) {
        return (long)mktime(&tm);
    }
    return -1; // error
#endif
}


// ========== bytes library ==========
#include <string.h>

// bytes.Contains - Check if bytes contain subslice
int bytes_Contains(const char* b, int len, const char* sub, int sublen) {
    if (sublen == 0) return 1;
    if (sublen > len) return 0;
    for (int i = 0; i <= len - sublen; i++) {
        if (memcmp(b + i, sub, sublen) == 0) {
            return 1;
        }
    }
    return 0;
}

// bytes.Index - Find index of subslice
int bytes_Index(const char* b, int len, const char* sub, int sublen) {
    if (sublen == 0) return 0;
    if (sublen > len) return -1;
    for (int i = 0; i <= len - sublen; i++) {
        if (memcmp(b + i, sub, sublen) == 0) {
            return i;
        }
    }
    return -1;
}

// bytes.Equal - Compare two byte slices
int bytes_Equal(const char* a, int lenA, const char* b, int lenB) {
    if (lenA != lenB) return 0;
    return memcmp(a, b, lenA) == 0 ? 1 : 0;
}


// ========== sort library ==========
#include <stdlib.h>
#include <string.h>

// Comparison function for integers
int int_compare(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib);
}

// Comparison function for floats
int float_compare(const void* a, const void* b) {
    double fa = *(const double*)a;
    double fb = *(const double*)b;
    return (fa > fb) - (fa < fb);
}

// Comparison function for strings
int string_compare(const void* a, const void* b) {
    const char** sa = (const char**)a;
    const char** sb = (const char**)b;
    return strcmp(*sa, *sb);
}

// sort.Ints - Sort integer array
void sort_Ints(int* arr, int len) {
    qsort(arr, len, sizeof(int), int_compare);
}

// sort.Float64s - Sort float array
void sort_Float64s(double* arr, int len) {
    qsort(arr, len, sizeof(double), float_compare);
}

// sort.Strings - Sort string array
void sort_Strings(char** arr, int len) {
    qsort(arr, len, sizeof(char*), string_compare);
}


// ========== json library ==========
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Helper: Escape JSON string
char* json_escape(const char* s) {
    static char buffer[4096];
    int j = 0;
    buffer[j++] = '"';
    for (int i = 0; s[i] && j < sizeof(buffer) - 2; i++) {
        if (s[i] == '"') {
            buffer[j++] = '\\';
            buffer[j++] = '"';
        } else if (s[i] == '\\') {
            buffer[j++] = '\\';
            buffer[j++] = '\\';
        } else if (s[i] == '\n') {
            buffer[j++] = '\\';
            buffer[j++] = 'n';
        } else {
            buffer[j++] = s[i];
        }
    }
    buffer[j++] = '"';
    buffer[j] = '\0';
    return buffer;
}

// json.Marshal - Encode value to JSON string
// Automatically handles structs (via compiler-generated functions), arrays, maps, and basic types
// Usage: json.Marshal(value) - value can be struct pointer, array, map, or basic type
// For structs: json.Marshal(&struct_instance) uses compiler-generated json_marshal_<structname>()
// For arrays/slices: json.Marshal(slice) uses json_MarshalSliceEnhanced
// For maps: json.Marshal(map) uses json_MarshalMap
// For basic types: json.Marshal(type, value) - legacy support
char* json_Marshal(const char* type, const char* value) {
    static char buffer[1024];
    if (strcmp(type, "string") == 0) {
        snprintf(buffer, sizeof(buffer), "%s", json_escape(value));
    } else if (strcmp(type, "int") == 0) {
        snprintf(buffer, sizeof(buffer), "%s", value);
    } else if (strcmp(type, "float") == 0) {
        snprintf(buffer, sizeof(buffer), "%s", value);
    } else if (strcmp(type, "bool") == 0) {
        snprintf(buffer, sizeof(buffer), "%s", value);
    } else {
        snprintf(buffer, sizeof(buffer), "null");
    }
    return buffer;
}

// Note: For structs, arrays, and maps, use compiler-generated functions directly:
// - json_marshal_<structname>(struct_ptr) for structs
// - json_MarshalSliceEnhanced(slice, elem_type) for arrays/slices
// - json_MarshalMap(map) for maps

// JSON Parser State with Error Tracking
typedef struct JSONParser {
    const char* json;
    int pos;
    int len;
    int line;
    int column;
    char* error_msg;
} JSONParser;

// Initialize JSON parser
void json_parser_init(JSONParser* p, const char* json) {
    if (!p || !json) return;
    p->json = json;
    p->pos = 0;
    p->len = strlen(json);
    p->line = 1;
    p->column = 1;
    p->error_msg = NULL;
}

// Set parser error message
void json_parser_set_error(JSONParser* p, const char* msg) {
    if (!p || !msg) return;
    if (p->error_msg) free(p->error_msg);
    int len = strlen(msg) + 64;  // Extra space for position info
    p->error_msg = (char*)malloc(len);
    if (p->error_msg) {
        snprintf(p->error_msg, len, "JSON error at line %d, column %d: %s", p->line, p->column, msg);
    }
}

// Get parser error message
char* json_parser_get_error(JSONParser* p) {
    return p ? p->error_msg : NULL;
}

// Update parser position (track line/column)
void json_parser_advance(JSONParser* p, int count) {
    if (!p) return;
    for (int i = 0; i < count && p->pos < p->len; i++) {
        if (p->json[p->pos] == '\n') {
            p->line++;
            p->column = 1;
        } else {
            p->column++;
        }
        p->pos++;
    }
}

// Skip whitespace in JSON (with position tracking)
void json_skip_whitespace(JSONParser* p) {
    if (!p) return;
    while (p->pos < p->len) {
        char c = p->json[p->pos];
        if (c == ' ' || c == '\t' || c == '\n' || c == '\r') {
            json_parser_advance(p, 1);
        } else {
            break;
        }
    }
}

// json.UnmarshalString - Enhanced with error reporting
char* json_UnmarshalStringWithError(const char* json, char** error_out) {
    if (error_out) *error_out = NULL;
    if (!json) {
        if (error_out) {
            *error_out = (char*)malloc(64);
            if (*error_out) strcpy(*error_out, "JSON error: null input");
        }
        return NULL;
    }
    if (json[0] != '\"') {
        if (error_out) {
            *error_out = (char*)malloc(128);
            if (*error_out) snprintf(*error_out, 128, "JSON error: expected string, got '%c' at position 0", json[0]);
        }
        return NULL;
    }
    int len = strlen(json);
    if (json[len-1] != '\"') {
        if (error_out) {
            *error_out = (char*)malloc(128);
            if (*error_out) snprintf(*error_out, 128, "JSON error: unterminated string (missing closing quote at position %d)", len-1);
        }
        return NULL;
    }
    // Continue with existing parsing logic...
    return json_UnmarshalString(json);
}

// json.UnmarshalString - Parse JSON string value
char* json_UnmarshalString(const char* json) {
    if (!json || json[0] != '\"') return NULL;
    int len = strlen(json);
    if (json[len-1] != '\"') return NULL;
    
    // Allocate memory for unquoted string
    char* result = (char*)malloc(len - 1);
    if (!result) return NULL;
    
    int j = 0;
    int escape = 0;
    for (int i = 1; i < len - 1; i++) {
        if (escape) {
            if (json[i] == 'n') result[j++] = '\n';
            else if (json[i] == 't') result[j++] = '\t';
            else if (json[i] == 'r') result[j++] = '\r';
            else if (json[i] == '\\') result[j++] = '\\';
            else if (json[i] == '\"') result[j++] = '\"';
            else result[j++] = json[i];
            escape = 0;
        } else if (json[i] == '\\') {
            escape = 1;
        } else {
            result[j++] = json[i];
        }
    }
    result[j] = '\0';
    return result;
}

// Internal helper: json_UnmarshalInt - Parse JSON number to int
// Note: This is an internal helper used by compiler-generated struct unmarshal functions
int json_UnmarshalInt(const char* json) {
    if (!json) return 0;
    // Skip whitespace
    int i = 0;
    while (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r') i++;
    
    // Parse integer
    int sign = 1;
    if (json[i] == '-') {
        sign = -1;
        i++;
    }
    
    int result = 0;
    while (json[i] >= '0' && json[i] <= '9') {
        result = result * 10 + (json[i] - '0');
        i++;
    }
    return result * sign;
}

// json.UnmarshalFloat - Parse JSON number to float
double json_UnmarshalFloat(const char* json) {
    if (!json) return 0.0;
    // Use strtod for proper float parsing
    return strtod(json, NULL);
}

// Internal helper: json_UnmarshalBool - Parse JSON boolean
// Note: This is an internal helper used by compiler-generated struct unmarshal functions
int json_UnmarshalBool(const char* json) {
    if (!json) return 0;
    // Skip whitespace
    int i = 0;
    while (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r') i++;
    
    // Check for true/false
    if (strncmp(json + i, "true", 4) == 0) return 1;
    if (strncmp(json + i, "false", 5) == 0) return 0;
    return 0;
}

// json.UnmarshalArray - Parse JSON array to slice
// Note: Simplified implementation - handles arrays of basic types
Slice* json_UnmarshalArray(const char* json, const char* elem_type) {
    if (!json || json[0] != '[') return NULL;
    
    // Count elements (simplified - just count commas + 1)
    int count = 1;
    int in_string = 0;
    for (int i = 1; json[i] && json[i] != ']'; i++) {
        if (json[i] == '\"' && (i == 0 || json[i-1] != '\\')) {
            in_string = !in_string;
        } else if (!in_string && json[i] == ',') {
            count++;
        }
    }
    
    // Allocate slice
    size_t elem_size = 0;
    if (strcmp(elem_type, "int") == 0) elem_size = sizeof(int);
    else if (strcmp(elem_type, "float") == 0) elem_size = sizeof(double);
    else if (strcmp(elem_type, "string") == 0) elem_size = sizeof(char*);
    else if (strcmp(elem_type, "bool") == 0) elem_size = sizeof(int);
    else return NULL;
    
    void* data = malloc(count * elem_size);
    if (!data) return NULL;
    
    Slice* slice = (Slice*)malloc(sizeof(Slice));
    if (!slice) { free(data); return NULL; }
    slice->data = data;
    slice->len = count;
    slice->cap = count;
    
    // Parse elements (simplified - extract between commas)
    int elem_idx = 0;
    int start = 1;  // Skip '['
    for (int i = 1; json[i] && json[i] != ']'; i++) {
        if (json[i] == ',' || json[i] == ']') {
            // Extract element
            int len = i - start;
            char* elem_str = (char*)malloc(len + 1);
            strncpy(elem_str, json + start, len);
            elem_str[len] = '\0';
            
            // Convert based on type
            if (strcmp(elem_type, "int") == 0) {
                ((int*)data)[elem_idx] = json_UnmarshalInt(elem_str);
            } else if (strcmp(elem_type, "float") == 0) {
                ((double*)data)[elem_idx] = json_UnmarshalFloat(elem_str);
            } else if (strcmp(elem_type, "string") == 0) {
                ((char**)data)[elem_idx] = json_UnmarshalString(elem_str);
            } else if (strcmp(elem_type, "bool") == 0) {
                ((int*)data)[elem_idx] = json_UnmarshalBool(elem_str);
            }
            
            free(elem_str);
            elem_idx++;
            start = i + 1;
            // Skip whitespace
            while (start < strlen(json) && (json[start] == ' ' || json[start] == '\t')) start++;
        }
    }
    
    return slice;
}

// json.Unmarshal - Generic JSON decoding
// Automatically handles structs (via compiler-generated functions), arrays, maps, and basic types
// Usage: json.Unmarshal(json, type) - type can be struct name, array type, map type, or basic type
// For structs: json.Unmarshal(json, "StructName") uses compiler-generated json_unmarshal_<structname>()
// For arrays: json.Unmarshal(json, "[]elem_type") uses internal array parsing
// For maps: json.Unmarshal(json, "jatha[key]value") uses internal map parsing
// For basic types: json.Unmarshal(json, "int") etc.
char* json_Unmarshal(const char* json, const char* type) {
    if (!json || !type) return NULL;
    
    // Skip whitespace
    int i = 0;
    while (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r') i++;
    
    static char buffer[1024];
    
    // Check if type is array: []type
    if (type[0] == '[' && type[1] == ']') {
        // Array/slice type - extract element type
        const char* elem_type = type + 2;  // Skip "[]"
        // Use internal array unmarshal (but return as string representation for compatibility)
        // Note: For direct array/slice assignment, use compiler-generated code
        return "[array]";  // Placeholder - actual implementation uses compiler-generated code
    }
    
    // Check if type is map: rasi[key]value
    if (strncmp(type, "rasi", 4) == 0 && strchr(type, '[') != NULL) {
        // Map type - use internal map unmarshal
        // Note: For direct map assignment, use compiler-generated code
        return "{map}";  // Placeholder - actual implementation uses compiler-generated code
    }
    
    // Basic types
    if (strcmp(type, "string") == 0) {
        char* result = json_UnmarshalString(json + i);
        if (result) {
            strncpy(buffer, result, sizeof(buffer) - 1);
            buffer[sizeof(buffer) - 1] = '\0';
            free(result);
            return buffer;
        }
    } else if (strcmp(type, "int") == 0) {
        int val = json_UnmarshalInt(json + i);
        snprintf(buffer, sizeof(buffer), "%d", val);
        return buffer;
    } else if (strcmp(type, "float") == 0) {
        double val = json_UnmarshalFloat(json + i);
        snprintf(buffer, sizeof(buffer), "%.6g", val);
        return buffer;
    } else if (strcmp(type, "bool") == 0) {
        int val = json_UnmarshalBool(json + i);
        snprintf(buffer, sizeof(buffer), "%d", val);
        return buffer;
    }
    
    // For struct types, use compiler-generated functions (called directly, not through this function)
    // This function is mainly for basic types
    
    // Fallback: remove quotes if string
    if (json[i] == '\"' && json[strlen(json + i) - 1] == '\"') {
        int len = strlen(json + i) - 2;
        strncpy(buffer, json + i + 1, len);
        buffer[len] = '\0';
        return buffer;
    }
    strncpy(buffer, json + i, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0';
    return buffer;
}

// json_GetObjectValue - Extract value from JSON object by key
// Returns: Pointer to start of value, or NULL if not found
// Note: Returns pointer into original string, caller should copy if needed
const char* json_GetObjectValue(const char* json, const char* key) {
    if (!json || !key || json[0] != '{') return NULL;
    
    int key_len = strlen(key);
    int json_len = strlen(json);
    int i = 1;  // Skip '{'
    
    // Skip whitespace
    while (i < json_len && (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r')) i++;
    
    while (i < json_len && json[i] != '}') {
        // Skip whitespace
        while (i < json_len && (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r')) i++;
        if (i >= json_len || json[i] == '}') break;
        
        // Check if this is our key
        if (json[i] == '\"') {
            i++;  // Skip opening quote
            int key_start = i;
            // Find end of key
            while (i < json_len && json[i] != '\"' && json[i] != '\\') i++;
            int key_end = i;
            if (i < json_len && json[i] == '\"') i++;  // Skip closing quote
            
            // Compare key
            if (key_end - key_start == key_len && strncmp(json + key_start, key, key_len) == 0) {
                // Found the key, now find the value
                // Skip whitespace and colon
                while (i < json_len && (json[i] == ' ' || json[i] == '\t' || json[i] == ':')) i++;
                // Skip whitespace after colon
                while (i < json_len && (json[i] == ' ' || json[i] == '\t')) i++;
                
                // Find end of value
                int value_start = i;
                int in_string = 0;
                int depth = 0;  // For nested objects/arrays
                
                while (i < json_len) {
                    if (json[i] == '\"' && (i == 0 || json[i-1] != '\\')) {
                        in_string = !in_string;
                    } else if (!in_string) {
                        if (json[i] == '{' || json[i] == '[') depth++;
                        else if (json[i] == '}' || json[i] == ']') {
                            if (depth == 0) {
                                i++;
                                break;
                            }
                            depth--;
                        } else if (depth == 0 && (json[i] == ',' || json[i] == '}')) {
                            break;
                        }
                    }
                    i++;
                }
                
                // Extract value substring
                int value_len = i - value_start;
                char* value = (char*)malloc(value_len + 1);
                if (!value) return NULL;
                strncpy(value, json + value_start, value_len);
                value[value_len] = '\0';
                return value;
            }
            
            // Not our key, skip to next field
            // Skip to comma or closing brace
            int in_string = 0;
            int depth = 0;
            while (i < json_len && json[i] != '}') {
                if (json[i] == '\"' && (i == 0 || json[i-1] != '\\')) {
                    in_string = !in_string;
                } else if (!in_string) {
                    if (json[i] == '{' || json[i] == '[') depth++;
                    else if (json[i] == '}' || json[i] == ']') depth--;
                    else if (depth == 0 && json[i] == ',') {
                        i++;
                        break;
                    }
                }
                i++;
            }
        } else {
            // Invalid JSON, skip character
            i++;
        }
    }
    
    return NULL;  // Key not found
}

// json.UnmarshalStruct - Parse JSON object to struct (generic helper)
// Note: This is a generic helper. For automatic unmarshaling, use compiler-generated functions.
// This function extracts field values from JSON object.
void json_UnmarshalStruct(const char* json, const char* field_name, void* field_ptr, const char* field_type) {
    if (!json || !field_name || !field_ptr || !field_type) return;
    
    const char* value_json = json_GetObjectValue(json, field_name);
    if (!value_json) return;  // Field not found
    
    // Convert based on type
    if (strcmp(field_type, "int") == 0) {
        *(int*)field_ptr = json_UnmarshalInt(value_json);
    } else if (strcmp(field_type, "float") == 0) {
        *(double*)field_ptr = json_UnmarshalFloat(value_json);
    } else if (strcmp(field_type, "string") == 0) {
        char* str_val = json_UnmarshalString(value_json);
        if (str_val) {
            *(char**)field_ptr = str_val;
        }
    } else if (strcmp(field_type, "bool") == 0) {
        *(int*)field_ptr = json_UnmarshalBool(value_json);
    }
    
    // Free the extracted value string
    free((void*)value_json);
}

// json_GetObjectKeys - Extract all keys from JSON object
// Returns: Array of key strings (caller must free)
char** json_GetObjectKeys(const char* json, int* key_count) {
    if (!json || !key_count || json[0] != '{') { *key_count = 0; return NULL; }
    
    // First pass: count keys
    int count = 0;
    int json_len = strlen(json);
    int i = 1;  // Skip '{'
    
    while (i < json_len && json[i] != '}') {
        // Skip whitespace
        while (i < json_len && (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r')) i++;
        if (i >= json_len || json[i] == '}') break;
        
        // Check for key
        if (json[i] == '\"') {
            count++;
            i++;  // Skip opening quote
            // Skip to end of key
            while (i < json_len && json[i] != '\"' && json[i] != '\\') i++;
            if (i < json_len && json[i] == '\"') i++;  // Skip closing quote
            
            // Skip to next key (skip value)
            while (i < json_len && json[i] != ':' && json[i] != '}') i++;
            if (i < json_len && json[i] == ':') i++;  // Skip colon
            
            // Skip value
            int in_string = 0;
            int depth = 0;
            while (i < json_len && json[i] != '}') {
                if (json[i] == '\"' && (i == 0 || json[i-1] != '\\')) {
                    in_string = !in_string;
                } else if (!in_string) {
                    if (json[i] == '{' || json[i] == '[') depth++;
                    else if (json[i] == '}' || json[i] == ']') {
                        if (depth == 0) break;
                        depth--;
                    } else if (depth == 0 && json[i] == ',') {
                        i++;
                        break;
                    }
                }
                i++;
            }
        } else {
            i++;
        }
    }
    
    if (count == 0) { *key_count = 0; return NULL; }
    
    // Allocate array for keys
    char** keys = (char**)malloc(count * sizeof(char*));
    if (!keys) { *key_count = 0; return NULL; }
    
    // Second pass: extract keys
    count = 0;
    i = 1;  // Skip '{'
    
    while (i < json_len && json[i] != '}') {
        // Skip whitespace
        while (i < json_len && (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r')) i++;
        if (i >= json_len || json[i] == '}') break;
        
        // Extract key
        if (json[i] == '\"') {
            i++;  // Skip opening quote
            int key_start = i;
            // Find end of key
            while (i < json_len && json[i] != '\"' && json[i] != '\\') i++;
            int key_end = i;
            if (i < json_len && json[i] == '\"') i++;  // Skip closing quote
            
            // Allocate and copy key
            int key_len = key_end - key_start;
            keys[count] = (char*)malloc(key_len + 1);
            if (keys[count]) {
                strncpy(keys[count], json + key_start, key_len);
                keys[count][key_len] = '\0';
                count++;
            }
            
            // Skip to next key (skip value)
            while (i < json_len && json[i] != ':' && json[i] != '}') i++;
            if (i < json_len && json[i] == ':') i++;  // Skip colon
            
            // Skip value
            int in_string = 0;
            int depth = 0;
            while (i < json_len && json[i] != '}') {
                if (json[i] == '\"' && (i == 0 || json[i-1] != '\\')) {
                    in_string = !in_string;
                } else if (!in_string) {
                    if (json[i] == '{' || json[i] == '[') depth++;
                    else if (json[i] == '}' || json[i] == ']') {
                        if (depth == 0) break;
                        depth--;
                    } else if (depth == 0 && json[i] == ',') {
                        i++;
                        break;
                    }
                }
                i++;
            }
        } else {
            i++;
        }
    }
    
    *key_count = count;
    return keys;
}

// Internal helper: json_UnmarshalMap - Parse JSON object to map
// Note: This is an internal helper used by compiler-generated struct unmarshal functions
// For direct map unmarshaling, use json.Unmarshal() which calls this internally
// key_type: 0=string, 1=int, 2=float
// value_type: 0=int, 1=float, 2=string, 3=bool
Map* json_UnmarshalMap(const char* json, int key_type, int value_type) {
    if (!json || json[0] != '{') return NULL;
    
    // Create map
    Map* m = map_create(key_type, value_type);
    if (!m) return NULL;
    
    // Get all keys
    int key_count = 0;
    char** keys = json_GetObjectKeys(json, &key_count);
    if (!keys || key_count == 0) {
        // Empty object
        return m;
    }
    
    // Extract and set each key-value pair
    for (int i = 0; i < key_count; i++) {
        const char* value_json = json_GetObjectValue(json, keys[i]);
        if (!value_json) continue;
        
        // Allocate key
        void* key_ptr = NULL;
        if (key_type == 0) {  // string key
            key_ptr = malloc(sizeof(char*));
            if (key_ptr) {
                *(char**)key_ptr = keys[i];  // Reuse allocated key string
            }
        } else if (key_type == 1) {  // int key
            key_ptr = malloc(sizeof(int));
            if (key_ptr) {
                *(int*)key_ptr = json_UnmarshalInt(keys[i]);
            }
        } else if (key_type == 2) {  // float key
            key_ptr = malloc(sizeof(double));
            if (key_ptr) {
                *(double*)key_ptr = json_UnmarshalFloat(keys[i]);
            }
        }
        
        if (!key_ptr) {
            free((void*)value_json);
            continue;
        }
        
        // Allocate and convert value
        void* value_ptr = NULL;
        if (value_type == 0) {  // int value
            value_ptr = malloc(sizeof(int));
            if (value_ptr) {
                *(int*)value_ptr = json_UnmarshalInt(value_json);
            }
        } else if (value_type == 1) {  // float value
            value_ptr = malloc(sizeof(double));
            if (value_ptr) {
                *(double*)value_ptr = json_UnmarshalFloat(value_json);
            }
        } else if (value_type == 2) {  // string value
            value_ptr = malloc(sizeof(char*));
            if (value_ptr) {
                char* str_val = json_UnmarshalString(value_json);
                *(char**)value_ptr = str_val;
            }
        } else if (value_type == 3) {  // bool value
            value_ptr = malloc(sizeof(int));
            if (value_ptr) {
                *(int*)value_ptr = json_UnmarshalBool(value_json);
            }
        }
        
        if (value_ptr) {
            map_set(m, key_ptr, value_ptr);
        } else {
            free(key_ptr);
        }
        
        free((void*)value_json);
    }
    
    // Free keys array (but not the key strings - they're used in map)
    // For string keys, the strings are stored in the map, so we don't free them
    // For non-string keys, we can free the key strings
    if (key_type != 0) {
        for (int i = 0; i < key_count; i++) {
            free(keys[i]);
        }
    }
    free(keys);
    
    return m;
}

// json.Validate - Validate JSON syntax
// Returns: NULL if valid, error message if invalid
char* json_Validate(const char* json) {
    if (!json) return "JSON error: null input";
    
    JSONParser p;
    json_parser_init(&p, json);
    
    json_skip_whitespace(&p);
    
    if (p.pos >= p.len) {
        json_parser_set_error(&p, "empty JSON input");
        char* err = p.error_msg ? strdup(p.error_msg) : NULL;
        if (p.error_msg) free(p.error_msg);
        return err;
    }
    
    char first = p.json[p.pos];
    if (first != '{' && first != '[' && first != '\"' && first != '-' && (first < '0' || first > '9') && first != 't' && first != 'f' && first != 'n') {
        json_parser_set_error(&p, "invalid JSON: unexpected character");
        char* err = p.error_msg ? strdup(p.error_msg) : NULL;
        if (p.error_msg) free(p.error_msg);
        return err;
    }
    
    // Basic bracket matching
    int depth = 0;
    int in_string = 0;
    int escape = 0;
    
    for (int i = 0; i < p.len; i++) {
        char c = p.json[i];
        
        if (escape) {
            escape = 0;
            continue;
        }
        
        if (c == '\\') {
            escape = 1;
            continue;
        }
        
        if (c == '\"') {
            in_string = !in_string;
            continue;
        }
        
        if (in_string) continue;
        
        if (c == '{' || c == '[') {
            depth++;
        } else if (c == '}' || c == ']') {
            depth--;
            if (depth < 0) {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON error: unexpected closing bracket '%c' at position %d", c, i);
                return strdup(err_msg);
            }
        }
    }
    
    if (in_string) {
        return strdup("JSON error: unterminated string");
    }
    
    if (depth != 0) {
        char err_msg[256];
        snprintf(err_msg, sizeof(err_msg), "JSON error: unclosed brackets (depth: %d)", depth);
        return strdup(err_msg);
    }
    
    return NULL;  // Valid JSON
}

// json.ValidateSchema - Validate JSON against schema
// Schema format: "field1:type1,field2:type2,..." or "type" for arrays
// Types: string, int, float, bool, array, object
// Returns: NULL if valid, error message if invalid
char* json_ValidateSchema(const char* json, const char* schema) {
    if (!json || !schema) return "JSON error: null input";
    
    // First validate JSON syntax
    char* syntax_err = json_Validate(json);
    if (syntax_err) return syntax_err;
    
    // If schema is empty or "any", accept any valid JSON
    if (!schema[0] || strcmp(schema, "any") == 0) return NULL;
    
    // Check if JSON is an object
    int i = 0;
    while (json[i] == ' ' || json[i] == '\t' || json[i] == '\n' || json[i] == '\r') i++;
    
    if (json[i] != '{') {
        return strdup("JSON schema error: expected object, got different type");
    }
    
    // Parse schema: "field1:type1,field2:type2"
    // For each field in schema, check if it exists in JSON
    char* schema_copy = strdup(schema);
    if (!schema_copy) return "JSON error: memory allocation failed";
    
    char* token = strtok(schema_copy, ",");
    while (token) {
        // Parse "field:type"
        char* colon = strchr(token, ':');
        if (!colon) {
            free(schema_copy);
            return strdup("JSON schema error: invalid schema format (expected 'field:type')");
        }
        
        *colon = '\0';
        char* field_name = token;
        char* field_type = colon + 1;
        
        // Check if field exists in JSON
        const char* field_value = json_GetObjectValue(json, field_name);
        if (!field_value) {
            char err_msg[256];
            snprintf(err_msg, sizeof(err_msg), "JSON schema error: missing required field '%s'", field_name);
            free(schema_copy);
            return strdup(err_msg);
        }
        
        // Basic type checking (simplified)
        int i_val = 0;
        while (field_value[i_val] == ' ' || field_value[i_val] == '\t' || field_value[i_val] == '\n' || field_value[i_val] == '\r') i_val++;
        
        if (strcmp(field_type, "string") == 0) {
            if (field_value[i_val] != '\"') {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON schema error: field '%s' should be string", field_name);
                free(schema_copy);
                return strdup(err_msg);
            }
        } else if (strcmp(field_type, "int") == 0 || strcmp(field_type, "float") == 0) {
            if ((field_value[i_val] < '0' || field_value[i_val] > '9') && field_value[i_val] != '-') {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON schema error: field '%s' should be number", field_name);
                free(schema_copy);
                return strdup(err_msg);
            }
        } else if (strcmp(field_type, "bool") == 0) {
            if (strncmp(field_value + i_val, "true", 4) != 0 && strncmp(field_value + i_val, "false", 5) != 0) {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON schema error: field '%s' should be boolean", field_name);
                free(schema_copy);
                return strdup(err_msg);
            }
        } else if (strcmp(field_type, "array") == 0) {
            if (field_value[i_val] != '[') {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON schema error: field '%s' should be array", field_name);
                free(schema_copy);
                return strdup(err_msg);
            }
        } else if (strcmp(field_type, "object") == 0) {
            if (field_value[i_val] != '{') {
                char err_msg[256];
                snprintf(err_msg, sizeof(err_msg), "JSON schema error: field '%s' should be object", field_name);
                free(schema_copy);
                return strdup(err_msg);
            }
        }
        
        token = strtok(NULL, ",");
    }
    
    free(schema_copy);
    return NULL;  // Valid against schema
}

// json.ValidateStruct - Validate JSON against struct schema
// This is a generic wrapper - actual validation uses compiler-generated functions
// Usage: json.ValidateStruct(json, "StructName") calls json_validate_structname(json)
// Note: The actual function name is generated by the compiler
char* json_ValidateStruct(const char* json, const char* struct_name) {
    if (!json || !struct_name) return "JSON error: null input";
    
    // Call compiler-generated validation function
    // Function name format: json_validate_<structname>
    // This is a simplified implementation - in practice, the compiler generates
    // a direct call to the specific validation function
    
    // For now, we'll use a generic approach
    // In a full implementation, this would dispatch to the correct function
    
    // First validate syntax
    char* syntax_err = json_Validate(json);
    if (syntax_err) return syntax_err;
    
    // Note: Struct-specific validation is done by compiler-generated functions
    // This function is a placeholder - actual validation happens at compile time
    return NULL;  // Valid (struct-specific checks done by generated code)
}

// json.MarshalSlice - Encode slice to JSON array string
// Note: Simplified - works with Slice* and element type string
char* json_MarshalSlice(Slice* slice, const char* elem_type) {
    static char buffer[8192];
    if (!slice || slice->len == 0) {
        return "[]";
    }
    strcpy(buffer, "[");
    for (int i = 0; i < slice->len; i++) {
        if (i > 0) strcat(buffer, ", ");
        // Simplified - assumes int elements for now
        char elem_str[64];
        if (strcmp(elem_type, "int") == 0) {
            int val = ((int*)slice->data)[i];
            snprintf(elem_str, sizeof(elem_str), "%d", val);
            strcat(buffer, elem_str);
        } else if (strcmp(elem_type, "string") == 0) {
            char* val = ((char**)slice->data)[i];
            strcat(buffer, json_escape(val));
        }
    }
    strcat(buffer, "]");
    return buffer;
}

// json.MarshalStruct - Encode struct to JSON object string
// Note: Simplified - requires manual field serialization
// This is a placeholder - full implementation would use reflection
char* json_MarshalStruct(const char* json_fields) {
    // json_fields should be pre-formatted as "field1:value1,field2:value2"
    static char buffer[8192];
    snprintf(buffer, sizeof(buffer), "{%s}", json_fields);
    return buffer;
}

// json.MarshalMap - Automatically encode map to JSON object string
char* json_MarshalMap(Map* m) {
    static char buffer[16384];
    if (!m || m->size == 0) {
        return "{}";
    }
    strcpy(buffer, "{");
    int first = 1;
    for (int i = 0; i < m->bucket_count; i++) {
        MapEntry* entry = m->buckets[i];
        while (entry) {
            if (!first) strcat(buffer, ", ");
            first = 0;
            
            // Serialize key
            if (m->key_type == 0) {  // string key
                char* key_str = *(char**)entry->key;
                strcat(buffer, json_escape(key_str));
            } else if (m->key_type == 1) {  // int key
                char key_str[64];
                snprintf(key_str, sizeof(key_str), "\"%d\"", *(int*)entry->key);
                strcat(buffer, key_str);
            } else {  // float key
                char key_str[64];
                snprintf(key_str, sizeof(key_str), "\"%.6g\"", *(double*)entry->key);
                strcat(buffer, key_str);
            }
            strcat(buffer, ":");
            
            // Serialize value
            if (m->value_type == 0) {  // int value
                char val_str[64];
                snprintf(val_str, sizeof(val_str), "%d", *(int*)entry->value);
                strcat(buffer, val_str);
            } else if (m->value_type == 1) {  // float value
                char val_str[64];
                snprintf(val_str, sizeof(val_str), "%.6g", *(double*)entry->value);
                strcat(buffer, val_str);
            } else if (m->value_type == 2) {  // string value
                char* val_str = *(char**)entry->value;
                if (val_str) {
                    strcat(buffer, json_escape(val_str));
                } else {
                    strcat(buffer, "null");
                }
            } else {  // bool value
                strcat(buffer, *(int*)entry->value ? "true" : "false");
            }
            
            entry = entry->next;
        }
    }
    strcat(buffer, "}");
    return buffer;
}

// json.MarshalAny - Automatically marshal any value to JSON
// This function uses type information to automatically serialize structs, maps, slices
char* json_MarshalAny(const char* type_name, void* value) {
    // This is a dispatcher that calls appropriate marshal function
    // For structs, it calls json_marshal_<structname>
    // For slices, it calls json_MarshalSlice
    // For basic types, it calls json_Marshal
    static char buffer[16384];
    
    // Try to find struct marshal function
    // In a full implementation, we'd use function pointers or a lookup table
    // For now, return a placeholder
    snprintf(buffer, sizeof(buffer), "{\"type\":\"%s\",\"value\":\"<auto>\"}", type_name);
    return buffer;
}

// Enhanced json.MarshalSlice with float and bool support
char* json_MarshalSliceEnhanced(Slice* slice, const char* elem_type) {
    static char buffer[16384];
    if (!slice || slice->len == 0) {
        return "[]";
    }
    strcpy(buffer, "[");
    for (int i = 0; i < slice->len; i++) {
        if (i > 0) strcat(buffer, ", ");
        char elem_str[256];
        if (strcmp(elem_type, "int") == 0) {
            int val = ((int*)slice->data)[i];
            snprintf(elem_str, sizeof(elem_str), "%d", val);
            strcat(buffer, elem_str);
        } else if (strcmp(elem_type, "float") == 0) {
            double val = ((double*)slice->data)[i];
            snprintf(elem_str, sizeof(elem_str), "%.6g", val);
            strcat(buffer, elem_str);
        } else if (strcmp(elem_type, "string") == 0) {
            char* val = ((char**)slice->data)[i];
            if (val) {
                strcat(buffer, json_escape(val));
            } else {
                strcat(buffer, "null");
            }
        } else if (strcmp(elem_type, "bool") == 0) {
            int val = ((int*)slice->data)[i];
            strcat(buffer, val ? "true" : "false");
        }
    }
    strcat(buffer, "]");
    return buffer;
}


// ========== http library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// HTTPS/TLS Support
// HTTPS is now fully supported when compiled with USE_OPENSSL
// The library automatically detects HTTPS URLs and uses TLS connections
// Certificate validation is enabled by default
// To enable HTTPS support, compile with -DUSE_OPENSSL and link against OpenSSL

// Helper: Extract host and port from URL
static void http_parse_url(const char* url, char* host, int* port, char* path) {
    // Default values
    strcpy(host, "");
    *port = 80;
    strcpy(path, "/");
    
    if (!url) return;
    
    // Skip scheme (http:// or https://)
    const char* host_start = url;
    if (strncmp(url, "http://", 7) == 0) {
        host_start = url + 7;
        *port = 80;
    } else if (strncmp(url, "https://", 8) == 0) {
        host_start = url + 8;
        *port = 443;
    }
    
    // Find path start
    const char* path_start = strchr(host_start, '/');
    const char* colon_pos = strchr(host_start, ':');
    
    // Extract host and port
    if (colon_pos != NULL && (path_start == NULL || colon_pos < path_start)) {
        // Has port
        int host_len = colon_pos - host_start;
        strncpy(host, host_start, host_len);
        host[host_len] = '\0';
        
        const char* port_start = colon_pos + 1;
        if (path_start != NULL) {
            int port_len = path_start - port_start;
            char port_str[16];
            strncpy(port_str, port_start, port_len);
            port_str[port_len] = '\0';
            *port = atoi(port_str);
        } else {
            *port = atoi(port_start);
        }
    } else {
        // No port
        if (path_start != NULL) {
            int host_len = path_start - host_start;
            strncpy(host, host_start, host_len);
            host[host_len] = '\0';
        } else {
            strcpy(host, host_start);
        }
    }
    
    // Extract path
    if (path_start != NULL) {
        strcpy(path, path_start);
    }
}

// http.Post - Make HTTP POST request
// Returns: HTTP response body (caller must free), or NULL on error
char* http_Post(const char* url, const char* data) {
    return http_PostWithHeaders(url, data, NULL);
}

// Helper: Extract HTTP status code from response
static int http_get_status_code(const char* response) {
    if (!response) return 0;
    // Find HTTP/1.x status line
    const char* http_pos = strstr(response, "HTTP/");
    if (!http_pos) return 0;
    // Skip to status code (after HTTP/1.x SPACE)
    const char* space = strchr(http_pos, ' ');
    if (!space) return 0;
    return atoi(space + 1);
}

// Helper: Extract Location header from response
static char* http_get_location(const char* response) {
    if (!response) return NULL;
    // Find Location: header
    const char* loc = strstr(response, "Location:");
    if (!loc) loc = strstr(response, "location:");
    if (!loc) return NULL;
    
    // Skip "Location:" and whitespace
    loc = strchr(loc, ':');
    if (!loc) return NULL;
    loc++;
    while (*loc == ' ' || *loc == '\t') loc++;
    
    // Find end of line
    const char* end = strchr(loc, '\r');
    if (!end) end = strchr(loc, '\n');
    if (!end) end = loc + strlen(loc);
    
    int len = end - loc;
    char* location = (char*)malloc(len + 1);
    if (location) {
        strncpy(location, loc, len);
        location[len] = '\0';
    }
    return location;
}

// http.Request - Generic HTTP request with method, headers, and body
// method: "GET", "POST", "PUT", "DELETE", etc.
// headers: "Header1: Value1\r\nHeader2: Value2" or NULL
// body: Request body or NULL
// Returns: HTTP response body (caller must free), or NULL on error
char* http_Request(const char* url, const char* method, const char* headers, const char* body) {
    if (!url || !method) return NULL;
    
    // Initialize network (Windows only)
    net_Init();
    
    // Parse URL
    char host[256];
    int port;
    char path[512];
    http_parse_url(url, host, &port, path);
    
    if (strlen(host) == 0) {
        net_Cleanup();
        return NULL;
    }
    
    // Connect to server (HTTP or HTTPS)
    int is_https = (port == 443 || strncmp(url, "https://", 8) == 0);
    void* tls_conn = NULL;
    int sockfd = -1;
    
    if (is_https) {
#ifdef USE_OPENSSL
        // Initialize TLS
        net_TLSInit();
        
        // Create TLS connection
        tls_conn = net_TLSDial(host, port);
        if (!tls_conn) {
            net_TLSCleanup();
            net_Cleanup();
            return NULL;
        }
#else
        // OpenSSL not available - HTTPS not supported
        net_Cleanup();
        return NULL;
#endif
    } else {
        // Plain HTTP connection
        sockfd = net_Dial(host, port);
        if (sockfd < 0) {
            net_Cleanup();
            return NULL;
        }
    }
    
    // Build HTTP request
    char request[8192];
    int body_len = body ? strlen(body) : 0;
    
    // Request line
    snprintf(request, sizeof(request), "%s %s HTTP/1.1\r\nHost: %s\r\n", method, path, host);
    
    // Add custom headers if provided
    if (headers && strlen(headers) > 0) {
        strncat(request, headers, sizeof(request) - strlen(request) - 1);
        // Ensure headers end with \r\n
        int req_len = strlen(request);
        if (req_len < 2 || strncmp(request + req_len - 2, "\r\n", 2) != 0) {
            strcat(request, "\r\n");
        }
    }
    
    // Add Content-Length if body exists
    if (body_len > 0) {
        char content_len[64];
        snprintf(content_len, sizeof(content_len), "Content-Length: %d\r\n", body_len);
        strncat(request, content_len, sizeof(request) - strlen(request) - 1);
    }
    
    // End headers
    strcat(request, "Connection: close\r\n\r\n");
    
    // Append body if exists
    if (body && body_len > 0) {
        strncat(request, body, sizeof(request) - strlen(request) - 1);
    }
    
    // Send request
    int send_result;
    if (is_https) {
#ifdef USE_OPENSSL
        send_result = net_TLSSend(tls_conn, request, strlen(request));
#else
        send_result = -1;
#endif
    } else {
        send_result = net_Send(sockfd, request, strlen(request));
    }
    
    if (send_result < 0) {
        if (is_https) {
#ifdef USE_OPENSSL
            net_TLSClose(tls_conn);
            net_TLSCleanup();
#endif
        } else {
            net_Close(sockfd);
        }
        net_Cleanup();
        return NULL;
    }
    
    // Receive response
    char buffer[16384];
    int total_received = 0;
    int received;
    
    while (1) {
        if (is_https) {
#ifdef USE_OPENSSL
            received = net_TLSRecv(tls_conn, buffer + total_received, sizeof(buffer) - total_received - 1);
#else
            received = -1;
#endif
        } else {
            received = net_Recv(sockfd, buffer + total_received, sizeof(buffer) - total_received - 1);
        }
        
        if (received <= 0) break;
        total_received += received;
        if (total_received >= sizeof(buffer) - 1) break;
    }
    buffer[total_received] = '\0';
    
    // Close connection
    if (is_https) {
#ifdef USE_OPENSSL
        net_TLSClose(tls_conn);
        net_TLSCleanup();
#endif
    } else {
        net_Close(sockfd);
    }
    net_Cleanup();
    
    // Parse response - find body after headers
    char* body_start = strstr(buffer, "\r\n\r\n");
    if (!body_start) body_start = strstr(buffer, "\n\n");
    
    if (body_start) {
        body_start += 4;  // Skip \r\n\r\n
        if (strncmp(body_start - 2, "\n\n", 2) == 0) body_start -= 2;  // Handle \n\n
        char* response = (char*)malloc(strlen(body_start) + 1);
        if (response) {
            strcpy(response, body_start);
            return response;
        }
    }
    
    // Return full response if no body found
    char* response = (char*)malloc(strlen(buffer) + 1);
    if (response) strcpy(response, buffer);
    return response;
}

// http.Get - Make HTTP GET request with redirect support
// Returns: HTTP response body (caller must free), or NULL on error
char* http_Get(const char* url) {
    return http_GetWithRedirects(url, 5);  // Default: 5 redirects max
}

// http.GetWithRedirects - Make HTTP GET request with redirect handling
// max_redirects: Maximum number of redirects to follow (default: 5)
// Returns: HTTP response body (caller must free), or NULL on error
char* http_GetWithRedirects(const char* url, int max_redirects) {
    if (!url || max_redirects < 0) return NULL;
    
    char* current_url = (char*)malloc(strlen(url) + 1);
    if (!current_url) return NULL;
    strcpy(current_url, url);
    
    int redirects = 0;
    char* response = NULL;
    
    while (redirects <= max_redirects) {
        // Make request
        response = http_Request(current_url, "GET", NULL, NULL);
        if (!response) {
            free(current_url);
            return NULL;
        }
        
        // Check for redirect (301, 302, 307, 308)
        int status = http_get_status_code(response);
        if (status == 301 || status == 302 || status == 307 || status == 308) {
            // Get Location header
            char* location = http_get_location(response);
            free(response);
            
            if (!location || redirects >= max_redirects) {
                free(current_url);
                if (location) free(location);
                return NULL;
            }
            
            // Handle relative URLs
            if (location[0] == '/') {
                // Relative URL - extract scheme and host from current URL
                char new_url[1024];
                char host[256];
                int port;
                char path[512];
                http_parse_url(current_url, host, &port, path);
                
                if (strncmp(current_url, "https://", 8) == 0) {
                    snprintf(new_url, sizeof(new_url), "https://%s:%d%s", host, port, location);
                } else {
                    snprintf(new_url, sizeof(new_url), "http://%s:%d%s", host, port, location);
                }
                free(current_url);
                current_url = (char*)malloc(strlen(new_url) + 1);
                if (current_url) strcpy(current_url, new_url);
            } else {
                // Absolute URL
                free(current_url);
                current_url = location;
            }
            
            redirects++;
            continue;
        }
        
        // Not a redirect, return response
        break;
    }
    
    free(current_url);
    return response;
}

// http.Put - Make HTTP PUT request
// Returns: HTTP response body (caller must free), or NULL on error
char* http_Put(const char* url, const char* data) {
    return http_Request(url, "PUT", NULL, data);
}

// http.Delete - Make HTTP DELETE request
// Returns: HTTP response body (caller must free), or NULL on error
char* http_Delete(const char* url) {
    return http_Request(url, "DELETE", NULL, NULL);
}

// http.Head - Make HTTP HEAD request
// Returns: HTTP response headers (caller must free), or NULL on error
// Note: HEAD requests return headers only, no response body
char* http_Head(const char* url) {
    return http_Request(url, "HEAD", NULL, NULL);
}

// http.Options - Make HTTP OPTIONS request
// Returns: HTTP response body (caller must free), or NULL on error
// Used to describe communication options for the target resource
char* http_Options(const char* url) {
    return http_Request(url, "OPTIONS", NULL, NULL);
}

// http.Patch - Make HTTP PATCH request
// Returns: HTTP response body (caller must free), or NULL on error
// Used for partial modifications to a resource
char* http_Patch(const char* url, const char* data) {
    return http_Request(url, "PATCH", NULL, data);
}

// http.PatchWithHeaders - Make HTTP PATCH request with custom headers
// Returns: HTTP response body (caller must free), or NULL on error
char* http_PatchWithHeaders(const char* url, const char* data, const char* headers) {
    // Build headers with Content-Type if not provided
    char full_headers[1024] = "";
    if (headers && strlen(headers) > 0) {
        strcpy(full_headers, headers);
    }
    if (data && (!headers || strstr(headers, "Content-Type") == NULL)) {
        if (strlen(full_headers) > 0) strcat(full_headers, "\r\n");
        strcat(full_headers, "Content-Type: application/json\r\n");
    }
    return http_Request(url, "PATCH", full_headers, data);
}

// http.Trace - Make HTTP TRACE request
// Returns: HTTP response body (caller must free), or NULL on error
// Used for diagnostic purposes, echoes the request back
char* http_Trace(const char* url) {
    return http_Request(url, "TRACE", NULL, NULL);
}

// http.Connect - Make HTTP CONNECT request
// Returns: HTTP response body (caller must free), or NULL on error
// Used to establish a tunnel to the server (typically for HTTPS proxies)
char* http_Connect(const char* url) {
    return http_Request(url, "CONNECT", NULL, NULL);
}

// http.PostWithHeaders - Make HTTP POST request with custom headers
// headers: "Header1: Value1\r\nHeader2: Value2" or NULL
// Returns: HTTP response body (caller must free), or NULL on error
char* http_PostWithHeaders(const char* url, const char* data, const char* headers) {
    // Build headers with Content-Type if not provided
    char full_headers[2048] = "";
    if (headers && strlen(headers) > 0) {
        strcpy(full_headers, headers);
        // Check if Content-Type is already in headers
        if (strstr(headers, "Content-Type:") == NULL && strstr(headers, "content-type:") == NULL) {
            strcat(full_headers, "Content-Type: application/x-www-form-urlencoded\r\n");
        }
    } else if (data && strlen(data) > 0) {
        strcpy(full_headers, "Content-Type: application/x-www-form-urlencoded\r\n");
    }
    return http_Request(url, "POST", full_headers, data);
}

// HTTP Request structure
typedef struct HTTPRequest {
    char method[16];      // GET, POST, etc.
    char path[512];       // Request path
    char* headers;        // Request headers (allocated)
    char* body;           // Request body (allocated)
} HTTPRequest;

// Parse HTTP request from raw request string
static HTTPRequest* http_parse_request(const char* raw_request) {
    if (!raw_request) return NULL;
    
    HTTPRequest* req = (HTTPRequest*)malloc(sizeof(HTTPRequest));
    if (!req) return NULL;
    memset(req, 0, sizeof(HTTPRequest));
    
    // Parse request line: METHOD PATH HTTP/VERSION
    const char* space1 = strchr(raw_request, ' ');
    if (!space1) { free(req); return NULL; }
    
    // Extract method
    int method_len = space1 - raw_request;
    if (method_len >= sizeof(req->method)) method_len = sizeof(req->method) - 1;
    strncpy(req->method, raw_request, method_len);
    req->method[method_len] = '\0';
    
    // Extract path
    const char* path_start = space1 + 1;
    const char* space2 = strchr(path_start, ' ');
    if (!space2) { free(req); return NULL; }
    
    int path_len = space2 - path_start;
    if (path_len >= sizeof(req->path)) path_len = sizeof(req->path) - 1;
    strncpy(req->path, path_start, path_len);
    req->path[path_len] = '\0';
    
    // Find headers section (after first \r\n\r\n or \n\n)
    const char* headers_start = strstr(raw_request, "\r\n");
    if (!headers_start) headers_start = strstr(raw_request, "\n");
    if (headers_start) headers_start += 2;  // Skip \r\n or \n
    
    // Find body (after \r\n\r\n or \n\n)
    const char* body_start = strstr(raw_request, "\r\n\r\n");
    if (!body_start) body_start = strstr(raw_request, "\n\n");
    
    if (body_start) {
        body_start += 4;  // Skip \r\n\r\n
        if (strncmp(body_start - 2, "\n\n", 2) == 0) body_start -= 2;  // Handle \n\n
        
        // Extract headers
        int headers_len = body_start - headers_start - 4;
        if (headers_len > 0) {
            req->headers = (char*)malloc(headers_len + 1);
            if (req->headers) {
                strncpy(req->headers, headers_start, headers_len);
                req->headers[headers_len] = '\0';
            }
        }
        
        // Extract body
        int body_len = strlen(body_start);
        if (body_len > 0) {
            req->body = (char*)malloc(body_len + 1);
            if (req->body) {
                strcpy(req->body, body_start);
            }
        }
    } else if (headers_start) {
        // No body, just headers
        int headers_len = strlen(headers_start);
        if (headers_len > 0) {
            req->headers = (char*)malloc(headers_len + 1);
            if (req->headers) {
                strcpy(req->headers, headers_start);
            }
        }
    }
    
    return req;
}

// Free HTTP request structure
static void http_free_request(HTTPRequest* req) {
    if (!req) return;
    if (req->headers) free(req->headers);
    if (req->body) free(req->body);
    free(req);
}

// Generate HTTP response
static char* http_make_response(int status_code, const char* content_type, const char* body) {
    const char* status_text = "OK";
    if (status_code == 404) status_text = "Not Found";
    else if (status_code == 500) status_text = "Internal Server Error";
    else if (status_code == 400) status_text = "Bad Request";
    
    int body_len = body ? strlen(body) : 0;
    char* response = (char*)malloc(4096);
    if (!response) return NULL;
    
    snprintf(response, 4096, "HTTP/1.1 %d %s\r\nContent-Type: %s\r\nContent-Length: %d\r\nConnection: close\r\n\r\n",
        status_code, status_text, content_type ? content_type : "text/plain", body_len);
    
    if (body && body_len > 0) {
        strncat(response, body, 4096 - strlen(response) - 1);
    }
    
    return response;
}

// Handler function type: char* handler(const char* method, const char* path, const char* body)
// Returns: Response body string (caller will free), or NULL for 404
typedef char* (*HTTPHandler)(const char* method, const char* path, const char* body);

// Default handler - returns simple response
static char* http_default_handler(const char* method, const char* path, const char* body) {
    static char response[512];
    snprintf(response, sizeof(response), "Method: %s\nPath: %s\n", method ? method : "UNKNOWN", path ? path : "/");
    char* result = (char*)malloc(strlen(response) + 1);
    if (result) strcpy(result, response);
    return result;
}

// http.ListenAndServe - Start HTTP server with request parsing and routing
// addr format: "host:port" or ":port"
// handler: Function pointer to handle requests (HTTPHandler), or NULL for default
int http_ListenAndServe(const char* addr, void* handler) {
    if (!addr) return -1;
    
    // Initialize network (Windows only)
    net_Init();
    
    // Parse address
    int port = 8080;  // Default
    if (addr[0] == ':') {
        port = atoi(addr + 1);
    } else {
        const char* colon = strchr(addr, ':');
        if (colon) {
            port = atoi(colon + 1);
        }
    }
    
    if (port <= 0) port = 8080;
    
    // Use default handler if none provided
    HTTPHandler handler_func = handler ? (HTTPHandler)handler : http_default_handler;
    
    // Listen on port
    int listenfd = net_Listen(port);
    if (listenfd < 0) {
        net_Cleanup();
        return -1;
    }
    
    // Accept connections (handles one at a time)
    while (1) {
        int connfd = net_Accept(listenfd);
        if (connfd < 0) continue;
        
        // Read request
        char request[8192];
        int received = net_Recv(connfd, request, sizeof(request) - 1);
        if (received > 0) {
            request[received] = '\0';
            
            // Parse request
            HTTPRequest* req = http_parse_request(request);
            if (req) {
                // Call handler
                char* response_body = handler_func(req->method, req->path, req->body);
                
                if (response_body) {
                    // Generate HTTP response
                    char* http_response = http_make_response(200, "text/plain", response_body);
                    if (http_response) {
                        net_Send(connfd, http_response, strlen(http_response));
                        free(http_response);
                    }
                    free(response_body);
                } else {
                    // 404 Not Found
                    char* http_response = http_make_response(404, "text/plain", "Not Found");
                    if (http_response) {
                        net_Send(connfd, http_response, strlen(http_response));
                        free(http_response);
                    }
                }
                
                http_free_request(req);
            } else {
                // Bad request
                char* http_response = http_make_response(400, "text/plain", "Bad Request");
                if (http_response) {
                    net_Send(connfd, http_response, strlen(http_response));
                    free(http_response);
                }
            }
        }
        
        net_Close(connfd);
    }
    
    net_Close(listenfd);
    net_Cleanup();
    return 0;
}

// http.Response - Create HTTP response string
// status_code: HTTP status code (200, 404, 500, etc.)
// content_type: Content-Type header value
// body: Response body
// Returns: Complete HTTP response (caller must free)
char* http_Response(int status_code, const char* content_type, const char* body) {
    return http_make_response(status_code, content_type, body);
}

// Helper: Check if path matches a route pattern
static int http_path_matches(const char* path, const char* pattern) {
    if (!path || !pattern) return 0;
    // Simple prefix matching
    return strncmp(path, pattern, strlen(pattern)) == 0;
}

// Helper: Extract query parameter value from path
static char* http_get_query_param(const char* path, const char* param_name) {
    if (!path || !param_name) return NULL;
    
    // Find query string (after ?)
    const char* query_start = strchr(path, '?');
    if (!query_start) return NULL;
    query_start++;  // Skip ?
    
    // Find parameter
    char search[256];
    snprintf(search, sizeof(search), "%s=", param_name);
    const char* param_start = strstr(query_start, search);
    if (!param_start) return NULL;
    
    param_start += strlen(search);
    
    // Find end of value (& or end of string)
    const char* param_end = strchr(param_start, '&');
    if (!param_end) param_end = param_start + strlen(param_start);
    
    int len = param_end - param_start;
    char* value = (char*)malloc(len + 1);
    if (value) {
        strncpy(value, param_start, len);
        value[len] = '\0';
    }
    return value;
}

// http.RouteHandler - Simple router that matches paths and calls handlers
// routes: Array of route patterns (paths) and handlers
// route_count: Number of routes
// method: HTTP method
// path: Request path
// body: Request body
// Returns: Response body (caller must free), or NULL for 404
// Note: This is a simplified router - matches first prefix match
char* http_RouteHandler(const char** routes, HTTPHandler* handlers, int route_count, const char* method, const char* path, const char* body) {
    if (!routes || !handlers || !path || route_count <= 0) return NULL;
    
    // Try each route
    for (int i = 0; i < route_count; i++) {
        if (http_path_matches(path, routes[i])) {
            // Route matched, call handler
            if (handlers[i]) {
                return handlers[i](method, path, body);
            }
        }
    }
    
    return NULL;  // No route matched
}

// http.JSONResponse - Create JSON response
// status_code: HTTP status code
// json_body: JSON string body
// Returns: Complete HTTP response (caller must free)
char* http_JSONResponse(int status_code, const char* json_body) {
    return http_make_response(status_code, "application/json", json_body);
}

// http.HTMLResponse - Create HTML response
// status_code: HTTP status code
// html_body: HTML string body
// Returns: Complete HTTP response (caller must free)
char* http_HTMLResponse(int status_code, const char* html_body) {
    return http_make_response(status_code, "text/html", html_body);
}


// ========== io library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#ifdef _WIN32
#include <windows.h>
#include <direct.h>
#include <io.h>
#include <sys/stat.h>
#define stat _stat
#ifndef S_ISDIR
#define S_ISDIR(m) (((m) & _S_IFMT) == _S_IFDIR)
#endif
#else
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>
#endif

static long get_file_size(FILE* fp) {
    long pos = ftell(fp);
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    fseek(fp, pos, SEEK_SET);
    return size;
}

// io.ReadFile - Read entire file as string
char* io_ReadFile(const char* filename) {
    static char buffer[65536]; // 64KB buffer
    FILE* fp = fopen(filename, "rb");
    if (!fp) {
        return "";
    }
    
    long size = get_file_size(fp);
    if (size >= sizeof(buffer) - 1) {
        size = sizeof(buffer) - 1;
    }
    
    size_t read = fread(buffer, 1, size, fp);
    buffer[read] = '\0';
    fclose(fp);
    return buffer;
}

// io.WriteFile - Write string to file, returns bytes written
int io_WriteFile(const char* filename, const char* data) {
    FILE* fp = fopen(filename, "wb");
    if (!fp) {
        return -1;
    }
    
    int len = strlen(data);
    size_t written = fwrite(data, 1, len, fp);
    fclose(fp);
    return (int)written;
}

// io.ReadDir - Read directory contents (returns newline-separated string)
char* io_ReadDir(const char* dirname) {
    static char result[8192]; // 8KB buffer
    result[0] = '\0';
    
#ifdef _WIN32
    WIN32_FIND_DATA findData;
    char pattern[512];
    snprintf(pattern, sizeof(pattern), "%s\\*", dirname);
    HANDLE hFind = FindFirstFileA(pattern, &findData);
    if (hFind == INVALID_HANDLE_VALUE) {
        return "";
    }
    
    do {
        if (strlen(result) + strlen(findData.cFileName) + 2 < sizeof(result)) {
            if (result[0] != '\0') strcat(result, "\n");
            strcat(result, findData.cFileName);
        }
    } while (FindNextFileA(hFind, &findData));
    
    FindClose(hFind);
#else
    DIR* dir = opendir(dirname);
    if (!dir) {
        return "";
    }
    
    struct dirent* entry;
    while ((entry = readdir(dir)) != NULL) {
        // Skip . and ..
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        if (strlen(result) + strlen(entry->d_name) + 2 < sizeof(result)) {
            if (result[0] != '\0') strcat(result, "\n");
            strcat(result, entry->d_name);
        }
    }
    closedir(dir);
#endif
    
    return result;
}

// io.Mkdir - Create directory
int io_Mkdir(const char* name, int perm) {
#ifdef _WIN32
    (void)perm; // Windows doesn't use permissions the same way
    return _mkdir(name);
#else
    return mkdir(name, (mode_t)perm);
#endif
}

// io.Remove - Remove file or directory
int io_Remove(const char* name) {
#ifdef _WIN32
    struct stat st;
    if (stat(name, &st) != 0) {
        return -1;
    }
    if (S_ISDIR(st.st_mode)) {
        return _rmdir(name);
    } else {
        return remove(name);
    }
#else
    struct stat st;
    if (stat(name, &st) != 0) {
        return -1;
    }
    if (S_ISDIR(st.st_mode)) {
        return rmdir(name);
    } else {
        return remove(name);
    }
#endif
}

// io.Rename - Rename/move file
int io_Rename(const char* oldpath, const char* newpath) {
    return rename(oldpath, newpath);
}

// io.Exists - Check if file/directory exists
int io_Exists(const char* path) {
#ifdef _WIN32
    return _access(path, 0) == 0 ? 1 : 0;
#else
    return access(path, F_OK) == 0 ? 1 : 0;
#endif
}

// io.IsDir - Check if path is directory
int io_IsDir(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) {
        return 0;
    }
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

// io.Stat - Get file information (returns formatted string)
char* io_Stat(const char* path) {
    static char result[256];
    struct stat st;
    if (stat(path, &st) != 0) {
        return "";
    }
    
    snprintf(result, sizeof(result), "size:%ld,isdir:%d,mtime:%ld", 
             (long)st.st_size, S_ISDIR(st.st_mode) ? 1 : 0, (long)st.st_mtime);
    return result;
}


// ========== filepath library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#ifdef _WIN32
#include <windows.h>
#include <direct.h>
#define PATH_SEP '\\'
#define PATH_SEP_STR "\\"
#else
#include <unistd.h>
#define PATH_SEP '/'
#define PATH_SEP_STR "/"
#endif

static void normalize_separators(char* path) {
#ifdef _WIN32
    // On Windows, convert forward slashes to backslashes
    for (int i = 0; path[i]; i++) {
        if (path[i] == '/') path[i] = '\\';
    }
#else
    // On Unix, convert backslashes to forward slashes
    for (int i = 0; path[i]; i++) {
        if (path[i] == '\\') path[i] = '/';
    }
#endif
}

// filepath.Join - Join path components
char* filepath_Join(const char* path1, const char* path2) {
    static char result[1024];
    result[0] = '\0';
    
    if (!path1 || strlen(path1) == 0) {
        strncpy(result, path2 ? path2 : "", sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        normalize_separators(result);
        return result;
    }
    if (!path2 || strlen(path2) == 0) {
        strncpy(result, path1, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        normalize_separators(result);
        return result;
    }
    
    strncpy(result, path1, sizeof(result) - 1);
    result[sizeof(result) - 1] = '\0';
    
    // Remove trailing separator from path1
    int len = strlen(result);
    if (len > 0 && (result[len-1] == '/' || result[len-1] == '\\')) {
        result[len-1] = '\0';
        len--;
    }
    
    // Remove leading separator from path2
    const char* path2_start = path2;
    while (*path2_start == '/' || *path2_start == '\\') path2_start++;
    
    // Add separator and path2
    if (len + strlen(path2_start) + 2 < sizeof(result)) {
        result[len] = PATH_SEP;
        strcpy(result + len + 1, path2_start);
    }
    
    normalize_separators(result);
    return result;
}

// filepath.Base - Get filename from path
char* filepath_Base(const char* path) {
    static char result[512];
    if (!path || strlen(path) == 0) {
        result[0] = '.';
        result[1] = '\0';
        return result;
    }
    
    // Find last separator
    int last_sep = -1;
    int len = strlen(path);
    for (int i = len - 1; i >= 0; i--) {
        if (path[i] == '/' || path[i] == '\\') {
            last_sep = i;
            break;
        }
    }
    
    const char* base = path + last_sep + 1;
    if (strlen(base) == 0) {
        // Path ends with separator, find previous component
        if (last_sep > 0) {
            for (int i = last_sep - 1; i >= 0; i--) {
                if (path[i] == '/' || path[i] == '\\') {
                    base = path + i + 1;
                    break;
                }
            }
        }
        if (strlen(base) == 0) base = path;
    }
    
    strncpy(result, base, sizeof(result) - 1);
    result[sizeof(result) - 1] = '\0';
    return result;
}

// filepath.Dir - Get directory from path
char* filepath_Dir(const char* path) {
    static char result[1024];
    if (!path || strlen(path) == 0) {
        result[0] = '.';
        result[1] = '\0';
        return result;
    }
    
    // Find last separator
    int last_sep = -1;
    int len = strlen(path);
    for (int i = len - 1; i >= 0; i--) {
        if (path[i] == '/' || path[i] == '\\') {
            last_sep = i;
            break;
        }
    }
    
    if (last_sep < 0) {
        result[0] = '.';
        result[1] = '\0';
    } else if (last_sep == 0) {
        result[0] = PATH_SEP;
        result[1] = '\0';
    } else {
        strncpy(result, path, last_sep);
        result[last_sep] = '\0';
    }
    
    normalize_separators(result);
    return result;
}

// filepath.Ext - Get file extension
char* filepath_Ext(const char* path) {
    static char result[64];
    result[0] = '\0';
    
    if (!path) return result;
    
    // Find last dot after last separator
    int last_sep = -1;
    int last_dot = -1;
    int len = strlen(path);
    
    for (int i = len - 1; i >= 0; i--) {
        if (path[i] == '/' || path[i] == '\\') {
            last_sep = i;
            break;
        }
        if (path[i] == '.' && last_dot < 0) {
            last_dot = i;
        }
    }
    
    if (last_dot > last_sep && last_dot < len - 1) {
        strcpy(result, path + last_dot);
    }
    
    return result;
}

// filepath.Clean - Clean path (remove .., .)
char* filepath_Clean(const char* path) {
    static char result[1024];
    if (!path || strlen(path) == 0) {
        result[0] = '.';
        result[1] = '\0';
        return result;
    }
    
    char temp[1024];
    strncpy(temp, path, sizeof(temp) - 1);
    temp[sizeof(temp) - 1] = '\0';
    normalize_separators(temp);
    
    // Split into components
    char components[256][256];
    int comp_count = 0;
    int is_absolute = (temp[0] == '/' || temp[0] == '\\');
    
    char* token = strtok(temp, PATH_SEP_STR);
    while (token && comp_count < 256) {
        if (strcmp(token, ".") != 0) {
            if (strcmp(token, "..") == 0) {
                if (comp_count > 0 && strcmp(components[comp_count - 1], "..") != 0) {
                    comp_count--;
                } else if (!is_absolute) {
                    strncpy(components[comp_count], token, sizeof(components[0]) - 1);
                    components[comp_count][sizeof(components[0]) - 1] = '\0';
                    comp_count++;
                }
            } else {
                strncpy(components[comp_count], token, sizeof(components[0]) - 1);
                components[comp_count][sizeof(components[0]) - 1] = '\0';
                comp_count++;
            }
        }
        token = strtok(NULL, PATH_SEP_STR);
    }
    
    // Reconstruct path
    result[0] = '\0';
    if (is_absolute) {
        strcpy(result, PATH_SEP_STR);
    }
    
    for (int i = 0; i < comp_count; i++) {
        if (i > 0 || is_absolute) strcat(result, PATH_SEP_STR);
        strcat(result, components[i]);
    }
    
    if (comp_count == 0 && !is_absolute) {
        strcpy(result, ".");
    }
    
    return result;
}

// filepath.Abs - Get absolute path
char* filepath_Abs(const char* path) {
    static char result[1024];
    
#ifdef _WIN32
    char full_path[MAX_PATH];
    if (GetFullPathNameA(path, MAX_PATH, full_path, NULL) != 0) {
        strncpy(result, full_path, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    } else {
        strncpy(result, path, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
#else
    char* resolved = realpath(path, NULL);
    if (resolved) {
        strncpy(result, resolved, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        free(resolved);
    } else {
        strncpy(result, path, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
#endif
    
    return result;
}

// filepath.Split - Split directory and file (returns "dir|file")
char* filepath_Split(const char* path) {
    static char result[1024];
    
    char* dir = filepath_Dir(path);
    char* base = filepath_Base(path);
    
    snprintf(result, sizeof(result), "%s|%s", dir, base);
    return result;
}

// filepath.IsAbs - Check if path is absolute
int filepath_IsAbs(const char* path) {
    if (!path || strlen(path) == 0) return 0;
    
#ifdef _WIN32
    // Windows: Check for drive letter (C:) or UNC path (\\server)
    if (strlen(path) >= 2 && path[1] == ':') return 1;
    if (strlen(path) >= 2 && (path[0] == '\\' || path[0] == '/') && (path[1] == '\\' || path[1] == '/')) return 1;
    return 0;
#else
    // Unix: Check if starts with /
    return (path[0] == '/') ? 1 : 0;
#endif
}


// ========== testing library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// Test context structure
typedef struct {
    char name[256];
    int failed;
    int skipped;
    int passed;
} TestContext;

static TestContext current_test = {0};
static int total_tests = 0;
static int total_passed = 0;
static int total_failed = 0;

// testing.Run - Run a test function
int testing_Run(const char* name, void (*test_func)()) {
    strncpy(current_test.name, name, sizeof(current_test.name) - 1);
    current_test.name[sizeof(current_test.name) - 1] = '\0';
    current_test.failed = 0;
    current_test.skipped = 0;
    current_test.passed = 0;
    
    printf("RUN   %s\n", name);
    
    test_func();
    
    total_tests++;
    if (current_test.failed > 0) {
        printf("FAIL  %s\n", name);
        total_failed++;
        return 1;
    } else {
        printf("PASS  %s\n", name);
        total_passed++;
        return 0;
    }
}

// testing.Assert - Assert that condition is true
void testing_Assert(int condition, const char* message) {
    if (!condition) {
        printf("    ASSERT FAILED: %s\n", message ? message : "assertion failed");
        current_test.failed++;
    } else {
        current_test.passed++;
    }
}

// testing.AssertEqual - Assert that two integers are equal
void testing_AssertEqual(int expected, int actual, const char* message) {
    if (expected != actual) {
        printf("    ASSERT FAILED: %s (expected %d, got %d)\n", 
               message ? message : "values not equal", expected, actual);
        current_test.failed++;
    } else {
        current_test.passed++;
    }
}

// testing.AssertEqualFloat - Assert that two floats are equal (within epsilon)
void testing_AssertEqualFloat(double expected, double actual, double epsilon, const char* message) {
    double diff = expected > actual ? expected - actual : actual - expected;
    if (diff > epsilon) {
        printf("    ASSERT FAILED: %s (expected %f, got %f, diff %f)\n", 
               message ? message : "floats not equal", expected, actual, diff);
        current_test.failed++;
    } else {
        current_test.passed++;
    }
}

// testing.AssertEqualString - Assert that two strings are equal
void testing_AssertEqualString(const char* expected, const char* actual, const char* message) {
    if (strcmp(expected, actual) != 0) {
        printf("    ASSERT FAILED: %s (expected '%s', got '%s')\n", 
               message ? message : "strings not equal", expected, actual);
        current_test.failed++;
    } else {
        current_test.passed++;
    }
}

// testing.Fail - Mark test as failed
void testing_Fail(const char* message) {
    printf("    FAIL: %s\n", message ? message : "test failed");
    current_test.failed++;
}

// testing.Skip - Skip the current test
void testing_Skip(const char* message) {
    printf("    SKIP: %s\n", message ? message : "test skipped");
    current_test.skipped++;
}

// testing.Log - Log a message during test
void testing_Log(const char* message) {
    printf("    LOG: %s\n", message ? message : "");
}

// testing.Summary - Print test summary
void testing_Summary() {
    printf("\n=== Test Summary ===\n");
    printf("Total tests: %d\n", total_tests);
    printf("Passed: %d\n", total_passed);
    printf("Failed: %d\n", total_failed);
    if (total_failed > 0) {
        printf("RESULT: FAILED\n");
    } else {
        printf("RESULT: PASSED\n");
    }
}

// testing.GetFailed - Get number of failed assertions in current test
int testing_GetFailed() {
    return current_test.failed;
}


// ========== args library ==========
// Global command-line arguments
static int g_argc = 0;
static char** g_argv = NULL;

// args.Init - Initialize arguments (called from main)
void args_Init(int argc, char** argv) {
    g_argc = argc;
    g_argv = argv;
}

// args.Count - Get number of arguments
int args_Count() {
    return g_argc;
}

// args.Get - Get argument at index (0 = program name)
char* args_Get(int index) {
    if (index < 0 || index >= g_argc) {
        return "";
    }
    return g_argv[index];
}

// args.Program - Get program name (args[0])
char* args_Program() {
    return args_Get(0);
}


// ========== regexp library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef _WIN32
#include <regex.h>
#endif

#ifndef _WIN32
static int compile_regex(regex_t* regex, const char* pattern) {
    int ret = regcomp(regex, pattern, REG_EXTENDED);
    if (ret != 0) {
        return 0; // Failed to compile
    }
    return 1; // Success
}
#endif

// regexp.Match - Check if pattern matches
int regexp_Match(const char* pattern, const char* text) {
#ifdef _WIN32
    return 0; // Not supported on Windows
#else
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        return 0; // Invalid pattern
    }
    
    int ret = regexec(&regex, text, 0, NULL, 0);
    regfree(&regex);
    
    return (ret == 0) ? 1 : 0; // 1 = match, 0 = no match
#endif
}

// regexp.Find - Find first match
char* regexp_Find(const char* pattern, const char* text) {
    static char result[1024];
    result[0] = '\0';
#ifdef _WIN32
    return result; // Not supported on Windows
#else
    
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        return result; // Invalid pattern
    }
    
    regmatch_t matches[1];
    int ret = regexec(&regex, text, 1, matches, 0);
    
    if (ret == 0 && matches[0].rm_so >= 0) {
        int start = matches[0].rm_so;
        int end = matches[0].rm_eo;
        int len = end - start;
        if (len > 0 && len < sizeof(result)) {
            strncpy(result, text + start, len);
            result[len] = '\0';
        }
    }
    
    regfree(&regex);
    return result;
#endif
}

// regexp.FindAll - Find all matches (returns newline-separated string)
char* regexp_FindAll(const char* pattern, const char* text, int maxMatches) {
    static char result[8192]; // 8KB buffer
    result[0] = '\0';
#ifdef _WIN32
    return result; // Not supported on Windows
#else
    
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        return result; // Invalid pattern
    }
    
    regmatch_t matches[1];
    const char* search_start = text;
    int match_count = 0;
    
    while (match_count < maxMatches && *search_start) {
        int ret = regexec(&regex, search_start, 1, matches, 0);
        if (ret != 0) break; // No more matches
        
        int start = matches[0].rm_so;
        int end = matches[0].rm_eo;
        if (start < 0 || end <= start) break;
        
        int len = end - start;
        int current_len = strlen(result);
        
        if (current_len + len + 2 < sizeof(result)) {
            if (current_len > 0) strcat(result, "\n");
            strncat(result, search_start + start, len);
        }
        
        // Move search start past this match
        search_start += end;
        match_count++;
        
        // Avoid infinite loop on zero-length matches
        if (len == 0) search_start++;
    }
    
    regfree(&regex);
    return result;
#endif
}

// regexp.Replace - Replace first match
char* regexp_Replace(const char* pattern, const char* text, const char* repl) {
    static char result[4096];
    result[0] = '\0';
#ifdef _WIN32
    strncpy(result, text, sizeof(result) - 1);
    result[sizeof(result) - 1] = '\0';
    return result; // Not supported on Windows
#else
    
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        return result; // Invalid pattern, return original
    }
    
    regmatch_t matches[1];
    int ret = regexec(&regex, text, 1, matches, 0);
    
    if (ret == 0 && matches[0].rm_so >= 0) {
        int start = matches[0].rm_so;
        int end = matches[0].rm_eo;
        
        // Copy part before match
        if (start > 0) {
            strncat(result, text, start);
        }
        
        // Add replacement
        strcat(result, repl);
        
        // Copy part after match
        int text_len = strlen(text);
        if (end < text_len) {
            strcat(result, text + end);
        }
    } else {
        // No match, return original
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    
    regfree(&regex);
    return result;
#endif
}

// regexp.ReplaceAll - Replace all matches
char* regexp_ReplaceAll(const char* pattern, const char* text, const char* repl) {
    static char result[4096];
#ifdef _WIN32
    strncpy(result, text, sizeof(result) - 1);
    result[sizeof(result) - 1] = '\0';
    return result; // Not supported on Windows
#else
    static char temp[4096];
    
    strncpy(temp, text, sizeof(temp) - 1);
    temp[sizeof(temp) - 1] = '\0';
    
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        return result; // Invalid pattern
    }
    
    result[0] = '\0';
    regmatch_t matches[1];
    const char* search_start = temp;
    int last_end = 0;
    
    while (*search_start) {
        int ret = regexec(&regex, search_start, 1, matches, 0);
        if (ret != 0) break; // No more matches
        
        int start = matches[0].rm_so;
        int end = matches[0].rm_eo;
        if (start < 0 || end <= start) break;
        
        int current_len = strlen(result);
        int text_pos = search_start - temp + start;
        
        // Copy part before match
        if (text_pos > last_end) {
            int len = text_pos - last_end;
            if (current_len + len < sizeof(result) - 1) {
                strncat(result, temp + last_end, len);
            }
        }
        
        // Add replacement
        if (current_len + strlen(repl) < sizeof(result) - 1) {
            strcat(result, repl);
        }
        
        last_end = text_pos + (end - start);
        search_start += end;
        
        // Avoid infinite loop on zero-length matches
        if (end == start) search_start++;
    }
    
    // Copy remaining text
    int text_len = strlen(temp);
    if (last_end < text_len) {
        strcat(result, temp + last_end);
    }
    
    regfree(&regex);
    
    // If no matches, return original
    if (strlen(result) == 0) {
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    
    return result;
#endif
}

// regexp.Split - Split by pattern (returns newline-separated string)
char* regexp_Split(const char* pattern, const char* text) {
    static char result[8192]; // 8KB buffer
    result[0] = '\0';
#ifdef _WIN32
    strncpy(result, text, sizeof(result) - 1);
    result[sizeof(result) - 1] = '\0';
    return result; // Not supported on Windows
#else
    
    regex_t regex;
    if (!compile_regex(&regex, pattern)) {
        // Invalid pattern, return original text
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
        return result;
    }
    
    regmatch_t matches[1];
    const char* search_start = text;
    int last_end = 0;
    
    while (*search_start) {
        int ret = regexec(&regex, search_start, 1, matches, 0);
        if (ret != 0) break; // No more matches
        
        int start = matches[0].rm_so;
        int end = matches[0].rm_eo;
        if (start < 0 || end <= start) break;
        
        int text_pos = search_start - text + start;
        int current_len = strlen(result);
        
        // Add part before match
        if (text_pos > last_end) {
            int len = text_pos - last_end;
            if (current_len + len + 2 < sizeof(result)) {
                if (current_len > 0) strcat(result, "\n");
                strncat(result, text + last_end, len);
            }
        }
        
        last_end = text_pos + (end - start);
        search_start += end;
        
        // Avoid infinite loop on zero-length matches
        if (end == start) search_start++;
    }
    
    // Add remaining text
    int text_len = strlen(text);
    if (last_end < text_len) {
        int current_len = strlen(result);
        int len = text_len - last_end;
        if (current_len + len + 2 < sizeof(result)) {
            if (current_len > 0) strcat(result, "\n");
            strcat(result, text + last_end);
        }
    }
    
    // If no matches, return original text
    if (strlen(result) == 0) {
        strncpy(result, text, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    
    regfree(&regex);
    return result;
#endif
}


// ========== rand library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static int rand_initialized = 0;
static unsigned int rand_seed = 0;

static void rand_init() {
    if (!rand_initialized) {
        rand_seed = (unsigned int)time(NULL);
        srand(rand_seed);
        rand_initialized = 1;
    }
}

// rand.Int - Random integer
int rand_Int() {
    rand_init();
    return rand();
}

// rand.Intn - Random integer in range [0, n)
int rand_Intn(int n) {
    if (n <= 0) return 0;
    rand_init();
    return rand() % n;
}

// rand.Float64 - Random float in [0.0, 1.0)
double rand_Float64() {
    rand_init();
    return (double)rand() / (double)(RAND_MAX + 1.0);
}

// rand.Float64Range - Random float in range [min, max)
double rand_Float64Range(double min, double max) {
    if (max <= min) return min;
    rand_init();
    double range = max - min;
    return min + (rand_Float64() * range);
}

// rand.Seed - Seed random number generator
void rand_Seed(int seed) {
    rand_seed = (unsigned int)seed;
    srand(rand_seed);
    rand_initialized = 1;
}

// rand.UUID - Generate UUID v4 (random UUID)
char* rand_UUID() {
    static char uuid[37]; // 36 chars + null terminator
    rand_init();
    
    // Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    // where x is any hexadecimal digit and y is one of 8, 9, A, or B
    const char hex[] = "0123456789abcdef";
    
    int i = 0;
    for (int pos = 0; pos < 36; pos++) {
        if (pos == 8 || pos == 13 || pos == 18 || pos == 23) {
            uuid[pos] = '-';
        } else if (pos == 14) {
            // Version 4 identifier
            uuid[pos] = '4';
        } else if (pos == 19) {
            // Variant identifier (8, 9, a, or b)
            char variants[] = "89ab";
            uuid[pos] = variants[rand_Intn(4)];
        } else {
            uuid[pos] = hex[rand_Intn(16)];
        }
    }
    uuid[36] = '\0';
    return uuid;
}

// rand.RandomString - Generate random string of given length
char* rand_RandomString(int length) {
    static char result[1024]; // Max 1023 characters
    if (length <= 0) {
        result[0] = '\0';
        return result;
    }
    if (length >= sizeof(result)) {
        length = sizeof(result) - 1;
    }
    
    rand_init();
    const char chars[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int chars_len = 62; // 26 lowercase + 26 uppercase + 10 digits
    
    for (int i = 0; i < length; i++) {
        result[i] = chars[rand_Intn(chars_len)];
    }
    result[length] = '\0';
    return result;
}

// rand.Shuffle - Shuffle array in place
// Note: Requires array support in Tlang (placeholder implementation)
void rand_Shuffle(int* arr, int len) {
    if (arr == NULL || len <= 1) return;
    rand_init();
    
    // Fisher-Yates shuffle algorithm
    for (int i = len - 1; i > 0; i--) {
        int j = rand_Intn(i + 1);
        // Swap arr[i] and arr[j]
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

// rand.Choice - Random element from string array
// Note: Requires array support in Tlang (placeholder implementation)
char* rand_Choice(char** arr, int len) {
    if (arr == NULL || len <= 0) {
        static char empty[1] = "";
        return empty;
    }
    rand_init();
    int index = rand_Intn(len);
    return arr[index];
}


// ========== log library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>

// Log levels
#define LOG_DEBUG 0
#define LOG_INFO 1
#define LOG_WARN 2
#define LOG_ERROR 3
#define LOG_FATAL 4

// Global log state
static FILE* log_file = NULL;
static int log_level = LOG_INFO; // Default to INFO
static int log_initialized = 0;
static char log_filename[256] = "";

static void log_init() {
    if (!log_initialized) {
        log_file = stdout;
        log_initialized = 1;
    }
}

static void log_get_timestamp(char* buffer, int size) {
    time_t now = time(NULL);
    struct tm* tm_info = localtime(&now);
    strftime(buffer, size, "%Y-%m-%d %H:%M:%S", tm_info);
}

static const char* log_level_name(int level) {
    switch (level) {
        case LOG_DEBUG: return "DEBUG";
        case LOG_INFO: return "INFO";
        case LOG_WARN: return "WARN";
        case LOG_ERROR: return "ERROR";
        case LOG_FATAL: return "FATAL";
        default: return "UNKNOWN";
    }
}

static void log_write(int level, const char* message) {
    log_init();
    
    // Check if message should be logged based on level
    if (level < log_level) {
        return;
    }
    
    char timestamp[32];
    log_get_timestamp(timestamp, sizeof(timestamp));
    
    fprintf(log_file, "[%s] [%s] %s\n", timestamp, log_level_name(level), message);
    fflush(log_file);
}

// log.Print - Print log message (INFO level)
void log_Print(const char* message) {
    log_write(LOG_INFO, message);
}

// log.Printf - Formatted log message (INFO level)
void log_Printf(const char* format, ...) {
    log_init();
    
    if (LOG_INFO < log_level) {
        return;
    }
    
    char timestamp[32];
    log_get_timestamp(timestamp, sizeof(timestamp));
    
    fprintf(log_file, "[%s] [INFO] ", timestamp);
    
    va_list args;
    va_start(args, format);
    vfprintf(log_file, format, args);
    va_end(args);
    
    fprintf(log_file, "\n");
    fflush(log_file);
}

// log.Debug - Debug level log
void log_Debug(const char* message) {
    log_write(LOG_DEBUG, message);
}

// log.Info - Info level log
void log_Info(const char* message) {
    log_write(LOG_INFO, message);
}

// log.Warn - Warning level log
void log_Warn(const char* message) {
    log_write(LOG_WARN, message);
}

// log.Error - Error level log
void log_Error(const char* message) {
    log_write(LOG_ERROR, message);
}

// log.Fatal - Log and exit program
void log_Fatal(const char* message) {
    log_write(LOG_FATAL, message);
    exit(1);
}

// log.SetOutput - Set log output file
int log_SetOutput(const char* filename) {
    // Close existing file if open and not stdout/stderr
    if (log_file != NULL && log_file != stdout && log_file != stderr) {
        fclose(log_file);
    }
    
    // Open new file
    log_file = fopen(filename, "a"); // Append mode
    if (log_file == NULL) {
        return 0; // Failed to open file
    }
    
    strncpy(log_filename, filename, sizeof(log_filename) - 1);
    log_filename[sizeof(log_filename) - 1] = '\0';
    log_initialized = 1;
    return 1; // Success
}

// log.SetLevel - Set log level
void log_SetLevel(int level) {
    if (level >= LOG_DEBUG && level <= LOG_FATAL) {
        log_level = level;
    }
}

// log.GetLevel - Get current log level
int log_GetLevel() {
    return log_level;
}

// log.Reset - Reset log output to stdout
void log_Reset() {
    if (log_file != NULL && log_file != stdout && log_file != stderr) {
        fclose(log_file);
    }
    log_file = stdout;
    log_level = LOG_INFO;
    log_filename[0] = '\0';
}


// ========== flag library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_FLAGS 64
#define MAX_FLAG_NAME 64
#define MAX_FLAG_VALUE 256
#define MAX_ARGS 128

typedef struct {
    char name[MAX_FLAG_NAME];
    char type;  // 's'=string, 'i'=int, 'f'=float, 'b'=bool
    char value[MAX_FLAG_VALUE];
    char default_value[MAX_FLAG_VALUE];
    char usage[256];
    int is_set;
} Flag;

static Flag flags[MAX_FLAGS];
static int flag_count = 0;
static int flag_parsed = 0;
static char non_flag_args[MAX_ARGS][MAX_FLAG_VALUE];
static int non_flag_count = 0;

static int find_flag(const char* name) {
    for (int i = 0; i < flag_count; i++) {
        if (strcmp(flags[i].name, name) == 0) {
            return i;
        }
    }
    return -1;
}

static int register_flag(const char* name, char type, const char* default_val, const char* usage) {
    if (flag_count >= MAX_FLAGS) return -1;
    
    strncpy(flags[flag_count].name, name, MAX_FLAG_NAME - 1);
    flags[flag_count].name[MAX_FLAG_NAME - 1] = '\0';
    flags[flag_count].type = type;
    strncpy(flags[flag_count].default_value, default_val, MAX_FLAG_VALUE - 1);
    flags[flag_count].default_value[MAX_FLAG_VALUE - 1] = '\0';
    strncpy(flags[flag_count].value, default_val, MAX_FLAG_VALUE - 1);
    flags[flag_count].value[MAX_FLAG_VALUE - 1] = '\0';
    strncpy(flags[flag_count].usage, usage, 255);
    flags[flag_count].usage[255] = '\0';
    flags[flag_count].is_set = 0;
    
    return flag_count++;
}

// flag.String - Define string flag
char* flag_String(const char* name, const char* default_val, const char* usage) {
    static char result[MAX_FLAG_VALUE];
    int idx = register_flag(name, 's', default_val, usage);
    if (idx < 0) {
        result[0] = '\0';
        return result;
    }
    strncpy(result, flags[idx].value, MAX_FLAG_VALUE - 1);
    result[MAX_FLAG_VALUE - 1] = '\0';
    return result;
}

// flag.Int - Define integer flag
int flag_Int(const char* name, int default_val, const char* usage) {
    char default_str[32];
    snprintf(default_str, sizeof(default_str), "%d", default_val);
    int idx = register_flag(name, 'i', default_str, usage);
    if (idx < 0) return default_val;
    return atoi(flags[idx].value);
}

// flag.Bool - Define boolean flag
int flag_Bool(const char* name, int default_val, const char* usage) {
    char default_str[32];
    snprintf(default_str, sizeof(default_str), "%d", default_val);
    int idx = register_flag(name, 'b', default_str, usage);
    if (idx < 0) return default_val;
    return atoi(flags[idx].value) != 0;
}

// flag.Float64 - Define float flag
double flag_Float64(const char* name, double default_val, const char* usage) {
    char default_str[32];
    snprintf(default_str, sizeof(default_str), "%f", default_val);
    int idx = register_flag(name, 'f', default_str, usage);
    if (idx < 0) return default_val;
    return atof(flags[idx].value);
}

// flag.Parse - Parse command-line arguments
void flag_Parse() {
    if (flag_parsed) return;
    flag_parsed = 1;
    
    int argc = args_Count();  // args_Count() returns number of args (excluding program name)
    
    for (int i = 0; i < argc; i++) {
        char arg[MAX_FLAG_VALUE];
        strncpy(arg, args_Get(i), MAX_FLAG_VALUE - 1);
        arg[MAX_FLAG_VALUE - 1] = '\0';
        
        // Check if it's a flag (starts with -)
        if (arg[0] == '-' && arg[1] != '\0') {
            char* name = arg + 1;  // Skip -
            char* value = NULL;
            
            // Check for =value format
            char* eq = strchr(name, '=');
            if (eq != NULL) {
                *eq = '\0';
                value = eq + 1;
            } else if (i + 1 < argc) {
                // Check if next arg is a value (not a flag)
                char next[MAX_FLAG_VALUE];
                strncpy(next, args_Get(i + 1), MAX_FLAG_VALUE - 1);
                next[MAX_FLAG_VALUE - 1] = '\0';
                if (next[0] != '-') {
                    value = next;
                    i++;  // Skip next arg
                }
            }
            
            // Find and set flag
            int idx = find_flag(name);
            if (idx >= 0) {
                if (value != NULL) {
                    strncpy(flags[idx].value, value, MAX_FLAG_VALUE - 1);
                    flags[idx].value[MAX_FLAG_VALUE - 1] = '\0';
                } else if (flags[idx].type == 'b') {
                    // Boolean flag: -flag sets to 1
                    strcpy(flags[idx].value, "1");
                }
                flags[idx].is_set = 1;
            }
        } else {
            // Non-flag argument
            if (non_flag_count < MAX_ARGS) {
                strncpy(non_flag_args[non_flag_count], arg, MAX_FLAG_VALUE - 1);
                non_flag_args[non_flag_count][MAX_FLAG_VALUE - 1] = '\0';
                non_flag_count++;
            }
        }
    }
}

// flag.Args - Get non-flag arguments (returns newline-separated string)
char* flag_Args() {
    static char result[4096];
    result[0] = '\0';
    
    for (int i = 0; i < non_flag_count; i++) {
        if (i > 0) strcat(result, "\n");
        strcat(result, non_flag_args[i]);
    }
    
    return result;
}

// flag.GetString - Get string flag value
char* flag_GetString(const char* name) {
    static char result[MAX_FLAG_VALUE];
    result[0] = '\0';
    
    int idx = find_flag(name);
    if (idx >= 0) {
        strncpy(result, flags[idx].value, MAX_FLAG_VALUE - 1);
        result[MAX_FLAG_VALUE - 1] = '\0';
    }
    
    return result;
}

// flag.GetInt - Get integer flag value
int flag_GetInt(const char* name) {
    int idx = find_flag(name);
    if (idx >= 0) {
        return atoi(flags[idx].value);
    }
    return 0;
}

// flag.GetBool - Get boolean flag value
int flag_GetBool(const char* name) {
    int idx = find_flag(name);
    if (idx >= 0) {
        return atoi(flags[idx].value) != 0;
    }
    return 0;
}

// flag.GetFloat64 - Get float flag value
double flag_GetFloat64(const char* name) {
    int idx = find_flag(name);
    if (idx >= 0) {
        return atof(flags[idx].value);
    }
    return 0.0;
}


// ========== crypto/hash library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef USE_OPENSSL
#include <openssl/md5.h>
#include <openssl/sha.h>
#include <openssl/hmac.h>
#include <openssl/evp.h>
#include <openssl/aes.h>
#include <openssl/rand.h>
#include <openssl/des.h>
#include <openssl/err.h>
#include <openssl/pkcs5.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/ec.h>
#include <openssl/ecdsa.h>
#include <openssl/bio.h>
#include <openssl/buffer.h>
#endif

#ifndef USE_OPENSSL
// Simple MD5 implementation (for basic use)
static void md5_transform(unsigned int* buf, unsigned int* in) {
    // Simplified MD5 - for production use OpenSSL
    // This is a placeholder implementation
}
#endif

static void bytes_to_hex(const unsigned char* bytes, int len, char* hex) {
    const char* hex_chars = "0123456789abcdef";
    for (int i = 0; i < len; i++) {
        hex[i * 2] = hex_chars[(bytes[i] >> 4) & 0x0F];
        hex[i * 2 + 1] = hex_chars[bytes[i] & 0x0F];
    }
    hex[len * 2] = '\0';
}

// hash.MD5 - MD5 hash (hex string)
char* hash_MD5(const char* data) {
    static char result[33];  // 32 hex chars + null
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5((unsigned char*)data, strlen(data), digest);
    bytes_to_hex(digest, MD5_DIGEST_LENGTH, result);
#else
    // Simple MD5 implementation (placeholder)
    // For production, compile with -DUSE_OPENSSL and link OpenSSL
    unsigned char digest[16];
    // Simplified hash (not cryptographically secure)
    int len = strlen(data);
    for (int i = 0; i < 16; i++) {
        digest[i] = (unsigned char)((data[i % len] + i) % 256);
    }
    bytes_to_hex(digest, 16, result);
#endif
    
    return result;
}

// hash.SHA1 - SHA1 hash (hex string)
char* hash_SHA1(const char* data) {
    static char result[41];  // 40 hex chars + null
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    unsigned char digest[SHA_DIGEST_LENGTH];
    SHA1((unsigned char*)data, strlen(data), digest);
    bytes_to_hex(digest, SHA_DIGEST_LENGTH, result);
#else
    // Simple SHA1 implementation (placeholder)
    unsigned char digest[20];
    int len = strlen(data);
    for (int i = 0; i < 20; i++) {
        digest[i] = (unsigned char)((data[i % len] + i * 7) % 256);
    }
    bytes_to_hex(digest, 20, result);
#endif
    
    return result;
}

// hash.SHA256 - SHA256 hash (hex string)
char* hash_SHA256(const char* data) {
    static char result[65];  // 64 hex chars + null
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    unsigned char digest[SHA256_DIGEST_LENGTH];
    SHA256((unsigned char*)data, strlen(data), digest);
    bytes_to_hex(digest, SHA256_DIGEST_LENGTH, result);
#else
    // Simple SHA256 implementation (placeholder)
    unsigned char digest[32];
    int len = strlen(data);
    for (int i = 0; i < 32; i++) {
        digest[i] = (unsigned char)((data[i % len] + i * 11) % 256);
    }
    bytes_to_hex(digest, 32, result);
#endif
    
    return result;
}

// hash.SHA512 - SHA512 hash (hex string)
char* hash_SHA512(const char* data) {
    static char result[129];  // 128 hex chars + null
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    unsigned char digest[SHA512_DIGEST_LENGTH];
    SHA512((unsigned char*)data, strlen(data), digest);
    bytes_to_hex(digest, SHA512_DIGEST_LENGTH, result);
#else
    // Simple SHA512 implementation (placeholder)
    unsigned char digest[64];
    int len = strlen(data);
    for (int i = 0; i < 64; i++) {
        digest[i] = (unsigned char)((data[i % len] + i * 13) % 256);
    }
    bytes_to_hex(digest, 64, result);
#endif
    
    return result;
}

// hash.HMAC - HMAC hash
char* hash_HMAC(const char* key, const char* data, const char* algo) {
    static char result[129];  // Max 128 hex chars + null
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    const EVP_MD* md = NULL;
    
    // Determine hash algorithm
    if (strcmp(algo, "md5") == 0 || strcmp(algo, "MD5") == 0) {
        md = EVP_md5();
    } else if (strcmp(algo, "sha1") == 0 || strcmp(algo, "SHA1") == 0) {
        md = EVP_sha1();
    } else if (strcmp(algo, "sha256") == 0 || strcmp(algo, "SHA256") == 0) {
        md = EVP_sha256();
    } else if (strcmp(algo, "sha512") == 0 || strcmp(algo, "SHA512") == 0) {
        md = EVP_sha512();
    } else {
        // Default to SHA256
        md = EVP_sha256();
    }
    
    unsigned char* digest = (unsigned char*)malloc(EVP_MAX_MD_SIZE);
    unsigned int digest_len;
    
    HMAC(md, key, strlen(key), (unsigned char*)data, strlen(data), digest, &digest_len);
    bytes_to_hex(digest, digest_len, result);
    free(digest);
#else
    // Simple HMAC implementation (placeholder)
    // Combine key and data, then hash
    char combined[512];
    snprintf(combined, sizeof(combined), "%s%s", key, data);
    
    // Use SHA256 as default
    if (strcmp(algo, "md5") == 0 || strcmp(algo, "MD5") == 0) {
        strcpy(result, hash_MD5(combined));
    } else if (strcmp(algo, "sha1") == 0 || strcmp(algo, "SHA1") == 0) {
        strcpy(result, hash_SHA1(combined));
    } else if (strcmp(algo, "sha512") == 0 || strcmp(algo, "SHA512") == 0) {
        strcpy(result, hash_SHA512(combined));
    } else {
        strcpy(result, hash_SHA256(combined));
    }
#endif
    
    return result;
}

static int hex_to_bytes(const char* hex, unsigned char* bytes, int max_len) {
    int len = strlen(hex);
    if (len % 2 != 0 || len / 2 > max_len) return 0;
    for (int i = 0; i < len / 2; i++) {
        int val;
        sscanf(hex + i * 2, "%2x", &val);
        bytes[i] = (unsigned char)val;
    }
    return len / 2;
}

static char* base64_encode_simple(const unsigned char* data, int len) {
    static char result[4096];
    const char* base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    int i = 0, j = 0;
    for (i = 0; i < len - 2; i += 3) {
        result[j++] = base64_chars[(data[i] >> 2) & 0x3F];
        result[j++] = base64_chars[((data[i] & 0x3) << 4) | ((data[i+1] & 0xF0) >> 4)];
        result[j++] = base64_chars[((data[i+1] & 0xF) << 2) | ((data[i+2] & 0xC0) >> 6)];
        result[j++] = base64_chars[data[i+2] & 0x3F];
    }
    if (i < len) {
        result[j++] = base64_chars[(data[i] >> 2) & 0x3F];
        if (i == len - 1) {
            result[j++] = base64_chars[((data[i] & 0x3) << 4)];
            result[j++] = '=';
        } else {
            result[j++] = base64_chars[((data[i] & 0x3) << 4) | ((data[i+1] & 0xF0) >> 4)];
            result[j++] = base64_chars[((data[i+1] & 0xF) << 2)];
        }
        result[j++] = '=';
    }
    result[j] = '\0';
    return result;
}

// crypto.AESEncrypt - AES encryption (returns base64 encoded)
char* crypto_AESEncrypt(const char* data, const char* key, const char* mode) {
    static char result[8192];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    const EVP_CIPHER* cipher = NULL;
    int key_len = strlen(key);
    
    // Determine cipher based on key length and mode
    if (strcmp(mode, "cbc") == 0 || strcmp(mode, "CBC") == 0) {
        if (key_len == 16) cipher = EVP_aes_128_cbc();
        else if (key_len == 24) cipher = EVP_aes_192_cbc();
        else if (key_len == 32) cipher = EVP_aes_256_cbc();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    } else if (strcmp(mode, "ecb") == 0 || strcmp(mode, "ECB") == 0) {
        if (key_len == 16) cipher = EVP_aes_128_ecb();
        else if (key_len == 24) cipher = EVP_aes_192_ecb();
        else if (key_len == 32) cipher = EVP_aes_256_ecb();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    } else {
        // Default to CBC
        if (key_len == 16) cipher = EVP_aes_128_cbc();
        else if (key_len == 24) cipher = EVP_aes_192_cbc();
        else if (key_len == 32) cipher = EVP_aes_256_cbc();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    }
    
    unsigned char iv[16];
    if (strcmp(mode, "ecb") != 0 && strcmp(mode, "ECB") != 0) {
        RAND_bytes(iv, 16);
    }
    
    int len = strlen(data);
    unsigned char* out = (unsigned char*)malloc(len + 16);
    int outlen, finallen;
    
    EVP_EncryptInit_ex(ctx, cipher, NULL, (unsigned char*)key, iv);
    EVP_EncryptUpdate(ctx, out, &outlen, (unsigned char*)data, len);
    EVP_EncryptFinal_ex(ctx, out + outlen, &finallen);
    
    // Combine IV + ciphertext and base64 encode
    unsigned char* combined = (unsigned char*)malloc(16 + outlen + finallen);
    if (strcmp(mode, "ecb") != 0 && strcmp(mode, "ECB") != 0) {
        memcpy(combined, iv, 16);
        memcpy(combined + 16, out, outlen + finallen);
        strcpy(result, base64_encode_simple(combined, 16 + outlen + finallen));
    } else {
        strcpy(result, base64_encode_simple(out, outlen + finallen));
    }
    
    free(out);
    if (strcmp(mode, "ecb") != 0 && strcmp(mode, "ECB") != 0) free(combined);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - XOR cipher (NOT SECURE, for testing only)
    int len = strlen(data);
    unsigned char* encrypted = (unsigned char*)malloc(len);
    int key_len = strlen(key);
    for (int i = 0; i < len; i++) {
        encrypted[i] = data[i] ^ key[i % key_len];
    }
    strcpy(result, base64_encode_simple(encrypted, len));
    free(encrypted);
#endif
    
    return result;
}

// crypto.AESDecrypt - AES decryption (takes base64 encoded input)
char* crypto_AESDecrypt(const char* encrypted, const char* key, const char* mode) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    // Base64 decode (simplified - use proper base64 library in production)
    // For now, assume encrypted is already binary or handle base64 separately
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    const EVP_CIPHER* cipher = NULL;
    int key_len = strlen(key);
    
    if (strcmp(mode, "cbc") == 0 || strcmp(mode, "CBC") == 0) {
        if (key_len == 16) cipher = EVP_aes_128_cbc();
        else if (key_len == 24) cipher = EVP_aes_192_cbc();
        else if (key_len == 32) cipher = EVP_aes_256_cbc();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    } else if (strcmp(mode, "ecb") == 0 || strcmp(mode, "ECB") == 0) {
        if (key_len == 16) cipher = EVP_aes_128_ecb();
        else if (key_len == 24) cipher = EVP_aes_192_ecb();
        else if (key_len == 32) cipher = EVP_aes_256_ecb();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    } else {
        if (key_len == 16) cipher = EVP_aes_128_cbc();
        else if (key_len == 24) cipher = EVP_aes_192_cbc();
        else if (key_len == 32) cipher = EVP_aes_256_cbc();
        else { EVP_CIPHER_CTX_free(ctx); return result; }
    }
    
    // Extract IV from encrypted data (first 16 bytes for CBC)
    unsigned char iv[16];
    int enc_len = strlen(encrypted);
    unsigned char* ciphertext = (unsigned char*)encrypted;
    
    if (strcmp(mode, "ecb") != 0 && strcmp(mode, "ECB") != 0 && enc_len > 16) {
        memcpy(iv, encrypted, 16);
        ciphertext = (unsigned char*)(encrypted + 16);
        enc_len -= 16;
    }
    
    unsigned char* out = (unsigned char*)malloc(enc_len + 16);
    int outlen, finallen;
    
    EVP_DecryptInit_ex(ctx, cipher, NULL, (unsigned char*)key, iv);
    EVP_DecryptUpdate(ctx, out, &outlen, ciphertext, enc_len);
    EVP_DecryptFinal_ex(ctx, out + outlen, &finallen);
    
    out[outlen + finallen] = '\0';
    strcpy(result, (char*)out);
    
    free(out);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - XOR cipher (NOT SECURE, for testing only)
    int len = strlen(encrypted);
    unsigned char* decrypted = (unsigned char*)malloc(len);
    int key_len = strlen(key);
    for (int i = 0; i < len; i++) {
        decrypted[i] = encrypted[i] ^ key[i % key_len];
    }
    decrypted[len] = '\0';
    strcpy(result, (char*)decrypted);
    free(decrypted);
#endif
    
    return result;
}

// crypto.DESEncrypt - DES encryption (deprecated, use AES instead)
char* crypto_DESEncrypt(const char* data, const char* key) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    DES_cblock key_block;
    memcpy(key_block, key, 8);
    DES_key_schedule schedule;
    DES_set_key_unchecked(&key_block, &schedule);
    
    unsigned char iv[8];
    RAND_bytes(iv, 8);
    
    int len = strlen(data);
    int padded_len = ((len + 7) / 8) * 8;
    unsigned char* padded = (unsigned char*)malloc(padded_len);
    memcpy(padded, data, len);
    memset(padded + len, 0, padded_len - len);
    
    unsigned char* encrypted = (unsigned char*)malloc(padded_len + 8);
    memcpy(encrypted, iv, 8);
    
    DES_cblock ivec;
    memcpy(ivec, iv, 8);
    
    DES_ncbc_encrypt(padded, encrypted + 8, padded_len, &schedule, &ivec, DES_ENCRYPT);
    
    strcpy(result, base64_encode_simple(encrypted, padded_len + 8));
    
    free(padded);
    free(encrypted);
#else
    // Placeholder
    strcpy(result, "DES requires OpenSSL");
#endif
    
    return result;
}

// crypto.DESDecrypt - DES decryption
char* crypto_DESDecrypt(const char* encrypted, const char* key) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    DES_cblock key_block;
    memcpy(key_block, key, 8);
    DES_key_schedule schedule;
    DES_set_key_unchecked(&key_block, &schedule);
    
    // Extract IV (first 8 bytes)
    unsigned char iv[8];
    memcpy(iv, encrypted, 8);
    
    int enc_len = strlen(encrypted) - 8;
    unsigned char* decrypted = (unsigned char*)malloc(enc_len);
    
    DES_cblock ivec;
    memcpy(ivec, iv, 8);
    
    DES_ncbc_encrypt((unsigned char*)(encrypted + 8), decrypted, enc_len, &schedule, &ivec, DES_DECRYPT);
    
    decrypted[enc_len] = '\0';
    strcpy(result, (char*)decrypted);
    
    free(decrypted);
#else
    strcpy(result, "DES requires OpenSSL");
#endif
    
    return result;
}

// crypto.GenerateKey - Generate random encryption key
char* crypto_GenerateKey(int length) {
    static char result[65];  // Max 64 bytes (512 bits)
    result[0] = '\0';
    
    if (length < 1 || length > 64) length = 32;  // Default to 256 bits
    
#ifdef USE_OPENSSL
    unsigned char* key = (unsigned char*)malloc(length);
    RAND_bytes(key, length);
    bytes_to_hex(key, length, result);
    free(key);
#else
    // Simple pseudo-random (NOT CRYPTOGRAPHICALLY SECURE)
    for (int i = 0; i < length; i++) {
        unsigned char byte = (unsigned char)(rand() % 256);
        sprintf(result + i * 2, "%02x", byte);
    }
#endif
    
    return result;
}

// crypto.AESGCMEncrypt - AES-GCM authenticated encryption
char* crypto_AESGCMEncrypt(const char* data, const char* key, const char* aad) {
    static char result[8192];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    const EVP_CIPHER* cipher = NULL;
    int key_len = strlen(key);
    
    if (key_len == 16) cipher = EVP_aes_128_gcm();
    else if (key_len == 24) cipher = EVP_aes_192_gcm();
    else if (key_len == 32) cipher = EVP_aes_256_gcm();
    else { EVP_CIPHER_CTX_free(ctx); return result; }
    
    unsigned char iv[12];  // 96-bit IV for GCM
    RAND_bytes(iv, 12);
    
    int len = strlen(data);
    unsigned char* out = (unsigned char*)malloc(len + 16);
    unsigned char tag[16];  // Authentication tag
    int outlen, finallen;
    
    EVP_EncryptInit_ex(ctx, cipher, NULL, (unsigned char*)key, iv);
    
    // Add AAD (Additional Authenticated Data) if provided
    if (aad && strlen(aad) > 0) {
        int aad_len = strlen(aad);
        EVP_EncryptUpdate(ctx, NULL, &outlen, (unsigned char*)aad, aad_len);
    }
    
    EVP_EncryptUpdate(ctx, out, &outlen, (unsigned char*)data, len);
    EVP_EncryptFinal_ex(ctx, out + outlen, &finallen);
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, tag);
    
    // Combine: IV (12 bytes) + ciphertext + tag (16 bytes)
    unsigned char* combined = (unsigned char*)malloc(12 + outlen + finallen + 16);
    memcpy(combined, iv, 12);
    memcpy(combined + 12, out, outlen + finallen);
    memcpy(combined + 12 + outlen + finallen, tag, 16);
    
    strcpy(result, base64_encode_simple(combined, 12 + outlen + finallen + 16));
    
    free(out);
    free(combined);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - use AES CBC as fallback
    strcpy(result, crypto_AESEncrypt(data, key, "cbc"));
#endif
    
    return result;
}

// crypto.AESGCMDecrypt - AES-GCM authenticated decryption
char* crypto_AESGCMDecrypt(const char* encrypted, const char* key, const char* aad) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    const EVP_CIPHER* cipher = NULL;
    int key_len = strlen(key);
    
    if (key_len == 16) cipher = EVP_aes_128_gcm();
    else if (key_len == 24) cipher = EVP_aes_192_gcm();
    else if (key_len == 32) cipher = EVP_aes_256_gcm();
    else { EVP_CIPHER_CTX_free(ctx); return result; }
    
    // Extract IV (12 bytes), ciphertext, and tag (16 bytes)
    int enc_len = strlen(encrypted);
    if (enc_len < 28) { EVP_CIPHER_CTX_free(ctx); return result; }
    
    unsigned char iv[12];
    memcpy(iv, encrypted, 12);
    
    unsigned char tag[16];
    memcpy(tag, encrypted + enc_len - 16, 16);
    
    unsigned char* ciphertext = (unsigned char*)(encrypted + 12);
    int ciphertext_len = enc_len - 28;
    
    unsigned char* out = (unsigned char*)malloc(ciphertext_len + 16);
    int outlen, finallen;
    
    EVP_DecryptInit_ex(ctx, cipher, NULL, (unsigned char*)key, iv);
    
    // Add AAD if provided
    if (aad && strlen(aad) > 0) {
        int aad_len = strlen(aad);
        EVP_DecryptUpdate(ctx, NULL, &outlen, (unsigned char*)aad, aad_len);
    }
    
    EVP_DecryptUpdate(ctx, out, &outlen, ciphertext, ciphertext_len);
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, tag);
    
    int ret = EVP_DecryptFinal_ex(ctx, out + outlen, &finallen);
    if (ret <= 0) {
        // Authentication failed
        free(out);
        EVP_CIPHER_CTX_free(ctx);
        return result;
    }
    
    out[outlen + finallen] = '\0';
    strcpy(result, (char*)out);
    
    free(out);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - use AES CBC as fallback
    strcpy(result, crypto_AESDecrypt(encrypted, key, "cbc"));
#endif
    
    return result;
}

// crypto.ChaCha20Poly1305Encrypt - ChaCha20-Poly1305 authenticated encryption
char* crypto_ChaCha20Poly1305Encrypt(const char* data, const char* key, const char* nonce, const char* aad) {
    static char result[8192];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    // ChaCha20-Poly1305 requires 32-byte key and 12-byte nonce
    int key_len = strlen(key);
    if (key_len != 32) { EVP_CIPHER_CTX_free(ctx); return result; }
    
    unsigned char nonce_bytes[12];
    if (nonce && strlen(nonce) >= 12) {
        memcpy(nonce_bytes, nonce, 12);
    } else {
        RAND_bytes(nonce_bytes, 12);
    }
    
    int len = strlen(data);
    unsigned char* out = (unsigned char*)malloc(len + 16);
    unsigned char tag[16];
    int outlen, finallen;
    
    EVP_EncryptInit_ex(ctx, EVP_chacha20_poly1305(), NULL, (unsigned char*)key, nonce_bytes);
    
    // Add AAD if provided
    if (aad && strlen(aad) > 0) {
        int aad_len = strlen(aad);
        EVP_EncryptUpdate(ctx, NULL, &outlen, (unsigned char*)aad, aad_len);
    }
    
    EVP_EncryptUpdate(ctx, out, &outlen, (unsigned char*)data, len);
    EVP_EncryptFinal_ex(ctx, out + outlen, &finallen);
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_GET_TAG, 16, tag);
    
    // Combine: nonce (12 bytes) + ciphertext + tag (16 bytes)
    unsigned char* combined = (unsigned char*)malloc(12 + outlen + finallen + 16);
    memcpy(combined, nonce_bytes, 12);
    memcpy(combined + 12, out, outlen + finallen);
    memcpy(combined + 12 + outlen + finallen, tag, 16);
    
    strcpy(result, base64_encode_simple(combined, 12 + outlen + finallen + 16));
    
    free(out);
    free(combined);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - XOR cipher (NOT SECURE)
    int len = strlen(data);
    unsigned char* encrypted = (unsigned char*)malloc(len);
    int key_len = strlen(key);
    for (int i = 0; i < len; i++) {
        encrypted[i] = data[i] ^ key[i % key_len];
    }
    strcpy(result, base64_encode_simple(encrypted, len));
    free(encrypted);
#endif
    
    return result;
}

// crypto.ChaCha20Poly1305Decrypt - ChaCha20-Poly1305 authenticated decryption
char* crypto_ChaCha20Poly1305Decrypt(const char* encrypted, const char* key, const char* nonce, const char* aad) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) return result;
    
    int key_len = strlen(key);
    if (key_len != 32) { EVP_CIPHER_CTX_free(ctx); return result; }
    
    // Extract nonce (12 bytes), ciphertext, and tag (16 bytes)
    int enc_len = strlen(encrypted);
    if (enc_len < 28) { EVP_CIPHER_CTX_free(ctx); return result; }
    
    unsigned char nonce_bytes[12];
    if (nonce && strlen(nonce) >= 12) {
        memcpy(nonce_bytes, nonce, 12);
    } else {
        memcpy(nonce_bytes, encrypted, 12);
    }
    
    unsigned char tag[16];
    memcpy(tag, encrypted + enc_len - 16, 16);
    
    unsigned char* ciphertext = (unsigned char*)(encrypted + 12);
    int ciphertext_len = enc_len - 28;
    
    unsigned char* out = (unsigned char*)malloc(ciphertext_len + 16);
    int outlen, finallen;
    
    EVP_DecryptInit_ex(ctx, EVP_chacha20_poly1305(), NULL, (unsigned char*)key, nonce_bytes);
    
    // Add AAD if provided
    if (aad && strlen(aad) > 0) {
        int aad_len = strlen(aad);
        EVP_DecryptUpdate(ctx, NULL, &outlen, (unsigned char*)aad, aad_len);
    }
    
    EVP_DecryptUpdate(ctx, out, &outlen, ciphertext, ciphertext_len);
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_AEAD_SET_TAG, 16, tag);
    
    int ret = EVP_DecryptFinal_ex(ctx, out + outlen, &finallen);
    if (ret <= 0) {
        // Authentication failed
        free(out);
        EVP_CIPHER_CTX_free(ctx);
        return result;
    }
    
    out[outlen + finallen] = '\0';
    strcpy(result, (char*)out);
    
    free(out);
    EVP_CIPHER_CTX_free(ctx);
#else
    // Placeholder - XOR cipher (NOT SECURE)
    int len = strlen(encrypted);
    unsigned char* decrypted = (unsigned char*)malloc(len);
    int key_len = strlen(key);
    for (int i = 0; i < len; i++) {
        decrypted[i] = encrypted[i] ^ key[i % key_len];
    }
    decrypted[len] = '\0';
    strcpy(result, (char*)decrypted);
    free(decrypted);
#endif
    
    return result;
}

// crypto.PBKDF2 - Password-Based Key Derivation Function 2
char* crypto_PBKDF2(const char* password, const char* salt, int iterations, int keyLength, const char* hashAlgo) {
    static char result[129];  // Max 64 bytes = 128 hex chars + null
    result[0] = '\0';
    
    if (keyLength < 1 || keyLength > 64) keyLength = 32;  // Default 32 bytes
    if (iterations < 1) iterations = 10000;  // Default 10000 iterations
    
#ifdef USE_OPENSSL
    const EVP_MD* md = NULL;
    
    // Determine hash algorithm
    if (strcmp(hashAlgo, "sha1") == 0 || strcmp(hashAlgo, "SHA1") == 0) {
        md = EVP_sha1();
    } else if (strcmp(hashAlgo, "sha256") == 0 || strcmp(hashAlgo, "SHA256") == 0) {
        md = EVP_sha256();
    } else if (strcmp(hashAlgo, "sha512") == 0 || strcmp(hashAlgo, "SHA512") == 0) {
        md = EVP_sha512();
    } else {
        md = EVP_sha256();  // Default to SHA256
    }
    
    unsigned char* key = (unsigned char*)malloc(keyLength);
    
    int ret = PKCS5_PBKDF2_HMAC(password, strlen(password), (unsigned char*)salt, strlen(salt), iterations, md, keyLength, key);
    
    if (ret == 1) {
        bytes_to_hex(key, keyLength, result);
    }
    
    free(key);
#else
    // Placeholder - simple key derivation (NOT SECURE)
    // In production, always use OpenSSL PBKDF2
    char combined[512];
    snprintf(combined, sizeof(combined), "%s%s", password, salt);
    
    // Simple repeated hashing (NOT PBKDF2, just for testing)
    char* temp = (char*)malloc(strlen(combined) + 1);
    strcpy(temp, combined);
    for (int i = 0; i < iterations && i < 100; i++) {  // Limit iterations for testing
        char* hash = hash_SHA256(temp);
        strcpy(temp, hash);
    }
    
    // Take first keyLength bytes
    strncpy(result, temp, keyLength * 2);
    result[keyLength * 2] = '\0';
    free(temp);
#endif
    
    return result;
}

// crypto.RSAGenerateKeyPair - Generate RSA key pair
char* crypto_RSAGenerateKeyPair(int bits) {
    static char result[8192];  // Large enough for key pair
    result[0] = '\0';
    
    if (bits < 512) bits = 2048;  // Default to 2048 bits
    if (bits > 4096) bits = 4096;  // Max 4096 bits
    
#ifdef USE_OPENSSL
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);
    if (!ctx) return result;
    
    if (EVP_PKEY_keygen_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    if (EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, bits) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    EVP_PKEY* pkey = NULL;
    if (EVP_PKEY_keygen(ctx, &pkey) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    // Export keys to PEM format
    BIO* bio_private = BIO_new(BIO_s_mem());
    BIO* bio_public = BIO_new(BIO_s_mem());
    
    PEM_write_bio_PrivateKey(bio_private, pkey, NULL, NULL, 0, NULL, NULL);
    PEM_write_bio_PUBKEY(bio_public, pkey);
    
    BUF_MEM* private_mem;
    BUF_MEM* public_mem;
    BIO_get_mem_ptr(bio_private, &private_mem);
    BIO_get_mem_ptr(bio_public, &public_mem);
    
    // Format: "PRIVATE_KEY|PUBLIC_KEY"
    int total_len = private_mem->length + public_mem->length + 2;
    if (total_len < sizeof(result)) {
        memcpy(result, private_mem->data, private_mem->length);
        result[private_mem->length] = '|';
        memcpy(result + private_mem->length + 1, public_mem->data, public_mem->length);
        result[total_len - 1] = '\0';
    }
    
    BIO_free(bio_private);
    BIO_free(bio_public);
    EVP_PKEY_free(pkey);
    EVP_PKEY_CTX_free(ctx);
#else
    strcpy(result, "RSA requires OpenSSL");
#endif
    
    return result;
}

// crypto.RSAEncrypt - RSA encryption with public key
char* crypto_RSAEncrypt(const char* data, const char* publicKeyPEM) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(publicKeyPEM, -1);
    if (!bio) return result;
    
    EVP_PKEY* pkey = PEM_read_bio_PUBKEY(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return result;
    
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) { EVP_PKEY_free(pkey); return result; }
    
    if (EVP_PKEY_encrypt_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    size_t outlen;
    int data_len = strlen(data);
    
    // Determine output buffer size
    if (EVP_PKEY_encrypt(ctx, NULL, &outlen, (unsigned char*)data, data_len) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    unsigned char* out = (unsigned char*)malloc(outlen);
    if (EVP_PKEY_encrypt(ctx, out, &outlen, (unsigned char*)data, data_len) <= 0) {
        free(out);
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    strcpy(result, base64_encode_simple(out, outlen));
    
    free(out);
    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(pkey);
#else
    strcpy(result, "RSA requires OpenSSL");
#endif
    
    return result;
}

// crypto.RSADecrypt - RSA decryption with private key
char* crypto_RSADecrypt(const char* encrypted, const char* privateKeyPEM) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(privateKeyPEM, -1);
    if (!bio) return result;
    
    EVP_PKEY* pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return result;
    
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) { EVP_PKEY_free(pkey); return result; }
    
    if (EVP_PKEY_decrypt_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    if (EVP_PKEY_CTX_set_rsa_padding(ctx, RSA_PKCS1_OAEP_PADDING) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    // Base64 decode encrypted data (simplified - use proper base64 in production)
    int enc_len = strlen(encrypted);
    unsigned char* ciphertext = (unsigned char*)encrypted;  // Simplified
    
    size_t outlen;
    if (EVP_PKEY_decrypt(ctx, NULL, &outlen, ciphertext, enc_len) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    unsigned char* out = (unsigned char*)malloc(outlen);
    if (EVP_PKEY_decrypt(ctx, out, &outlen, ciphertext, enc_len) <= 0) {
        free(out);
        EVP_PKEY_CTX_free(ctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    out[outlen] = '\0';
    strcpy(result, (char*)out);
    
    free(out);
    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(pkey);
#else
    strcpy(result, "RSA requires OpenSSL");
#endif
    
    return result;
}

// crypto.RSASign - Create RSA digital signature
char* crypto_RSASign(const char* data, const char* privateKeyPEM) {
    static char result[1024];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(privateKeyPEM, -1);
    if (!bio) return result;
    
    EVP_PKEY* pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return result;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return result; }
    
    if (EVP_DigestSignInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    if (EVP_DigestSignUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    size_t siglen;
    if (EVP_DigestSignFinal(mdctx, NULL, &siglen) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    unsigned char* sig = (unsigned char*)malloc(siglen);
    if (EVP_DigestSignFinal(mdctx, sig, &siglen) <= 0) {
        free(sig);
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    bytes_to_hex(sig, siglen, result);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
#else
    strcpy(result, "RSA requires OpenSSL");
#endif
    
    return result;
}

// crypto.RSAVerify - Verify RSA digital signature
int crypto_RSAVerify(const char* data, const char* signature, const char* publicKeyPEM) {
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(publicKeyPEM, -1);
    if (!bio) return 0;
    
    EVP_PKEY* pkey = PEM_read_bio_PUBKEY(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return 0;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return 0; }
    
    if (EVP_DigestVerifyInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    if (EVP_DigestVerifyUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    // Convert hex signature to bytes
    int sig_len = strlen(signature) / 2;
    unsigned char* sig = (unsigned char*)malloc(sig_len);
    hex_to_bytes(signature, sig, sig_len);
    
    int ret = EVP_DigestVerifyFinal(mdctx, sig, sig_len);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
    
    return (ret == 1) ? 1 : 0;
#else
    return 0;
#endif
}

// crypto.ECCGenerateKeyPair - Generate ECC key pair
char* crypto_ECCGenerateKeyPair(const char* curve) {
    static char result[4096];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    int nid;
    
    // Determine curve
    if (strcmp(curve, "P-256") == 0 || strcmp(curve, "secp256r1") == 0) {
        nid = NID_X9_62_prime256v1;
    } else if (strcmp(curve, "P-384") == 0 || strcmp(curve, "secp384r1") == 0) {
        nid = NID_secp384r1;
    } else if (strcmp(curve, "P-521") == 0 || strcmp(curve, "secp521r1") == 0) {
        nid = NID_secp521r1;
    } else {
        nid = NID_X9_62_prime256v1;  // Default to P-256
    }
    
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_EC, NULL);
    if (!ctx) return result;
    
    if (EVP_PKEY_keygen_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    if (EVP_PKEY_CTX_set_ec_paramgen_curve_nid(ctx, nid) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    EVP_PKEY* pkey = NULL;
    if (EVP_PKEY_keygen(ctx, &pkey) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    // Export keys to PEM format
    BIO* bio_private = BIO_new(BIO_s_mem());
    BIO* bio_public = BIO_new(BIO_s_mem());
    
    PEM_write_bio_PrivateKey(bio_private, pkey, NULL, NULL, 0, NULL, NULL);
    PEM_write_bio_PUBKEY(bio_public, pkey);
    
    BUF_MEM* private_mem;
    BUF_MEM* public_mem;
    BIO_get_mem_ptr(bio_private, &private_mem);
    BIO_get_mem_ptr(bio_public, &public_mem);
    
    int total_len = private_mem->length + public_mem->length + 2;
    if (total_len < sizeof(result)) {
        memcpy(result, private_mem->data, private_mem->length);
        result[private_mem->length] = '|';
        memcpy(result + private_mem->length + 1, public_mem->data, public_mem->length);
        result[total_len - 1] = '\0';
    }
    
    BIO_free(bio_private);
    BIO_free(bio_public);
    EVP_PKEY_free(pkey);
    EVP_PKEY_CTX_free(ctx);
#else
    strcpy(result, "ECC requires OpenSSL");
#endif
    
    return result;
}

// crypto.ECDSASign - Create ECDSA digital signature
char* crypto_ECDSASign(const char* data, const char* privateKeyPEM) {
    static char result[512];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(privateKeyPEM, -1);
    if (!bio) return result;
    
    EVP_PKEY* pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return result;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return result; }
    
    if (EVP_DigestSignInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    if (EVP_DigestSignUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    size_t siglen;
    if (EVP_DigestSignFinal(mdctx, NULL, &siglen) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    unsigned char* sig = (unsigned char*)malloc(siglen);
    if (EVP_DigestSignFinal(mdctx, sig, &siglen) <= 0) {
        free(sig);
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    bytes_to_hex(sig, siglen, result);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
#else
    strcpy(result, "ECDSA requires OpenSSL");
#endif
    
    return result;
}

// crypto.ECDSAVerify - Verify ECDSA digital signature
int crypto_ECDSAVerify(const char* data, const char* signature, const char* publicKeyPEM) {
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(publicKeyPEM, -1);
    if (!bio) return 0;
    
    EVP_PKEY* pkey = PEM_read_bio_PUBKEY(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return 0;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return 0; }
    
    if (EVP_DigestVerifyInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    if (EVP_DigestVerifyUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    // Convert hex signature to bytes
    int sig_len = strlen(signature) / 2;
    unsigned char* sig = (unsigned char*)malloc(sig_len);
    hex_to_bytes(signature, sig, sig_len);
    
    int ret = EVP_DigestVerifyFinal(mdctx, sig, sig_len);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
    
    return (ret == 1) ? 1 : 0;
#else
    return 0;
#endif
}

// crypto.Argon2Hash - Argon2 password hashing (memory-hard)
char* crypto_Argon2Hash(const char* password, const char* salt, int timeCost, int memoryCost, int parallelism) {
    static char result[129];
    result[0] = '\0';
    
    if (timeCost < 1) timeCost = 2;  // Default time cost
    if (memoryCost < 1) memoryCost = 65536;  // Default 64 MB
    if (parallelism < 1) parallelism = 4;  // Default parallelism
    
#ifdef USE_OPENSSL
    // OpenSSL 1.1.1+ has Argon2 support via EVP
    // For older versions, fall back to PBKDF2 with high iterations
    
    // Try Argon2id (most secure variant)
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_SCRYPT, NULL);
    if (ctx) {
        // Use scrypt as approximation (similar memory-hard KDF)
        unsigned char* out = (unsigned char*)malloc(32);
        
        if (EVP_PKEY_derive_init(ctx) > 0) {
            EVP_PKEY_CTX_set1_pbe_pass(ctx, password, strlen(password));
            EVP_PKEY_CTX_set1_scrypt_salt(ctx, (unsigned char*)salt, strlen(salt));
            EVP_PKEY_CTX_set_scrypt_N(ctx, memoryCost);
            EVP_PKEY_CTX_set_scrypt_r(ctx, 8);
            EVP_PKEY_CTX_set_scrypt_p(ctx, parallelism);
            
            size_t outlen = 32;
            if (EVP_PKEY_derive(ctx, out, &outlen) > 0) {
                bytes_to_hex(out, 32, result);
            }
        }
        
        free(out);
        EVP_PKEY_CTX_free(ctx);
        if (result[0] != '\0') return result;
    }
    
    // Fallback to PBKDF2 with high iterations
    int iterations = timeCost * 10000;
    strcpy(result, crypto_PBKDF2(password, salt, iterations, 32, "sha256"));
#else
    // Fallback to PBKDF2
    int iterations = timeCost * 10000;
    strcpy(result, crypto_PBKDF2(password, salt, iterations, 32, "sha256"));
#endif
    
    return result;
}

// crypto.Argon2Verify - Verify Argon2 password hash
int crypto_Argon2Verify(const char* password, const char* hash) {
    
    // Extract salt and parameters from hash (simplified)
    // In production, use proper Argon2 hash format: $argon2id$v=19$m=65536,t=2,p=4$salt$hash
    
    // For now, use PBKDF2 verification as approximation
    // Extract salt (first 16 bytes of hash as hex = 32 chars)
    char salt[33];
    strncpy(salt, hash, 32);
    salt[32] = '\0';
    
    // Recompute hash and compare
    char* computed = crypto_Argon2Hash(password, salt, 2, 65536, 4);
    
    int match = (strcmp(computed, hash) == 0);
    return match ? 1 : 0;
}

// crypto.Ed25519GenerateKeyPair - Generate Ed25519 key pair
char* crypto_Ed25519GenerateKeyPair() {
    static char result[1024];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_ED25519, NULL);
    if (!ctx) return result;
    
    if (EVP_PKEY_keygen_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    EVP_PKEY* pkey = NULL;
    if (EVP_PKEY_keygen(ctx, &pkey) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        return result;
    }
    
    // Export keys to PEM format
    BIO* bio_private = BIO_new(BIO_s_mem());
    BIO* bio_public = BIO_new(BIO_s_mem());
    
    PEM_write_bio_PrivateKey(bio_private, pkey, NULL, NULL, 0, NULL, NULL);
    PEM_write_bio_PUBKEY(bio_public, pkey);
    
    BUF_MEM* private_mem;
    BUF_MEM* public_mem;
    BIO_get_mem_ptr(bio_private, &private_mem);
    BIO_get_mem_ptr(bio_public, &public_mem);
    
    int total_len = private_mem->length + public_mem->length + 2;
    if (total_len < sizeof(result)) {
        memcpy(result, private_mem->data, private_mem->length);
        result[private_mem->length] = '|';
        memcpy(result + private_mem->length + 1, public_mem->data, public_mem->length);
        result[total_len - 1] = '\0';
    }
    
    BIO_free(bio_private);
    BIO_free(bio_public);
    EVP_PKEY_free(pkey);
    EVP_PKEY_CTX_free(ctx);
#else
    strcpy(result, "Ed25519 requires OpenSSL 1.1.1+");
#endif
    
    return result;
}

// crypto.Ed25519Sign - Create Ed25519 digital signature
char* crypto_Ed25519Sign(const char* data, const char* privateKeyPEM) {
    static char result[256];
    result[0] = '\0';
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(privateKeyPEM, -1);
    if (!bio) return result;
    
    EVP_PKEY* pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return result;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return result; }
    
    if (EVP_DigestSignInit(mdctx, NULL, NULL, NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    if (EVP_DigestSignUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    size_t siglen;
    if (EVP_DigestSignFinal(mdctx, NULL, &siglen) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    unsigned char* sig = (unsigned char*)malloc(siglen);
    if (EVP_DigestSignFinal(mdctx, sig, &siglen) <= 0) {
        free(sig);
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return result;
    }
    
    bytes_to_hex(sig, siglen, result);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
#else
    strcpy(result, "Ed25519 requires OpenSSL 1.1.1+");
#endif
    
    return result;
}

// crypto.Ed25519Verify - Verify Ed25519 digital signature
int crypto_Ed25519Verify(const char* data, const char* signature, const char* publicKeyPEM) {
    
#ifdef USE_OPENSSL
    BIO* bio = BIO_new_mem_buf(publicKeyPEM, -1);
    if (!bio) return 0;
    
    EVP_PKEY* pkey = PEM_read_bio_PUBKEY(bio, NULL, NULL, NULL);
    BIO_free(bio);
    if (!pkey) return 0;
    
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return 0; }
    
    if (EVP_DigestVerifyInit(mdctx, NULL, NULL, NULL, pkey) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    if (EVP_DigestVerifyUpdate(mdctx, data, strlen(data)) <= 0) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pkey);
        return 0;
    }
    
    // Convert hex signature to bytes
    int sig_len = strlen(signature) / 2;
    unsigned char* sig = (unsigned char*)malloc(sig_len);
    hex_to_bytes(signature, sig, sig_len);
    
    int ret = EVP_DigestVerifyFinal(mdctx, sig, sig_len);
    
    free(sig);
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
    
    return (ret == 1) ? 1 : 0;
#else
    return 0;
#endif
}

// crypto.BcryptHash - bcrypt password hashing
char* crypto_BcryptHash(const char* password, int cost) {
    static char result[61];  // bcrypt hash is 60 chars
    result[0] = '\0';
    
    if (cost < 4) cost = 10;  // Default cost factor
    if (cost > 31) cost = 31;  // Max cost factor
    
#ifdef USE_OPENSSL
    // OpenSSL 1.1.0+ has bcrypt support via EVP
    // Generate random salt
    unsigned char salt[16];
    RAND_bytes(salt, 16);
    
    // Use EVP_PBE_scrypt as approximation (bcrypt not directly available in all OpenSSL versions)
    // For true bcrypt, would need libbcrypt or OpenSSL with bcrypt support
    unsigned char* out = (unsigned char*)malloc(24);  // bcrypt output size
    
    // Use PBKDF2 with Blowfish-like parameters as approximation
    // Note: True bcrypt requires libbcrypt library
    int iterations = 1 << cost;  // 2^cost iterations
    
    // Format as bcrypt-like hash: $2a$cost$salt+hash
    char salt_b64[23];
    // Simplified bcrypt format (for compatibility, use proper bcrypt library in production)
    snprintf(result, sizeof(result), "$2a$%02d$", cost);
    
    // Use PBKDF2 as approximation
    char* pbkdf2_hash = crypto_PBKDF2(password, (char*)salt, iterations, 24, "sha256");
    
    // Encode salt and hash (simplified)
    strcat(result, base64_encode_simple(salt, 16));
    strcat(result, base64_encode_simple((unsigned char*)pbkdf2_hash, 24));
    
    free(out);
#else
    // Fallback: Use PBKDF2 with bcrypt-like cost
    unsigned char salt[16];
    for (int i = 0; i < 16; i++) salt[i] = (unsigned char)(rand() % 256);
    int iterations = 1 << cost;
    strcpy(result, crypto_PBKDF2(password, (char*)salt, iterations, 24, "sha256"));
#endif
    
    return result;
}

// crypto.BcryptVerify - Verify bcrypt password hash
int crypto_BcryptVerify(const char* password, const char* hash) {
    
    // Parse bcrypt hash format: $2a$cost$salt+hash
    if (strncmp(hash, "$2a$", 5) != 0 && strncmp(hash, "$2b$", 5) != 0 && strncmp(hash, "$2y$", 5) != 0) {
        // Not a bcrypt hash, try direct comparison
        char* computed = crypto_BcryptHash(password, 10);
        int match = (strcmp(computed, hash) == 0);
        return match ? 1 : 0;
    }
    
    // Extract cost from hash
    int cost = 10;
    if (strlen(hash) > 7) {
        cost = (hash[4] - '0') * 10 + (hash[5] - '0');
    }
    
    // Recompute hash with same cost
    char* computed = crypto_BcryptHash(password, cost);
    
    // Compare (simplified - proper bcrypt would parse salt and hash separately)
    int match = (strcmp(computed, hash) == 0);
    return match ? 1 : 0;
}

// crypto.Scrypt - scrypt memory-hard key derivation
char* crypto_Scrypt(const char* password, const char* salt, int N, int r, int p, int keyLength) {
    static char result[129];
    result[0] = '\0';
    
    if (keyLength < 1 || keyLength > 64) keyLength = 32;  // Default 32 bytes
    if (N < 1) N = 16384;  // Default N (CPU/memory cost)
    if (r < 1) r = 8;  // Default r (block size)
    if (p < 1) p = 1;  // Default p (parallelism)
    
#ifdef USE_OPENSSL
    // OpenSSL 1.1.0+ has scrypt support via EVP_PKEY_SCRYPT
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_SCRYPT, NULL);
    if (!ctx) {
        // Fallback to PBKDF2
        int iterations = N * r * p;
        strcpy(result, crypto_PBKDF2(password, salt, iterations, keyLength, "sha256"));
        return result;
    }
    
    if (EVP_PKEY_derive_init(ctx) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        int iterations = N * r * p;
        strcpy(result, crypto_PBKDF2(password, salt, iterations, keyLength, "sha256"));
        return result;
    }
    
    EVP_PKEY_CTX_set1_pbe_pass(ctx, password, strlen(password));
    EVP_PKEY_CTX_set1_scrypt_salt(ctx, (unsigned char*)salt, strlen(salt));
    EVP_PKEY_CTX_set_scrypt_N(ctx, N);
    EVP_PKEY_CTX_set_scrypt_r(ctx, r);
    EVP_PKEY_CTX_set_scrypt_p(ctx, p);
    
    unsigned char* out = (unsigned char*)malloc(keyLength);
    size_t outlen = keyLength;
    
    if (EVP_PKEY_derive(ctx, out, &outlen) > 0) {
        bytes_to_hex(out, keyLength, result);
    } else {
        // Fallback to PBKDF2
        int iterations = N * r * p;
        strcpy(result, crypto_PBKDF2(password, salt, iterations, keyLength, "sha256"));
    }
    
    free(out);
    EVP_PKEY_CTX_free(ctx);
#else
    // Fallback to PBKDF2 with scrypt-like iterations
    int iterations = N * r * p;
    strcpy(result, crypto_PBKDF2(password, salt, iterations, keyLength, "sha256"));
#endif
    
    return result;
}


// ========== encoding/hex library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int hex_char_to_value(char c) {
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

// hex.Encode - Encode string to hex
char* hex_Encode(const char* data) {
    static char result[8192];  // 4KB input max
    result[0] = '\0';
    
    int len = strlen(data);
    if (len * 2 >= sizeof(result)) {
        len = (sizeof(result) - 1) / 2;
    }
    
    const char* hex_chars = "0123456789abcdef";
    for (int i = 0; i < len; i++) {
        unsigned char byte = (unsigned char)data[i];
        result[i * 2] = hex_chars[(byte >> 4) & 0x0F];
        result[i * 2 + 1] = hex_chars[byte & 0x0F];
    }
    result[len * 2] = '\0';
    
    return result;
}

// hex.Decode - Decode hex string
char* hex_Decode(const char* encoded) {
    static char result[4096];  // 2KB hex input max
    result[0] = '\0';
    
    int len = strlen(encoded);
    if (len % 2 != 0) {
        return result;  // Invalid hex string
    }
    
    int result_len = len / 2;
    if (result_len >= sizeof(result)) {
        result_len = sizeof(result) - 1;
        len = result_len * 2;
    }
    
    for (int i = 0; i < len; i += 2) {
        int high = hex_char_to_value(encoded[i]);
        int low = hex_char_to_value(encoded[i + 1]);
        
        if (high < 0 || low < 0) {
            return result;  // Invalid hex character
        }
        
        result[i / 2] = (char)((high << 4) | low);
    }
    result[result_len] = '\0';
    
    return result;
}

// hex.EncodeBytes - Encode byte data (same as Encode)
char* hex_EncodeBytes(const char* data, int length) {
    static char result[8192];
    result[0] = '\0';
    
    if (length < 0) length = strlen(data);
    if (length * 2 >= sizeof(result)) {
        length = (sizeof(result) - 1) / 2;
    }
    
    const char* hex_chars = "0123456789abcdef";
    for (int i = 0; i < length; i++) {
        unsigned char byte = (unsigned char)data[i];
        result[i * 2] = hex_chars[(byte >> 4) & 0x0F];
        result[i * 2 + 1] = hex_chars[byte & 0x0F];
    }
    result[length * 2] = '\0';
    
    return result;
}

// hex.DecodeBytes - Decode hex to bytes (same as Decode)
char* hex_DecodeBytes(const char* encoded) {
    return hex_Decode(encoded);
}


// ========== url library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static int needs_encoding(char c, int is_path) {
    if (isalnum(c)) return 0;
    if (is_path) {
        // Path-safe characters
        return !(c == '/' || c == '.' || c == '-' || c == '_' || c == '~');
    } else {
        // Query-safe characters
        return !(c == '-' || c == '_' || c == '.' || c == '~');
    }
}

static void percent_encode_char(char c, char* output) {
    sprintf(output, "%%%02X", (unsigned char)c);
}

// url.QueryEscape - Escape query string
char* url_QueryEscape(const char* s) {
    static char result[4096];
    result[0] = '\0';
    
    int len = strlen(s);
    int pos = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 4; i++) {
        if (needs_encoding(s[i], 0)) {
            char encoded[4];
            percent_encode_char(s[i], encoded);
            strcat(result, encoded);
            pos += 3;
        } else {
            result[pos++] = s[i];
            result[pos] = '\0';
        }
    }
    
    return result;
}

// url.QueryUnescape - Unescape query string
char* url_QueryUnescape(const char* s) {
    static char result[4096];
    result[0] = '\0';
    
    int len = strlen(s);
    int pos = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {
        if (s[i] == '%' && i + 2 < len) {
            char hex[3] = {s[i+1], s[i+2], '\0'};
            int value = strtol(hex, NULL, 16);
            result[pos++] = (char)value;
            i += 2;  // Skip %XX
        } else {
            result[pos++] = s[i];
        }
    }
    result[pos] = '\0';
    
    return result;
}

// url.PathEscape - Escape URL path
char* url_PathEscape(const char* s) {
    static char result[4096];
    result[0] = '\0';
    
    int len = strlen(s);
    int pos = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 4; i++) {
        if (needs_encoding(s[i], 1)) {
            char encoded[4];
            percent_encode_char(s[i], encoded);
            strcat(result, encoded);
            pos += 3;
        } else {
            result[pos++] = s[i];
            result[pos] = '\0';
        }
    }
    
    return result;
}

// url.PathUnescape - Unescape URL path
char* url_PathUnescape(const char* s) {
    return url_QueryUnescape(s);  // Same logic
}

// url.Parse - Parse URL into components
char* url_Parse(const char* rawurl) {
    static char result[512];
    result[0] = '\0';
    
    char scheme[64] = "";
    char host[256] = "";
    char path[256] = "";
    char query[256] = "";
    
    // Find scheme (http://, https://, etc.)
    const char* scheme_end = strstr(rawurl, "://");
    if (scheme_end != NULL) {
        int scheme_len = scheme_end - rawurl;
        if (scheme_len < sizeof(scheme)) {
            strncpy(scheme, rawurl, scheme_len);
            scheme[scheme_len] = '\0';
            rawurl = scheme_end + 3;  // Skip ://
        }
    }
    
    // Find path start
    const char* path_start = strchr(rawurl, '/');
    const char* query_start = strchr(rawurl, '?');
    
    // Extract host
    if (path_start != NULL) {
        int host_len = path_start - rawurl;
        if (host_len < sizeof(host)) {
            strncpy(host, rawurl, host_len);
            host[host_len] = '\0';
        }
    } else if (query_start != NULL) {
        int host_len = query_start - rawurl;
        if (host_len < sizeof(host)) {
            strncpy(host, rawurl, host_len);
            host[host_len] = '\0';
        }
    } else {
        strncpy(host, rawurl, sizeof(host) - 1);
        host[sizeof(host) - 1] = '\0';
    }
    
    // Extract path
    if (path_start != NULL) {
        if (query_start != NULL) {
            int path_len = query_start - path_start;
            if (path_len < sizeof(path)) {
                strncpy(path, path_start, path_len);
                path[path_len] = '\0';
            }
        } else {
            strncpy(path, path_start, sizeof(path) - 1);
            path[sizeof(path) - 1] = '\0';
        }
    }
    
    // Extract query
    if (query_start != NULL) {
        strncpy(query, query_start + 1, sizeof(query) - 1);  // Skip ?
        query[sizeof(query) - 1] = '\0';
    }
    
    // Format result: scheme|host|path|query
    snprintf(result, sizeof(result), "%s|%s|%s|%s", scheme, host, path, query);
    
    return result;
}

// url.JoinPath - Join URL path components
char* url_JoinPath(const char* base, const char* path) {
    static char result[512];
    result[0] = '\0';
    
    // Remove trailing slash from base
    int base_len = strlen(base);
    while (base_len > 0 && base[base_len - 1] == '/') {
        base_len--;
    }
    
    // Remove leading slash from path
    const char* path_start = path;
    while (*path_start == '/') {
        path_start++;
    }
    
    // Join with single slash
    if (base_len > 0) {
        strncpy(result, base, base_len);
        result[base_len] = '\0';
        if (*path_start) {
            strcat(result, "/");
            strcat(result, path_start);
        }
    } else {
        strcpy(result, path_start);
    }
    
    return result;
}


// ========== unicode library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// unicode.IsLetter - Check if character is a letter
int unicode_IsLetter(int r) {
    return isalpha((char)r) ? 1 : 0;
}

// unicode.IsDigit - Check if character is a digit
int unicode_IsDigit(int r) {
    return isdigit((char)r) ? 1 : 0;
}

// unicode.IsSpace - Check if character is whitespace
int unicode_IsSpace(int r) {
    return isspace((char)r) ? 1 : 0;
}

// unicode.ToUpper - Convert to uppercase
int unicode_ToUpper(int r) {
    return toupper((char)r);
}

// unicode.ToLower - Convert to lowercase
int unicode_ToLower(int r) {
    return tolower((char)r);
}

// unicode.IsUpper - Check if uppercase
int unicode_IsUpper(int r) {
    return isupper((char)r) ? 1 : 0;
}

// unicode.IsLower - Check if lowercase
int unicode_IsLower(int r) {
    return islower((char)r) ? 1 : 0;
}


// ========== encoding/csv library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void parse_csv_line(const char* line, char result[][256], int* count) {
    *count = 0;
    int len = strlen(line);
    int pos = 0;
    int field_start = 0;
    int in_quotes = 0;
    
    for (int i = 0; i < len && *count < 100; i++) {
        if (line[i] == '"') {
            in_quotes = !in_quotes;
        } else if (line[i] == ',' && !in_quotes) {
            // End of field
            int field_len = i - field_start;
            if (field_len > 255) field_len = 255;
            strncpy(result[*count], line + field_start, field_len);
            result[*count][field_len] = '\0';
            // Remove quotes if present
            if (result[*count][0] == '"' && result[*count][field_len-1] == '"') {
                memmove(result[*count], result[*count] + 1, field_len - 2);
                result[*count][field_len - 2] = '\0';
            }
            (*count)++;
            field_start = i + 1;
        }
    }
    
    // Last field
    if (field_start < len) {
        int field_len = len - field_start;
        if (field_len > 255) field_len = 255;
        strncpy(result[*count], line + field_start, field_len);
        result[*count][field_len] = '\0';
        // Remove quotes if present
        int flen = strlen(result[*count]);
        if (flen > 0 && result[*count][0] == '"' && result[*count][flen-1] == '"') {
            memmove(result[*count], result[*count] + 1, flen - 2);
            result[*count][flen - 2] = '\0';
        }
        (*count)++;
    }
}

// csv.Read - Read CSV file
char* csv_Read(const char* filename) {
    static char result[65536];  // 64KB buffer
    result[0] = '\0';
    
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        return result;
    }
    
    char line[1024];
    int first_line = 1;
    
    while (fgets(line, sizeof(line), file) != NULL) {
        // Remove newline
        int len = strlen(line);
        if (len > 0 && line[len-1] == '\n') {
            line[len-1] = '\0';
        }
        
        if (!first_line) {
            strcat(result, "\n");
        }
        first_line = 0;
        
        // Parse line and join fields with |
        char fields[100][256];
        int field_count = 0;
        parse_csv_line(line, fields, &field_count);
        
        for (int i = 0; i < field_count; i++) {
            if (i > 0) strcat(result, "|");
            strcat(result, fields[i]);
        }
    }
    
    fclose(file);
    return result;
}

// csv.Write - Write CSV file
int csv_Write(const char* filename, const char* data) {
    FILE* file = fopen(filename, "w");
    if (file == NULL) {
        return 0;
    }
    
    // Data format: newline-separated records, | separated fields
    int len = strlen(data);
    int written = 0;
    
    for (int i = 0; i < len; i++) {
        if (data[i] == '|') {
            fputc(',', file);
            written++;
        } else if (data[i] == '\n') {
            fputc('\n', file);
            written++;
        } else {
            fputc(data[i], file);
            written++;
        }
    }
    
    fclose(file);
    return written;
}

// csv.ParseLine - Parse single CSV line (returns | separated fields)
char* csv_ParseLine(const char* line) {
    static char result[2048];
    result[0] = '\0';
    
    char fields[100][256];
    int field_count = 0;
    parse_csv_line(line, fields, &field_count);
    
    for (int i = 0; i < field_count; i++) {
        if (i > 0) strcat(result, "|");
        strcat(result, fields[i]);
    }
    
    return result;
}


// ========== encoding/xml library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// xml.Escape - Escape XML special characters
char* xml_Escape(const char* text) {
    static char result[8192];
    result[0] = '\0';
    
    int len = strlen(text);
    int pos = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 10; i++) {
        switch (text[i]) {
            case '<':
                strcat(result, "&lt;");
                pos += 4;
                break;
            case '>':
                strcat(result, "&gt;");
                pos += 4;
                break;
            case '&':
                strcat(result, "&amp;");
                pos += 5;
                break;
            case '"':
                strcat(result, "&quot;");
                pos += 6;
                break;
            case '\'':
                strcat(result, "&apos;");
                pos += 6;
                break;
            default:
                result[pos++] = text[i];
                result[pos] = '\0';
                break;
        }
    }
    
    return result;
}

// xml.Unescape - Unescape XML entities
char* xml_Unescape(const char* text) {
    static char result[8192];
    result[0] = '\0';
    
    int len = strlen(text);
    int pos = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {
        if (text[i] == '&') {
            if (strncmp(text + i, "&lt;", 4) == 0) {
                result[pos++] = '<';
                i += 3;  // Skip &lt;
            } else if (strncmp(text + i, "&gt;", 4) == 0) {
                result[pos++] = '>';
                i += 3;  // Skip &gt;
            } else if (strncmp(text + i, "&amp;", 5) == 0) {
                result[pos++] = '&';
                i += 4;  // Skip &amp;
            } else if (strncmp(text + i, "&quot;", 6) == 0) {
                result[pos++] = '"';
                i += 5;  // Skip &quot;
            } else if (strncmp(text + i, "&apos;", 6) == 0) {
                result[pos++] = '\'';
                i += 5;  // Skip &apos;
            } else {
                result[pos++] = text[i];
            }
        } else {
            result[pos++] = text[i];
        }
    }
    result[pos] = '\0';
    
    return result;
}

// xml.Marshal - Encode value to XML (basic types)
char* xml_Marshal(const char* type, const char* name, const char* value) {
    static char result[1024];
    result[0] = '\0';
    
    char* escaped = xml_Escape(value);
    
    if (strcmp(type, "string") == 0) {
        snprintf(result, sizeof(result), "<%s>%s</%s>", name, escaped, name);
    } else if (strcmp(type, "int") == 0) {
        snprintf(result, sizeof(result), "<%s>%s</%s>", name, value, name);
    } else if (strcmp(type, "float") == 0) {
        snprintf(result, sizeof(result), "<%s>%s</%s>", name, value, name);
    } else {
        snprintf(result, sizeof(result), "<%s>%s</%s>", name, escaped, name);
    }
    
    return result;
}

// xml.Unmarshal - Decode XML string (basic types)
char* xml_Unmarshal(const char* xml, const char* tag) {
    static char result[512];
    result[0] = '\0';
    
    char start_tag[128];
    snprintf(start_tag, sizeof(start_tag), "<%s>", tag);
    char end_tag[128];
    snprintf(end_tag, sizeof(end_tag), "</%s>", tag);
    
    const char* start = strstr(xml, start_tag);
    if (start == NULL) return result;
    
    start += strlen(start_tag);
    const char* end = strstr(start, end_tag);
    if (end == NULL) return result;
    
    int len = end - start;
    if (len >= sizeof(result)) len = sizeof(result) - 1;
    
    strncpy(result, start, len);
    result[len] = '\0';
    
    // Unescape
    char* unescaped = xml_Unescape(result);
    strcpy(result, unescaped);
    
    return result;
}


// ========== net/url library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// neturl.Parse - Parse network URL
char* neturl_Parse(const char* rawurl) {
    static char result[512];
    result[0] = '\0';
    
    char scheme[64] = "";
    char user[128] = "";
    char host[256] = "";
    char port[16] = "";
    char path[256] = "";
    
    // Find scheme
    const char* scheme_end = strstr(rawurl, "://");
    if (scheme_end != NULL) {
        int scheme_len = scheme_end - rawurl;
        if (scheme_len < sizeof(scheme)) {
            strncpy(scheme, rawurl, scheme_len);
            scheme[scheme_len] = '\0';
            rawurl = scheme_end + 3;
        }
    }
    
    // Find user info
    const char* at_pos = strchr(rawurl, '@');
    const char* host_start = rawurl;
    if (at_pos != NULL) {
        int user_len = at_pos - rawurl;
        if (user_len < sizeof(user)) {
            strncpy(user, rawurl, user_len);
            user[user_len] = '\0';
            host_start = at_pos + 1;
        }
    }
    
    // Find path start
    const char* path_start = strchr(host_start, '/');
    const char* colon_pos = strchr(host_start, ':');
    
    // Extract host and port
    const char* port_start = NULL;
    if (colon_pos != NULL && (path_start == NULL || colon_pos < path_start)) {
        // Has port
        int host_len = colon_pos - host_start;
        if (host_len < sizeof(host)) {
            strncpy(host, host_start, host_len);
            host[host_len] = '\0';
        }
        port_start = colon_pos + 1;
        if (path_start != NULL) {
            int port_len = path_start - port_start;
            if (port_len < sizeof(port)) {
                strncpy(port, port_start, port_len);
                port[port_len] = '\0';
            }
        } else {
            strncpy(port, port_start, sizeof(port) - 1);
            port[sizeof(port) - 1] = '\0';
        }
    } else {
        // No port
        if (path_start != NULL) {
            int host_len = path_start - host_start;
            if (host_len < sizeof(host)) {
                strncpy(host, host_start, host_len);
                host[host_len] = '\0';
            }
        } else {
            strncpy(host, host_start, sizeof(host) - 1);
            host[sizeof(host) - 1] = '\0';
        }
    }
    
    // Extract path
    if (path_start != NULL) {
        strncpy(path, path_start, sizeof(path) - 1);
        path[sizeof(path) - 1] = '\0';
    }
    
    // Format: scheme|user|host|port|path
    snprintf(result, sizeof(result), "%s|%s|%s|%s|%s", scheme, user, host, port, path);
    
    return result;
}

// neturl.User - Create user info string
char* neturl_User(const char* username, const char* password) {
    static char result[256];
    if (password != NULL && strlen(password) > 0) {
        snprintf(result, sizeof(result), "%s:%s", username, password);
    } else {
        strncpy(result, username, sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    return result;
}

// neturl.Hostname - Extract hostname from URL
char* neturl_Hostname(const char* url) {
    static char result[256];
    result[0] = '\0';
    
    char* parsed = neturl_Parse(url);
    // Format: scheme|user|host|port|path
    // Extract host (3rd field)
    
    char* fields[5];
    int field_count = 0;
    char* copy = strdup(parsed);
    char* token = strtok(copy, "|");
    
    while (token != NULL && field_count < 5) {
        fields[field_count++] = token;
        token = strtok(NULL, "|");
    }
    
    if (field_count >= 3) {
        strncpy(result, fields[2], sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    
    free(copy);
    return result;
}

// neturl.Port - Extract port from URL
char* neturl_Port(const char* url) {
    static char result[16];
    result[0] = '\0';
    
    char* parsed = neturl_Parse(url);
    // Format: scheme|user|host|port|path
    // Extract port (4th field)
    
    char* fields[5];
    int field_count = 0;
    char* copy = strdup(parsed);
    char* token = strtok(copy, "|");
    
    while (token != NULL && field_count < 5) {
        fields[field_count++] = token;
        token = strtok(NULL, "|");
    }
    
    if (field_count >= 4 && strlen(fields[3]) > 0) {
        strncpy(result, fields[3], sizeof(result) - 1);
        result[sizeof(result) - 1] = '\0';
    }
    
    free(copy);
    return result;
}


// ========== bufio library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFIO_BUFFER_SIZE 4096

typedef struct {
    FILE* file;
    char buffer[BUFIO_BUFFER_SIZE];
    int pos;
    int size;
    int is_writer;
} BufIO;

static BufIO buffers[16];
static int buffer_count = 0;

static int find_or_create_buffer(const char* source, int is_writer) {
    // Find existing buffer
    for (int i = 0; i < buffer_count; i++) {
        if (buffers[i].file != NULL) {
            // Check if same file (simplified)
            return i;
        }
    }
    
    // Create new buffer
    if (buffer_count >= 16) return -1;
    
    FILE* file = fopen(source, is_writer ? "w" : "r");
    if (file == NULL) return -1;
    
    buffers[buffer_count].file = file;
    buffers[buffer_count].pos = 0;
    buffers[buffer_count].size = 0;
    buffers[buffer_count].is_writer = is_writer;
    
    return buffer_count++;
}

// bufio.NewReader - Create buffered reader
int bufio_NewReader(const char* source) {
    return find_or_create_buffer(source, 0);
}

// bufio.ReadLine - Read line
char* bufio_ReadLine(int reader) {
    static char result[1024];
    result[0] = '\0';
    
    if (reader < 0 || reader >= buffer_count) return result;
    if (buffers[reader].file == NULL) return result;
    
    if (fgets(result, sizeof(result), buffers[reader].file) == NULL) {
        result[0] = '\0';
        return result;
    }
    
    // Remove newline
    int len = strlen(result);
    if (len > 0 && result[len-1] == '\n') {
        result[len-1] = '\0';
    }
    
    return result;
}

// bufio.ReadBytes - Read until delimiter
char* bufio_ReadBytes(int reader, int delim) {
    static char result[1024];
    result[0] = '\0';
    
    if (reader < 0 || reader >= buffer_count) return result;
    if (buffers[reader].file == NULL) return result;
    
    int pos = 0;
    int ch;
    
    while ((ch = fgetc(buffers[reader].file)) != EOF && pos < sizeof(result) - 1) {
        if (ch == delim) {
            break;
        }
        result[pos++] = (char)ch;
    }
    result[pos] = '\0';
    
    return result;
}

// bufio.NewWriter - Create buffered writer
int bufio_NewWriter(const char* dest) {
    return find_or_create_buffer(dest, 1);
}

// bufio.Write - Write data
int bufio_Write(int writer, const char* data) {
    if (writer < 0 || writer >= buffer_count) return 0;
    if (buffers[writer].file == NULL) return 0;
    if (!buffers[writer].is_writer) return 0;
    
    int len = strlen(data);
    int written = fwrite(data, 1, len, buffers[writer].file);
    return written;
}

// bufio.Flush - Flush buffer
void bufio_Flush(int writer) {
    if (writer < 0 || writer >= buffer_count) return;
    if (buffers[writer].file == NULL) return;
    if (!buffers[writer].is_writer) return;
    
    fflush(buffers[writer].file);
}

// bufio.Close - Close reader/writer
void bufio_Close(int handle) {
    if (handle < 0 || handle >= buffer_count) return;
    if (buffers[handle].file == NULL) return;
    
    if (buffers[handle].is_writer) {
        fflush(buffers[handle].file);
    }
    fclose(buffers[handle].file);
    buffers[handle].file = NULL;
}


// ========== testing/benchmark library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Benchmark context structure
typedef struct {
    char name[256];
    clock_t start_time;
    clock_t end_time;
    int running;
} BenchmarkContext;

#define MAX_BENCHMARKS 100
static BenchmarkContext benchmarks[MAX_BENCHMARKS];
static int benchmark_count = 0;

static int find_or_create_benchmark(const char* name) {
    // Find existing benchmark
    for (int i = 0; i < benchmark_count; i++) {
        if (strcmp(benchmarks[i].name, name) == 0) {
            return i;
        }
    }
    
    // Create new benchmark
    if (benchmark_count >= MAX_BENCHMARKS) return -1;
    
    int idx = benchmark_count++;
    strncpy(benchmarks[idx].name, name, sizeof(benchmarks[idx].name) - 1);
    benchmarks[idx].name[sizeof(benchmarks[idx].name) - 1] = '\0';
    benchmarks[idx].running = 0;
    
    return idx;
}

// benchmark.Start - Start benchmark
void benchmark_Start(const char* name) {
    int idx = find_or_create_benchmark(name);
    if (idx < 0) return;
    
    benchmarks[idx].start_time = clock();
    benchmarks[idx].running = 1;
    benchmarks[idx].end_time = 0;
}

// benchmark.Stop - Stop benchmark and return duration in seconds
double benchmark_Stop(const char* name) {
    int idx = find_or_create_benchmark(name);
    if (idx < 0) return -1.0;
    
    if (!benchmarks[idx].running) return -1.0;
    
    benchmarks[idx].end_time = clock();
    benchmarks[idx].running = 0;
    
    double duration = ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;
    
    return duration;
}

// benchmark.Report - Report benchmark results
void benchmark_Report(const char* name) {
    int idx = find_or_create_benchmark(name);
    if (idx < 0) return;
    
    if (benchmarks[idx].running) {
        printf("BENCHMARK %s: still running\n", name);
        return;
    }
    
    if (benchmarks[idx].end_time == 0) {
        printf("BENCHMARK %s: not started\n", name);
        return;
    }
    
    double duration = ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;
    printf("BENCHMARK %s: %.6f seconds\n", name, duration);
}

// benchmark.Reset - Reset benchmark
void benchmark_Reset(const char* name) {
    int idx = find_or_create_benchmark(name);
    if (idx < 0) return;
    
    benchmarks[idx].running = 0;
    benchmarks[idx].start_time = 0;
    benchmarks[idx].end_time = 0;
}

// benchmark.GetDuration - Get current duration without stopping
double benchmark_GetDuration(const char* name) {
    int idx = find_or_create_benchmark(name);
    if (idx < 0) return -1.0;
    
    if (!benchmarks[idx].running) {
        if (benchmarks[idx].end_time > 0) {
            return ((double)(benchmarks[idx].end_time - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;
        }
        return -1.0;
    }
    
    clock_t current = clock();
    return ((double)(current - benchmarks[idx].start_time)) / CLOCKS_PER_SEC;
}


// ========== doc library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// doc.ExtractComments - Extract comments from source code
char* doc_ExtractComments(const char* source) {
    static char result[8192];
    result[0] = '\0';
    
    int len = strlen(source);
    int pos = 0;
    int in_single_line = 0;
    int in_multi_line = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {
        // Check for single-line comment //
        if (i < len - 1 && source[i] == '/' && source[i + 1] == '/') {
            in_single_line = 1;
            i++; // Skip second /
            continue;
        }
        
        // Check for multi-line comment start /*
        if (i < len - 1 && source[i] == '/' && source[i + 1] == '*') {
            in_multi_line = 1;
            i++; // Skip *
            continue;
        }
        
        // Check for multi-line comment end */
        if (i < len - 1 && source[i] == '*' && source[i + 1] == '/') {
            in_multi_line = 0;
            i++; // Skip /
            if (pos > 0 && result[pos - 1] != '\n') {
                result[pos++] = '\n';
            }
            continue;
        }
        
        // Extract comment content
        if (in_single_line || in_multi_line) {
            if (source[i] == '\n') {
                in_single_line = 0;
                result[pos++] = '\n';
            } else if (source[i] != '\r') {
                result[pos++] = source[i];
            }
        }
    }
    
    result[pos] = '\0';
    return result;
}

// doc.Format - Format documentation text (basic formatting)
char* doc_Format(const char* text) {
    static char result[8192];
    result[0] = '\0';
    
    int len = strlen(text);
    int pos = 0;
    int in_code = 0;
    
    for (int i = 0; i < len && pos < sizeof(result) - 1; i++) {
        // Simple formatting: preserve newlines, trim extra spaces
        if (text[i] == '\n') {
            result[pos++] = '\n';
            // Skip multiple spaces after newline
            while (i + 1 < len && text[i + 1] == ' ') i++;
        } else if (text[i] != '\r') {
            result[pos++] = text[i];
        }
    }
    
    result[pos] = '\0';
    return result;
}

// doc.Generate - Generate documentation from source file
char* doc_Generate(const char* filename) {
    static char result[16384];
    result[0] = '\0';
    
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        strcpy(result, "Error: Could not open file\n");
        return result;
    }
    
    // Read file into buffer
    char source[8192];
    size_t read = fread(source, 1, sizeof(source) - 1, file);
    source[read] = '\0';
    fclose(file);
    
    // Extract comments
    char* comments = doc_ExtractComments(source);
    
    // Format and add header
    strcat(result, "# Documentation\n\n");
    strcat(result, "Generated from: ");
    strcat(result, filename);
    strcat(result, "\n\n");
    strcat(result, comments);
    
    return result;
}

// doc.Write - Write documentation to file
int doc_Write(const char* filename, const char* content) {
    FILE* file = fopen(filename, "w");
    if (file == NULL) {
        return 0;
    }
    
    int len = strlen(content);
    int written = fwrite(content, 1, len, file);
    fclose(file);
    
    return written;
}

// doc.ParseFunctionDocs - Parse function documentation from comments
char* doc_ParseFunctionDocs(const char* source, const char* func_name) {
    static char result[2048];
    result[0] = '\0';
    
    // Simple implementation: find function and extract preceding comment
    char search[256];
    snprintf(search, sizeof(search), "#%s", func_name);
    
    const char* func_pos = strstr(source, search);
    if (func_pos == NULL) return result;
    
    // Look backwards for comment
    const char* comment_start = func_pos;
    int found_comment = 0;
    
    // Simple backward search for // or /*
    for (const char* p = func_pos - 1; p >= source && p >= func_pos - 500; p--) {
        if (p[0] == '/' && p[1] == '/') {
            comment_start = p + 2;
            found_comment = 1;
            break;
        }
        if (p[0] == '*' && p[-1] == '/') {
            comment_start = p + 1;
            found_comment = 1;
            break;
        }
    }
    
    if (!found_comment) return result;
    
    // Extract comment until function
    int len = func_pos - comment_start;
    if (len > sizeof(result) - 1) len = sizeof(result) - 1;
    strncpy(result, comment_start, len);
    result[len] = '\0';
    
    return result;
}


// ========== reflect library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Type information structure
typedef struct {
    char name[64];
    int kind;  // 0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer
    int size;  // Size in bytes
} TypeInfo;

// Value information structure
typedef struct {
    TypeInfo* type;
    void* value;
    char string_repr[256];
} ValueInfo;

#define MAX_TYPES 100
static TypeInfo type_registry[MAX_TYPES];
static int type_count = 0;

static TypeInfo* register_type(const char* name, int kind, int size) {
    if (type_count >= MAX_TYPES) return NULL;
    
    TypeInfo* t = &type_registry[type_count++];
    strncpy(t->name, name, sizeof(t->name) - 1);
    t->name[sizeof(t->name) - 1] = '\0';
    t->kind = kind;
    t->size = size;
    
    return t;
}

static void init_type_registry() {
    static int initialized = 0;
    if (initialized) return;
    initialized = 1;
    
    register_type("int", 0, sizeof(int));
    register_type("float", 1, sizeof(double));
    register_type("string", 2, sizeof(char*));
    register_type("bool", 3, sizeof(int));
    register_type("error", 4, sizeof(char*));
    register_type("pointer", 5, sizeof(void*));
}

// reflect.TypeOf - Get type information
char* reflect_TypeOf(const char* type_name) {
    static char result[128];
    result[0] = '\0';
    
    init_type_registry();
    
    // Find type in registry
    for (int i = 0; i < type_count; i++) {
        if (strcmp(type_registry[i].name, type_name) == 0) {
            snprintf(result, sizeof(result), "%s|%d|%d", 
                     type_registry[i].name, 
                     type_registry[i].kind, 
                     type_registry[i].size);
            return result;
        }
    }
    
    // Return unknown type
    snprintf(result, sizeof(result), "unknown|0|0");
    return result;
}

// reflect.TypeOfInt - Get type info for int value
char* reflect_TypeOfInt(int value) {
    return reflect_TypeOf("int");
}

// reflect.TypeOfFloat - Get type info for float value
char* reflect_TypeOfFloat(double value) {
    return reflect_TypeOf("float");
}

// reflect.TypeOfString - Get type info for string value
char* reflect_TypeOfString(const char* value) {
    return reflect_TypeOf("string");
}

// reflect.ValueOf - Get value information (for int)
char* reflect_ValueOfInt(int value) {
    static char result[128];
    snprintf(result, sizeof(result), "int|%d", value);
    return result;
}

// reflect.ValueOfFloat - Get value information for float
char* reflect_ValueOfFloat(double value) {
    static char result[128];
    snprintf(result, sizeof(result), "float|%.6f", value);
    return result;
}

// reflect.ValueOfString - Get value information for string
char* reflect_ValueOfString(const char* value) {
    static char result[512];
    if (value == NULL) {
        snprintf(result, sizeof(result), "string|NULL");
    } else {
        snprintf(result, sizeof(result), "string|%s", value);
    }
    return result;
}

// reflect.Kind - Get type kind (0=int, 1=float, 2=string, 3=bool, 4=error, 5=pointer)
int reflect_Kind(const char* type_name) {
    init_type_registry();
    
    for (int i = 0; i < type_count; i++) {
        if (strcmp(type_registry[i].name, type_name) == 0) {
            return type_registry[i].kind;
        }
    }
    
    return -1;  // Unknown type
}

// reflect.Size - Get type size in bytes
int reflect_Size(const char* type_name) {
    init_type_registry();
    
    for (int i = 0; i < type_count; i++) {
        if (strcmp(type_registry[i].name, type_name) == 0) {
            return type_registry[i].size;
        }
    }
    
    return 0;  // Unknown type
}

// reflect.Name - Get type name
char* reflect_Name(const char* type_name) {
    static char result[64];
    init_type_registry();
    
    for (int i = 0; i < type_count; i++) {
        if (strcmp(type_registry[i].name, type_name) == 0) {
            strncpy(result, type_registry[i].name, sizeof(result) - 1);
            result[sizeof(result) - 1] = '\0';
            return result;
        }
    }
    
    strcpy(result, "unknown");
    return result;
}

// reflect.IsInt - Check if type is int
int reflect_IsInt(const char* type_name) {
    return reflect_Kind(type_name) == 0;
}

// reflect.IsFloat - Check if type is float
int reflect_IsFloat(const char* type_name) {
    return reflect_Kind(type_name) == 1;
}

// reflect.IsString - Check if type is string
int reflect_IsString(const char* type_name) {
    return reflect_Kind(type_name) == 2;
}


// ========== encoding/base64 library ==========
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Base64 character table
static const char base64_chars[] = 
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static int base64_char_index(char c) {
    if (c >= 'A' && c <= 'Z') return c - 'A';
    if (c >= 'a' && c <= 'z') return c - 'a' + 26;
    if (c >= '0' && c <= '9') return c - '0' + 52;
    if (c == '+') return 62;
    if (c == '/') return 63;
    return -1;  // Invalid character
}

// base64.Encode - Encode string to base64
char* base64_Encode(const char* data) {
    static char result[4096];
    result[0] = '\0';
    
    if (data == NULL) return result;
    
    int len = strlen(data);
    int pos = 0;
    
    for (int i = 0; i < len; i += 3) {
        unsigned char byte1 = (unsigned char)data[i];
        unsigned char byte2 = (i + 1 < len) ? (unsigned char)data[i + 1] : 0;
        unsigned char byte3 = (i + 2 < len) ? (unsigned char)data[i + 2] : 0;
        
        // Encode 3 bytes into 4 base64 characters
        result[pos++] = base64_chars[(byte1 >> 2) & 0x3F];
        result[pos++] = base64_chars[((byte1 & 0x3) << 4) | ((byte2 >> 4) & 0xF)];
        
        if (i + 1 < len) {
            result[pos++] = base64_chars[((byte2 & 0xF) << 2) | ((byte3 >> 6) & 0x3)];
        } else {
            result[pos++] = '=';
        }
        
        if (i + 2 < len) {
            result[pos++] = base64_chars[byte3 & 0x3F];
        } else {
            result[pos++] = '=';
        }
        
        if (pos >= sizeof(result) - 1) break;
    }
    
    result[pos] = '\0';
    return result;
}

// base64.Decode - Decode base64 string
char* base64_Decode(const char* encoded) {
    static char result[3072];
    result[0] = '\0';
    
    if (encoded == NULL) return result;
    
    int len = strlen(encoded);
    int pos = 0;
    
    // Remove padding
    while (len > 0 && encoded[len - 1] == '=') len--;
    
    for (int i = 0; i < len; i += 4) {
        if (i + 3 >= len) break;
        
        int idx1 = base64_char_index(encoded[i]);
        int idx2 = base64_char_index(encoded[i + 1]);
        int idx3 = base64_char_index(encoded[i + 2]);
        int idx4 = base64_char_index(encoded[i + 3]);
        
        if (idx1 < 0 || idx2 < 0 || idx3 < 0 || idx4 < 0) break;
        
        // Decode 4 base64 characters into 3 bytes
        unsigned char byte1 = (idx1 << 2) | ((idx2 >> 4) & 0x3);
        unsigned char byte2 = ((idx2 & 0xF) << 4) | ((idx3 >> 2) & 0xF);
        unsigned char byte3 = ((idx3 & 0x3) << 6) | idx4;
        
        result[pos++] = byte1;
        
        if (encoded[i + 2] != '=') {
            result[pos++] = byte2;
        }
        
        if (encoded[i + 3] != '=') {
            result[pos++] = byte3;
        }
        
        if (pos >= sizeof(result) - 1) break;
    }
    
    result[pos] = '\0';
    return result;
}

// base64.EncodeBytes - Encode byte array to base64
char* base64_EncodeBytes(const char* data) {
    // Data format: byte1|byte2|byte3 (pipe-separated bytes as strings)
    static char result[4096];
    result[0] = '\0';
    
    if (data == NULL) return result;
    
    // Convert pipe-separated bytes to actual bytes
    unsigned char bytes[1024];
    int byte_count = 0;
    
    char* copy = strdup(data);
    char* token = strtok(copy, "|");
    
    while (token != NULL && byte_count < sizeof(bytes)) {
        bytes[byte_count++] = (unsigned char)atoi(token);
        token = strtok(NULL, "|");
    }
    
    free(copy);
    
    // Encode bytes
    int pos = 0;
    
    for (int i = 0; i < byte_count; i += 3) {
        unsigned char byte1 = bytes[i];
        unsigned char byte2 = (i + 1 < byte_count) ? bytes[i + 1] : 0;
        unsigned char byte3 = (i + 2 < byte_count) ? bytes[i + 2] : 0;
        
        result[pos++] = base64_chars[(byte1 >> 2) & 0x3F];
        result[pos++] = base64_chars[((byte1 & 0x3) << 4) | ((byte2 >> 4) & 0xF)];
        
        if (i + 1 < byte_count) {
            result[pos++] = base64_chars[((byte2 & 0xF) << 2) | ((byte3 >> 6) & 0x3)];
        } else {
            result[pos++] = '=';
        }
        
        if (i + 2 < byte_count) {
            result[pos++] = base64_chars[byte3 & 0x3F];
        } else {
            result[pos++] = '=';
        }
        
        if (pos >= sizeof(result) - 1) break;
    }
    
    result[pos] = '\0';
    return result;
}

// base64.DecodeBytes - Decode base64 to byte array
char* base64_DecodeBytes(const char* encoded) {
    static char result[3072];
    result[0] = '\0';
    
    if (encoded == NULL) return result;
    
    int len = strlen(encoded);
    unsigned char bytes[1024];
    int byte_count = 0;
    
    // Remove padding
    while (len > 0 && encoded[len - 1] == '=') len--;
    
    for (int i = 0; i < len; i += 4) {
        if (i + 3 >= len) break;
        
        int idx1 = base64_char_index(encoded[i]);
        int idx2 = base64_char_index(encoded[i + 1]);
        int idx3 = base64_char_index(encoded[i + 2]);
        int idx4 = base64_char_index(encoded[i + 3]);
        
        if (idx1 < 0 || idx2 < 0 || idx3 < 0 || idx4 < 0) break;
        
        bytes[byte_count++] = (idx1 << 2) | ((idx2 >> 4) & 0x3);
        
        if (encoded[i + 2] != '=') {
            bytes[byte_count++] = ((idx2 & 0xF) << 4) | ((idx3 >> 2) & 0xF);
        }
        
        if (encoded[i + 3] != '=') {
            bytes[byte_count++] = ((idx3 & 0x3) << 6) | idx4;
        }
        
        if (byte_count >= sizeof(bytes)) break;
    }
    
    // Convert bytes to pipe-separated string
    int pos = 0;
    for (int i = 0; i < byte_count; i++) {
        if (i > 0) result[pos++] = '|';
        pos += snprintf(result + pos, sizeof(result) - pos, "%d", bytes[i]);
        if (pos >= sizeof(result) - 1) break;
    }
    
    result[pos] = '\0';
    return result;
}


// ========== errors library ==========
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// errors.New - Create new error
char* errors_New(const char* msg) {
    if (!msg) return NULL;
    int len = strlen(msg);
    char* err = (char*)malloc(len + 1);
    if (!err) return NULL;
    strcpy(err, msg);
    return err;
}

// errors.Errorf - Format error message
// Note: Simplified - uses sprintf for formatting
char* errors_Errorf(const char* format, const char* arg1) {
    static char buffer[1024];
    snprintf(buffer, sizeof(buffer), format, arg1);
    int len = strlen(buffer);
    char* err = (char*)malloc(len + 1);
    if (!err) return NULL;
    strcpy(err, buffer);
    return err;
}

// errors.Wrap - Wrap error with context message
char* errors_Wrap(char* err, const char* context) {
    if (!err) return NULL;
    if (!context) return err;
    int err_len = strlen(err);
    int ctx_len = strlen(context);
    char* wrapped = (char*)malloc(err_len + ctx_len + 3);
    if (!wrapped) return err;
    snprintf(wrapped, err_len + ctx_len + 3, "%s: %s", context, err);
    free(err);  // Free original error
    return wrapped;
}

// errors.IsNil - Check if error is nil
int errors_IsNil(char* err) {
    return err == NULL ? 1 : 0;
}

// errors.Unwrap - Get underlying error (placeholder)
char* errors_Unwrap(char* err) {
    // For now, just return the error itself
    // In future, could extract wrapped error
    return err;
}


// ========== net library ==========
#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    #pragma comment(lib, "ws2_32.lib")
    #define close closesocket
    #define SHUT_RDWR SD_BOTH
#else
    #include <sys/socket.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <netdb.h>
    #include <unistd.h>
    #include <fcntl.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// OpenSSL/TLS Support
#ifdef USE_OPENSSL
    #include <openssl/ssl.h>
    #include <openssl/err.h>
    #include <openssl/x509v3.h>
#endif

// net.Init - Initialize network library (Windows only)
int net_Init(void) {
#ifdef _WIN32
    WSADATA wsa;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0) {
        return -1;
    }
    return 0;
#else
    return 0;
#endif
}

// net.Cleanup - Cleanup network library (Windows only)
void net_Cleanup(void) {
#ifdef _WIN32
    WSACleanup();
#endif
}

// net.ResolveHost - Resolve hostname to IP address
// Returns: IP address string (caller must free), or NULL on error
char* net_ResolveHost(const char* hostname) {
    if (!hostname) return NULL;
    
    struct addrinfo hints, *result, *rp;
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;  // IPv4 only for now
    hints.ai_socktype = SOCK_STREAM;
    
    int status = getaddrinfo(hostname, NULL, &hints, &result);
    if (status != 0) {
        return NULL;
    }
    
    // Get first IPv4 address
    char* ip = NULL;
    for (rp = result; rp != NULL; rp = rp->ai_next) {
        if (rp->ai_family == AF_INET) {
            struct sockaddr_in* addr = (struct sockaddr_in*)rp->ai_addr;
            ip = (char*)malloc(INET_ADDRSTRLEN);
            if (ip) {
                inet_ntop(AF_INET, &addr->sin_addr, ip, INET_ADDRSTRLEN);
            }
            break;
        }
    }
    
    freeaddrinfo(result);
    return ip;
}

// net.Dial - Create TCP connection to host:port
// Returns: Socket file descriptor, or -1 on error
int net_Dial(const char* host, int port) {
    if (!host) return -1;
    
    // Resolve hostname
    struct addrinfo hints, *result, *rp;
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    
    char port_str[16];
    snprintf(port_str, sizeof(port_str), "%d", port);
    
    int status = getaddrinfo(host, port_str, &hints, &result);
    if (status != 0) {
        return -1;
    }
    
    // Try each address until we connect
    int sockfd = -1;
    for (rp = result; rp != NULL; rp = rp->ai_next) {
        sockfd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
        if (sockfd == -1) continue;
        
        if (connect(sockfd, rp->ai_addr, rp->ai_addrlen) == 0) {
            break;  // Success
        }
        
        close(sockfd);
        sockfd = -1;
    }
    
    freeaddrinfo(result);
    return sockfd;
}

// net.Send - Send data over socket
// Returns: Number of bytes sent, or -1 on error
int net_Send(int sockfd, const char* data, int len) {
    if (sockfd < 0 || !data || len < 0) return -1;
    return send(sockfd, data, len, 0);
}

// net.Recv - Receive data from socket
// Returns: Number of bytes received, or -1 on error
// Note: buffer must be pre-allocated
int net_Recv(int sockfd, char* buffer, int len) {
    if (sockfd < 0 || !buffer || len < 0) return -1;
    return recv(sockfd, buffer, len, 0);
}

// net.Close - Close socket
void net_Close(int sockfd) {
    if (sockfd >= 0) {
        close(sockfd);
    }
}

// net.Listen - Listen on port
// Returns: Socket file descriptor, or -1 on error
int net_Listen(int port) {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) return -1;
    
    // Set socket options (reuse address)
    int opt = 1;
#ifdef _WIN32
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
#else
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
#endif
    
    // Bind to port
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(port);
    
    if (bind(sockfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        close(sockfd);
        return -1;
    }
    
    // Listen
    if (listen(sockfd, 10) < 0) {
        close(sockfd);
        return -1;
    }
    
    return sockfd;
}

// net.Accept - Accept incoming connection
// Returns: Socket file descriptor for new connection, or -1 on error
int net_Accept(int listenfd) {
    if (listenfd < 0) return -1;
    struct sockaddr_in client_addr;
    socklen_t addr_len = sizeof(client_addr);
    return accept(listenfd, (struct sockaddr*)&client_addr, &addr_len);
}

#ifdef USE_OPENSSL
// TLS Context structure (opaque pointer)
typedef struct {
    SSL_CTX* ctx;
} TLSContext;

// TLS Connection structure
typedef struct {
    int sockfd;
    SSL* ssl;
} TLSConnection;

// net.TLSInit - Initialize TLS/SSL library
// Returns: 0 on success, -1 on error
int net_TLSInit(void) {
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();
    return 0;
}

// net.TLSCleanup - Cleanup TLS/SSL library
void net_TLSCleanup(void) {
    EVP_cleanup();
}

// net.TLSDial - Create TLS connection to host:port
// Returns: TLS connection handle (void*), or NULL on error
// Caller must free with net_TLSClose()
void* net_TLSDial(const char* host, int port) {
    if (!host) return NULL;
    
    // Create SSL context
    SSL_CTX* ctx = SSL_CTX_new(TLS_client_method());
    if (!ctx) return NULL;
    
    // Enable certificate verification
    SSL_CTX_set_verify(ctx, SSL_VERIFY_PEER, NULL);
    
    // Load default certificate store
    if (SSL_CTX_set_default_verify_paths(ctx) != 1) {
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    // Create TCP connection first
    int sockfd = net_Dial(host, port);
    if (sockfd < 0) {
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    // Create SSL connection
    SSL* ssl = SSL_new(ctx);
    if (!ssl) {
        net_Close(sockfd);
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    // Attach socket to SSL
    SSL_set_fd(ssl, sockfd);
    
    // Set hostname for SNI (Server Name Indication)
    SSL_set_tlsext_host_name(ssl, host);
    
    // Perform TLS handshake
    if (SSL_connect(ssl) <= 0) {
        SSL_free(ssl);
        net_Close(sockfd);
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    // Verify certificate
    X509* cert = SSL_get_peer_certificate(ssl);
    if (!cert) {
        SSL_free(ssl);
        net_Close(sockfd);
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    long verify_result = SSL_get_verify_result(ssl);
    X509_free(cert);
    if (verify_result != X509_V_OK) {
        SSL_free(ssl);
        net_Close(sockfd);
        SSL_CTX_free(ctx);
        return NULL;
    }
    
    // Allocate TLS connection structure
    TLSConnection* tls_conn = (TLSConnection*)malloc(sizeof(TLSConnection));
    if (!tls_conn) {
        SSL_free(ssl);
        net_Close(sockfd);
        SSL_CTX_free(ctx);
        return NULL;
    }
    tls_conn->sockfd = sockfd;
    tls_conn->ssl = ssl;
    
    // Store context for cleanup
    // Note: In production, you might want to reuse SSL_CTX
    
    return (void*)tls_conn;
}

// net.TLSSend - Send data over TLS connection
// Returns: Number of bytes sent, or -1 on error
int net_TLSSend(void* tls_conn, const char* data, int len) {
    if (!tls_conn || !data || len < 0) return -1;
    TLSConnection* conn = (TLSConnection*)tls_conn;
    return SSL_write(conn->ssl, data, len);
}

// net.TLSRecv - Receive data from TLS connection
// Returns: Number of bytes received, or -1 on error
int net_TLSRecv(void* tls_conn, char* buffer, int len) {
    if (!tls_conn || !buffer || len < 0) return -1;
    TLSConnection* conn = (TLSConnection*)tls_conn;
    return SSL_read(conn->ssl, buffer, len);
}

// net.TLSClose - Close TLS connection
void net_TLSClose(void* tls_conn) {
    if (!tls_conn) return;
    TLSConnection* conn = (TLSConnection*)tls_conn;
    if (conn->ssl) {
        SSL_shutdown(conn->ssl);
        SSL_free(conn->ssl);
    }
    if (conn->sockfd >= 0) {
        net_Close(conn->sockfd);
    }
    free(tls_conn);
}

#else
// TLS functions stubs when OpenSSL is not available
int net_TLSInit(void) { return -1; }
void net_TLSCleanup(void) {}
void* net_TLSDial(const char* host, int port) { (void)host; (void)port; return NULL; }
int net_TLSSend(void* tls_conn, const char* data, int len) { (void)tls_conn; (void)data; (void)len; return -1; }
int net_TLSRecv(void* tls_conn, char* buffer, int len) { (void)tls_conn; (void)buffer; (void)len; return -1; }
void net_TLSClose(void* tls_conn) { (void)tls_conn; }
#endif


// ========== protobuf library ==========
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// Protobuf wire types
#define PROTOBUF_WIRE_VARINT 0
#define PROTOBUF_WIRE_FIXED64 1
#define PROTOBUF_WIRE_LENGTH_DELIMITED 2
#define PROTOBUF_WIRE_START_GROUP 3
#define PROTOBUF_WIRE_END_GROUP 4
#define PROTOBUF_WIRE_FIXED32 5

// Protobuf buffer for encoding/decoding
typedef struct ProtobufBuffer {
    uint8_t* data;
    size_t size;
    size_t capacity;
    size_t pos;  // For reading
} ProtobufBuffer;

// Initialize protobuf buffer
ProtobufBuffer* protobuf_buffer_new(size_t initial_capacity) {
    ProtobufBuffer* buf = (ProtobufBuffer*)malloc(sizeof(ProtobufBuffer));
    if (!buf) return NULL;
    buf->capacity = initial_capacity > 0 ? initial_capacity : 256;
    buf->data = (uint8_t*)malloc(buf->capacity);
    if (!buf->data) { free(buf); return NULL; }
    buf->size = 0;
    buf->pos = 0;
    return buf;
}

// Free protobuf buffer
void protobuf_buffer_free(ProtobufBuffer* buf) {
    if (!buf) return;
    if (buf->data) free(buf->data);
    free(buf);
}

// Ensure buffer has enough capacity
int protobuf_buffer_ensure(ProtobufBuffer* buf, size_t needed) {
    if (!buf) return 0;
    if (buf->size + needed <= buf->capacity) return 1;
    size_t new_capacity = buf->capacity * 2;
    while (new_capacity < buf->size + needed) new_capacity *= 2;
    uint8_t* new_data = (uint8_t*)realloc(buf->data, new_capacity);
    if (!new_data) return 0;
    buf->data = new_data;
    buf->capacity = new_capacity;
    return 1;
}

// Encode varint (variable-length integer)
int protobuf_encode_varint(ProtobufBuffer* buf, uint64_t value) {
    if (!buf) return 0;
    while (value >= 0x80) {
        if (!protobuf_buffer_ensure(buf, 1)) return 0;
        buf->data[buf->size++] = (uint8_t)((value & 0x7F) | 0x80);
        value >>= 7;
    }
    if (!protobuf_buffer_ensure(buf, 1)) return 0;
    buf->data[buf->size++] = (uint8_t)(value & 0x7F);
    return 1;
}

// Decode varint
int protobuf_decode_varint(ProtobufBuffer* buf, uint64_t* value) {
    if (!buf || !value || buf->pos >= buf->size) return 0;
    uint64_t result = 0;
    int shift = 0;
    while (buf->pos < buf->size) {
        uint8_t byte = buf->data[buf->pos++];
        result |= ((uint64_t)(byte & 0x7F) << shift);
        if ((byte & 0x80) == 0) {
            *value = result;
            return 1;
        }
        shift += 7;
        if (shift >= 64) return 0;  // Invalid varint
    }
    return 0;  // Incomplete varint
}

// Encode field tag (field_number << 3 | wire_type)
int protobuf_encode_tag(ProtobufBuffer* buf, int field_number, int wire_type) {
    if (!buf || field_number < 1 || field_number > 536870911) return 0;
    uint32_t tag = ((uint32_t)field_number << 3) | (wire_type & 0x7);
    return protobuf_encode_varint(buf, tag);
}

// Decode field tag
int protobuf_decode_tag(ProtobufBuffer* buf, int* field_number, int* wire_type) {
    if (!buf || !field_number || !wire_type) return 0;
    uint64_t tag;
    if (!protobuf_decode_varint(buf, &tag)) return 0;
    *field_number = (int)(tag >> 3);
    *wire_type = (int)(tag & 0x7);
    return 1;
}

// Encode int32 (signed varint)
int protobuf_encode_int32(ProtobufBuffer* buf, int32_t value) {
    // Zigzag encoding for signed integers
    uint32_t zigzag = (uint32_t)((value << 1) ^ (value >> 31));
    return protobuf_encode_varint(buf, zigzag);
}

// Decode int32
int protobuf_decode_int32(ProtobufBuffer* buf, int32_t* value) {
    if (!buf || !value) return 0;
    uint64_t zigzag;
    if (!protobuf_decode_varint(buf, &zigzag)) return 0;
    // Zigzag decoding
    *value = (int32_t)((zigzag >> 1) ^ -(int32_t)(zigzag & 1));
    return 1;
}

// Encode int64 (signed varint)
int protobuf_encode_int64(ProtobufBuffer* buf, int64_t value) {
    uint64_t zigzag = (uint64_t)((value << 1) ^ (value >> 63));
    return protobuf_encode_varint(buf, zigzag);
}

// Decode int64
int protobuf_decode_int64(ProtobufBuffer* buf, int64_t* value) {
    if (!buf || !value) return 0;
    uint64_t zigzag;
    if (!protobuf_decode_varint(buf, &zigzag)) return 0;
    *value = (int64_t)((zigzag >> 1) ^ -(int64_t)(zigzag & 1));
    return 1;
}

// Encode uint32 (unsigned varint)
int protobuf_encode_uint32(ProtobufBuffer* buf, uint32_t value) {
    return protobuf_encode_varint(buf, value);
}

// Decode uint32
int protobuf_decode_uint32(ProtobufBuffer* buf, uint32_t* value) {
    if (!buf || !value) return 0;
    uint64_t v;
    if (!protobuf_decode_varint(buf, &v)) return 0;
    *value = (uint32_t)v;
    return 1;
}

// Encode bool (as varint: 0 or 1)
int protobuf_encode_bool(ProtobufBuffer* buf, int value) {
    return protobuf_encode_varint(buf, value ? 1 : 0);
}

// Decode bool
int protobuf_decode_bool(ProtobufBuffer* buf, int* value) {
    if (!buf || !value) return 0;
    uint64_t v;
    if (!protobuf_decode_varint(buf, &v)) return 0;
    *value = (v != 0) ? 1 : 0;
    return 1;
}

// Encode float (fixed32, little-endian)
int protobuf_encode_float(ProtobufBuffer* buf, float value) {
    if (!buf || !protobuf_buffer_ensure(buf, 4)) return 0;
    union { float f; uint32_t i; } u;
    u.f = value;
    buf->data[buf->size++] = (uint8_t)(u.i & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 8) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 16) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 24) & 0xFF);
    return 1;
}

// Decode float
int protobuf_decode_float(ProtobufBuffer* buf, float* value) {
    if (!buf || !value || buf->pos + 4 > buf->size) return 0;
    union { float f; uint32_t i; } u;
    u.i = (uint32_t)buf->data[buf->pos++];
    u.i |= (uint32_t)buf->data[buf->pos++] << 8;
    u.i |= (uint32_t)buf->data[buf->pos++] << 16;
    u.i |= (uint32_t)buf->data[buf->pos++] << 24;
    *value = u.f;
    return 1;
}

// Encode double (fixed64, little-endian)
int protobuf_encode_double(ProtobufBuffer* buf, double value) {
    if (!buf || !protobuf_buffer_ensure(buf, 8)) return 0;
    union { double d; uint64_t i; } u;
    u.d = value;
    buf->data[buf->size++] = (uint8_t)(u.i & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 8) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 16) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 24) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 32) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 40) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 48) & 0xFF);
    buf->data[buf->size++] = (uint8_t)((u.i >> 56) & 0xFF);
    return 1;
}

// Decode double
int protobuf_decode_double(ProtobufBuffer* buf, double* value) {
    if (!buf || !value || buf->pos + 8 > buf->size) return 0;
    union { double d; uint64_t i; } u;
    u.i = (uint64_t)buf->data[buf->pos++];
    u.i |= (uint64_t)buf->data[buf->pos++] << 8;
    u.i |= (uint64_t)buf->data[buf->pos++] << 16;
    u.i |= (uint64_t)buf->data[buf->pos++] << 24;
    u.i |= (uint64_t)buf->data[buf->pos++] << 32;
    u.i |= (uint64_t)buf->data[buf->pos++] << 40;
    u.i |= (uint64_t)buf->data[buf->pos++] << 48;
    u.i |= (uint64_t)buf->data[buf->pos++] << 56;
    *value = u.d;
    return 1;
}

// Encode string (length-delimited)
int protobuf_encode_string(ProtobufBuffer* buf, const char* str) {
    if (!buf || !str) return 0;
    size_t len = strlen(str);
    if (!protobuf_encode_varint(buf, len)) return 0;
    if (!protobuf_buffer_ensure(buf, len)) return 0;
    memcpy(buf->data + buf->size, str, len);
    buf->size += len;
    return 1;
}

// Decode string
char* protobuf_decode_string(ProtobufBuffer* buf) {
    if (!buf) return NULL;
    uint64_t len;
    if (!protobuf_decode_varint(buf, &len)) return NULL;
    if (buf->pos + len > buf->size) return NULL;
    char* str = (char*)malloc(len + 1);
    if (!str) return NULL;
    memcpy(str, buf->data + buf->pos, len);
    str[len] = '\0';
    buf->pos += len;
    return str;
}

// protobuf.Marshal - Encode struct to binary protobuf format
// Returns: binary data as char* (caller must free), NULL on error
// Note: For structs, use compiler-generated protobuf_marshal_<structname>() functions
char* protobuf_Marshal(ProtobufBuffer* buf) {
    if (!buf || buf->size == 0) return NULL;
    char* result = (char*)malloc(buf->size);
    if (!result) return NULL;
    memcpy(result, buf->data, buf->size);
    return result;
}

// protobuf.Unmarshal - Initialize buffer from binary data
// Returns: ProtobufBuffer* (caller must free with protobuf_buffer_free), NULL on error
ProtobufBuffer* protobuf_Unmarshal(const char* data, size_t len) {
    if (!data || len == 0) return NULL;
    ProtobufBuffer* buf = protobuf_buffer_new(len);
    if (!buf) return NULL;
    memcpy(buf->data, data, len);
    buf->size = len;
    buf->pos = 0;
    return buf;
}

// Get encoded buffer size
size_t protobuf_Size(ProtobufBuffer* buf) {
    return buf ? buf->size : 0;
}

// Reset buffer position for reading
void protobuf_Reset(ProtobufBuffer* buf) {
    if (buf) buf->pos = 0;
}


#line 1 "examples/hello.tl"
void prarambham() {
    fmt_Printf("Hello, World!\n");
}
int main(int argc, char** argv) {
    args_Init(argc, argv);
    prarambham();
    return 0;
}
