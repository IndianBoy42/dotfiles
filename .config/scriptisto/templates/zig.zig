#!/usr/bin/env scriptisto

// scriptisto-begin
// script_src: main.zig
// build_cmd: zig build-exe -target native -O ReleaseSafe -static -femit-bin=script main.zig
// scriptisto-end

const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}