#!/usr/bin/env scriptisto

#include <glib.h>
#include <stdio.h>

// scriptisto-begin
// script_src: main.c
// build_cmd: gcc -O2 --std=gnu2x -Wall -Wextra -Wpedantic main.cc `pkg-config --libs --cflags glibmm-2.4` -o ./script -fsanitize=address -g
// scriptisto-end

int main(int argc, char* argv[]) {
	const gchar* user = g_getenv("USER");
	printf("Hello, C! Current user: %s\n", user);
	return 0;
}
