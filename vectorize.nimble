# Package

version       = "0.1.0"
author        = "Mamy André-Ratsimbazafy"
description   = "A SIMD vectorization backend"
license       = "MIT or Apache License 2.0"

# Dependencies

requires "nim >= 1.2.0"

proc test(flags, path: string) =
  if not dirExists "build":
    mkDir "build"

  # Compilation language is controlled by TEST_LANG
  var lang = "c"
  if existsEnv"TEST_LANG":
    lang = getEnv"TEST_LANG"

  echo "\n========================================================================================"
  echo "Running [ ", lang, " ", flags, " ] ", path
  echo "========================================================================================"
  exec "nim " & lang & " " & flags & " --verbosity:0 --hints:off --warnings:off --threads:on -d:release --stacktrace:on --linetrace:on --outdir:build -r " & path

task test, "Run Vectorize tests":
  test "", "tests/test_gcc_intrinsics.nim"
