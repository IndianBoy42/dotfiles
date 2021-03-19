#!/usr/bin/env scriptisto

#include <glib.h>
#include <stdio.h>

// scriptisto-begin
// script_src: main.c
// build_cmd: clang -O2 --std=gnu2x -Wall -Wextra -Wpedantic main.c `pkg-config --libs --cflags glib-2.0` -o ./script -fsanitize=address -g
// scriptisto-end

int main(int argc, char* argv[]) {
	const gchar* user = g_getenv("USER");
	printf("Hello, C! Current user: %s\n", user);
	return 0;
}
