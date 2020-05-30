# Vectorize
# Copyright (c) 2020-Present The SciNim Project
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# ############################################################
#
#              GCC and Clang Vector Extension
#
# ############################################################

static: doAssert: defined(gcc) or defined(clang)
import
  # Standard library
  std/[strutils, os, macros]

# FFI
# -------------------------------------------------------------------------------

const headerPath = currentSourcePath.rsplit(DirSep, 1)[0]

{.pragma: vec_intrin, importc, header: headerPath/"simd_gcc_clang_ffi.h".}

template declType(NumElements: static int, BaseType: typedesc): untyped {.dirty.}=
  type `BaseType x NumElements`* {.vec_intrin.} = object
    # TODO: should be private
    buf: array[NumElements, BaseType]

declType(4, int32)
declType(8, int32)
declType(16, int32)

declType(2, int64)
declType(4, int64)
declType(8, int64)

declType(4, float32)
declType(8, float32)
declType(16, float32)

declType(2, float64)
declType(4, float64)
declType(8, float64)

# Type declaration
# -------------------------------------------------------------------------------

{.experimental: "dynamicBindSym".}
macro dispatch*(N: static int, T: type SomeNumber): untyped =
  let BaseT = getTypeInst(T)[1]
  result = bindSym($BaseT & "x" & $N)

type
  VecIntrin*[N: static int, T: SomeNumber] = object
    v: dispatch(N, T)
    ## GCC/Clang vector intrinsics

# SIMD should be all inlined
{.push inline.}

# Initialization
# -------------------------------------------------------------------------------
# TODO: there is no way to construct a vector from an array
# in a platform independent way ¯\_(ツ)_/¯
# So we only support static construction

macro cName(N: static int, T: type SomeNumber): untyped =
  let BaseT = getTypeInst(T)[1]
  result = newLit($BaseT & "x" & $N)

func construct[N, T](values: static array[N, T]): string =
  result.add "{"
  for i, value in values:
    if i != 0:
      result.add ", "
    result.add $value
  result.add "}"

func init*[N, T](_: type VecIntrin[N, T], values: static array[N, T]): VecIntrin[N, T] {.noInit.} =
  const
    vecName = cName(N, T)
    constructor = construct(values)
  {.emit:[result.v, " = (", vecName, ")", constructor, ";"].}

# Public routines
# -------------------------------------------------------------------------------

func `$`*[N, T](vec: VecIntrin[N, T]): string =
  ## Display a vector
  $cast[array[N, T]](vec)

# Arithmetic
# -------------------------------------------------------------------------------

func `+`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result.v = a.v + b.v;".}

func `-`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result.v = a.v - b.v;".}

func `*`*(a, b: VecIntrin): VecIntrin =
  ## Vector addition
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result.v = a.v * b.v;".}

func cos*[N; T: SomeFloat](a: VecIntrin[N, T]): VecIntrin[N, T] =
  ## Vector cos
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result.v = cos(a.v);".}

func sin*[N; T: SomeFloat](a: VecIntrin[N, T]): VecIntrin[N, T] =
  ## Vector cos
  # Note: we rely on Nim keeping the result/a/b symbols the same in C,
  # otherwise emit is really verbose
  {.emit: "result.v = sin(a.v);".}

# Sanity checks
# -------------------------------------------------------------------------------

when isMainModule:
  var v: VecIntrin[4, float32]
  echo v
