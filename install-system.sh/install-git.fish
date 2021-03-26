#!/usr/bin/fish env

# indexa
cd ~/git-builds
git clone https://github.com/mosmeh/indexa.git --depth 1
cd index
cargo install --path .

# godbolt
cd ~/git-builds
git clone https://github.com/compiler-explorer/comp
iler-explorer.git

# zapcc
cd ~/git-builds
git clone https://github.com/yrnkrn/zapcc.git
# cmake -DLLVM_ENABLE_WARNINGS -DLLVM_USE_LINKER=gold ..

# google benchmark
cd ~/git-builds
git clone https://github.com/google/benchmark.git --depth 1
cd benchmark
mkdir -p build && cd
cmake .. -DBENCHMARK_DOWNLOAD_DEPENDENCIES=ON -DBENCHMARK_ENABLE_GTEST_TESTS=OFF
ninja && sudo ninja install

