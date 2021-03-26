#!/usr/bin/env scriptisto

#include <glibmm.h>

#include <iostream>

// scriptisto-begin
// script_src: main.cc
// build_cmd: clang++ -O2 -fuse-ld=lld --std=gnu++20 -Wall -Wextra -Wpedantic main.cc `pkg-config --libs --cflags glibmm-2.4` -o ./script 
// scriptisto-end

int main(int argc, char *argv[]) {
	const auto user = Glib::getenv("USER");
	std::cout << "Hello, C++! Current user: " << user << std::endl;
	return 0;
}
