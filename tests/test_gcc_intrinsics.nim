# Vectorize
# Copyright (c) 2020-Present The SciNim Project
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import
  ../vectorize/platforms/simd_gcc_clang

func checkEq[N, T](a, b: VecIntrin[N, T]) =
  doAssert: cast[array[N, T]](a) == cast[array[N, T]](b)

proc test_smoke() =
  var v: VecIntrin[4, float32]

proc test_init() =
  let v = VecIntrin[4, float32].init [float32 0, 1, 2, 3]

proc test_add() =
  let v = VecIntrin[4, float32].init [float32 0, 1, 2, 3]
  let w = VecIntrin[4, float32].init [float32 3, 2, 1, 0]

  let expected = VecIntrin[4, float32].init [float32 3, 3, 3, 3]
  checkEq(v+w, expected)

test_smoke()
test_init()
test_add()
echo "test_gcc_instrincics - SUCCESS"
