const std = @import("std");
const math = std.math;

const Equation = @import("equation.zig").Equation;

usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");

pub fn main() anyerror!void {
    var gpalloc = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = true
    }){};
    var allocator = &gpalloc.allocator;
    defer _ = gpalloc.deinit();

    var squared: Equation = try Equation.init(allocator);
    defer squared.deinit();

    try squared.setTerm(3, 2);
    try squared.setTerm(1, -8);
    _ = squared.generatePoint(3);
    _ = squared.generatePoint(1);
    _ = squared.generatePoint(2);

    //InitWindow(WIDTH, HEIGHT, "raylib - your first window");
    //defer CloseWindow();

   // while (!WindowShouldClose()) {
    //    BeginDrawing();
    //    ClearBackground(WHITE);
     
        // Axes
     //   DrawLineEx(vector(-WIDTH,0), vector(WIDTH, 0), 3, BLACK);
     //   DrawLineEx(vector(0, HEIGHT), vector(0, -HEIGHT), 3, BLACK);

      //  EndDrawing();       
    //}
}
