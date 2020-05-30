# Vectorize
# Copyright (c) 2020-Present The SciNim Project
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

static: doAssert: defined(gcc) or defined(clang)

# GCC and Clang Vector Extension
# -------------------------------------------------------------------------------

proc strType(BaseType: typedesc): string =
  when BaseType is SomeSignedInt:
    when BaseType is int:
      "NI"
    else:
      "NI" & $(sizeof(BaseType) * 8)
  elif BaseType is SomeUnsignedInt:
    when BaseType is uint:
      "NU"
    else:
      "NU" & $(sizeof(BaseType) * 8)
  elif BaseType is float32:
    "float"
  elif BaseType is (float or float64):
    "double"
  else:
    {.error: "Unreachable".}

template emitType(NumElements: static int, BaseType: typedesc): untyped {.dirty.}=
  # typedef float float32x8 __attribute__ ((vector_size (32)));
  {.emit:["typedef ", static(strType(BaseType)), " ", $BaseType, "x", $NumElements, " __attribute__ ((vector_size (", $(sizeof(BaseType) * NumElements), ")));"].}

  type `BaseType x NumElements`* {.importc, bycopy.} = object
    # TODO: should be private
    buf: array[NumElements, BaseType]

emitType(4, int32)
emitType(8, int32)
emitType(16, int32)

emitType(2, int64)
emitType(4, int64)
emitType(8, int64)

emitType(4, float32)
emitType(8, float32)
emitType(16, float32)

emitType(2, float64)
emitType(4, float64)
emitType(8, float64)

template dispatch*(N: static int, T: type SomeNumber): typedesc =
  # TODO: should be private
  # Workarounds upon workarounds ...
  when T is int:
    `intx N`
  elif T is uint:
    `uintx N`
  elif T is int32:
    `int32x N`
  elif T is uint32:
    `uint32x N`
  elif T is int64:
    `int64x N`
  elif T is uint64:
    `uint64x N`
  elif T is float32:
    `float32x N`
  elif T is float64:
    `float64x N`
  else:
    {.error: "Unsupported".}

type
  VecIntrin*[N: static int, T: SomeNumber] = dispatch(N, T)

{.push inline.}

func `$`*[N, T](vec: VecIntrin[N, T]): string =
  ## Display a vector
  $cast[array[N, T]](vec)

func init*[N, T](_: VecIntrin[N, T], values: array[N, T]): VecIntrin[N, T] =
  {.emit: "result = values;".}

func init*[N, T](_: VecIntrin[N, T], broadcastedValue: T): VecIntrin[N, T] =
  {.emit: "result = broadcastedValue;".}

func `+`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result = a + b;".}

func `-`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result = a - b;".}

func `*`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result = a * b;".}

func cos*[N; T: SomeFloat](a: VecIntrin[N, T]): VecIntrin[N, T] =
  ## Vector cos
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result = cos(a);".}

func sin*[N; T: SomeFloat](a: VecIntrin[N, T]): VecIntrin[N, T] =
  ## Vector cos
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result = sin(a);".}

# Sanity checks
# -------------------------------------------------------------------------------

when isMainModule:
  var v: VecIntrin[4, float32]
  echo v
