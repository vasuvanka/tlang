#ifndef _MM_MALLOC_H_INCLUDED
#define _MM_MALLOC_H_INCLUDED
#include <stdlib.h>
#include <malloc.h>
// Minimal stub for mm_malloc.h - provides basic functionality
static inline void* _mm_malloc(size_t size, size_t align) {
    (void)align; // Alignment parameter ignored in stub
    return malloc(size);
}
static inline void _mm_free(void* ptr) {
    free(ptr);
}
#endif /* _MM_MALLOC_H_INCLUDED */
