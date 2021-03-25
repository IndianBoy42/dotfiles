#!/usr/bin/env scriptisto

#include <glibmm.h>

#include <iostream>

// scriptisto-begin
// script_src: main.cc
// build_cmd: zapcc++ -O2 --std=gnu++2a -Wall -Wextra -Wpedantic main.cc -o ./script `pkg-config --libs --cflags glibmm-2.4` -v 
// scriptisto-end

int main(int argc, char *argv[]) {
	const auto user = Glib::getenv("USER");
	std::cout << "Hello, C++! Current user: " << user << std::endl;
	return 0;
}