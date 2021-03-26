#!/usr/bin/env scriptisto

#include <glibmm.h>

#include <iostream>

// scriptisto-begin
// script_src: main.cpp
// build_cmd: g++ -O2 -fuse-ld=lld main.cpp --std=gnu++20 -Wall -Wextra -Wpedantic `pkg-config --libs --cflags glibmm-2.4` -o ./script
// scriptisto-end

int main(int argc, char *argv[]) {
	const auto user = Glib::getenv("USER");
	std::cout << "Hello, C++! Current user: " << user << std::endl;
	return 0;
}
