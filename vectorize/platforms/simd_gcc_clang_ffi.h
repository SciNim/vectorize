// Vectorize
// Copyright (c) 2020-Present The SciNim Project
// Licensed and distributed under either of
//   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
//   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
// at your option. This file may not be copied, modified, or distributed except according to those terms.
#include <stdint.h>

typedef int32_t int32x4 __attribute__ ((vector_size (16)));
typedef int32_t int32x8 __attribute__ ((vector_size (32)));
typedef int32_t int32x16 __attribute__ ((vector_size (64)));

typedef int64_t int64x2 __attribute__ ((vector_size (16)));
typedef int64_t int64x4 __attribute__ ((vector_size (32)));
typedef int64_t int64x8 __attribute__ ((vector_size (64)));

typedef uint32_t uint32x4 __attribute__ ((vector_size (16)));
typedef uint32_t uint32x8 __attribute__ ((vector_size (32)));
typedef uint32_t uint32x16 __attribute__ ((vector_size (64)));

typedef uint64_t uint64x2 __attribute__ ((vector_size (16)));
typedef uint64_t uint64x4 __attribute__ ((vector_size (32)));
typedef uint64_t uint64x8 __attribute__ ((vector_size (64)));

typedef float float32x4 __attribute__ ((vector_size (16)));
typedef float float32x8 __attribute__ ((vector_size (32)));
typedef float float32x16 __attribute__ ((vector_size (64)));

typedef double float64x2 __attribute__ ((vector_size (16)));
typedef double float64x4 __attribute__ ((vector_size (32)));
typedef double float64x8 __attribute__ ((vector_size (64)));
