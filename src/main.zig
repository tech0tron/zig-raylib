const std = @import("std");
const math = std.math;
const equation = @import("equation.zig");
usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");

pub fn main() anyerror!void {
    InitWindow(WIDTH, HEIGHT, "raylib - your first window");
    defer CloseWindow();
}
