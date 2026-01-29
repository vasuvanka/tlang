#ifndef _X86INTRIN_H_INCLUDED
#define _X86INTRIN_H_INCLUDED
// Minimal stub for x86intrin.h - provides basic intrinsics declarations
// This is a minimal implementation for compatibility
// Full x86 intrinsics are not implemented, but this prevents compilation errors
#include <stdint.h>
// Basic intrinsic function stubs (empty implementations)
static inline void _mm_pause(void) { __asm__ __volatile__("pause"); }
static inline void _mm_mfence(void) { __asm__ __volatile__("mfence"); }
static inline void _mm_lfence(void) { __asm__ __volatile__("lfence"); }
static inline void _mm_sfence(void) { __asm__ __volatile__("sfence"); }
// Additional intrinsics can be added as needed
#endif /* _X86INTRIN_H_INCLUDED */
