const std = @import("std");
const raylib = @import("c.zig");

pub fn main() anyerror!void {
    raylib.InitWindow(800, 450, "raylib - your first window");
    defer raylib.CloseWindow();

    while (!raylib.WindowShouldClose()) {
        raylib.BeginDrawing();
        
        raylib.EndDrawing();       
    }
}
