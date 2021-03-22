#!/usr/bin/env scriptisto

#include <benchmark/benchmark.h>
#include <glibmm.h>

#include <iostream>

// scriptisto-begin
// script_src: main.cc
// build_cmd: g++ -O3 -march=native -mtune=native --std=gnu++20 -flto -Wall -Wextra -Wpedantic main.cc `pkg-config --libs --cflags glibmm-2.4` `pkg-config --libs --cflags benchmark` -lpthread -fopenmp -o ./script -fsanitize=address scriptisto-end

// Here till BENCHMARK() is the basic unit of a benchmark
static void ExampleBenchmark(benchmark::State& state) {
	for (auto _ : state) {
		// Replace this loop
		benchmark::DoNotOptimize(std::string());
	}
}
// Register the function as a benchmark
BENCHMARK(ExampleBenchmark);

BENCHMARK_MAIN();
