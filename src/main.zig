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

    var squared: Equation = try Equation.new(allocator, 4);
    squared.setTerm(0, -2);
    squared.setTerm(0, 1);

    const points = try squared.getPoints(allocator, 0, 100, 1);
    defer allocator.free(points);
    
    std.debug.print("Just after getting points: {}\n", .{points[99]});
    InitWindow(WIDTH, HEIGHT, "raylib - your first window");
    defer CloseWindow();

    var done = false;
    std.debug.print("Just outside the loop: {}\n", .{points[99]});

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(WHITE);
     
        // Axes
        DrawLineEx(vector(-WIDTH,0), vector(WIDTH, 0), 3, BLACK);
        DrawLineEx(vector(0, HEIGHT), vector(0, -HEIGHT), 3, BLACK);

        if (!done) {
            std.debug.print("In the loop: {}\n", .{points[99]});
            done = true;
        }

        EndDrawing();       
    }
}
