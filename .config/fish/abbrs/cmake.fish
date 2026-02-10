# define some variables for CMAKE
abbr cmake-clang "cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -S . -B build"
abbr cmake-clang-12 "cmake -DCMAKE_C_COMPILER=clang-12 -DCMAKE_CXX_COMPILER=clang++-12 -S . -B build"
abbr cmake-gcc "cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -S . -B build"
abbr cmake-gcc-11 "cmake -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 -S . -B build"
abbr cmake-zig "cmake -DCMAKE_C_COMPILER=zig\ cc -DCMAKE_CXX_COMPILER=zig\ c++ -S . -B build"
abbr cmake-zap "cmake -DCMAKE_C_COMPILER=zapcc -DCMAKE_CXX_COMPILER=zapcc -S . -B build"
set -q CMAKE_GENERATOR; or set -gx CMAKE_GENERATOR Ninja
set -q CMAKE_BUILD_TYPE; or set -gx CMAKE_BUILD_TYPE Release
set -q CMAKE_EXPORT_COMPILE_COMMANDS; or set -gx CMAKE_EXPORT_COMPILE_COMMANDS ON
# if type -q mold
#     set -q LDFLAGS; or set -gx LDFLAGS "-fuse-ld=mold"
# else
#     set -q LDFLAGS; or set -gx LDFLAGS "-fuse-ld=lld"
# end
set -q MAKEFLAGS; or set -gx MAKEFLAGS -j (nproc)
set -q JULIA_NUM_THREADS; or set -gx JULIA_NUM_THREADS (nproc)
set -q ZST_NBTHREADS; or set -gx ZST_NBTHREADS 0
set -q ZST_CLEVEL; or set -gx ZST_CLEVEL 1
