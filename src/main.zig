const std = @import("std");
const math = std.math;

const equationNamespace = @import("equation.zig");
const Equation = equationNamespace.Equation;
const CoordinatePair = equationNamespace.CoordinatePair;

usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");


// TODO:
// Move screen space vector generation into its own function
// RESOLUTION: Have a way to define how many screen points = world points (i.e every 10 pixels is 1 unit increase)
// Redefine equation to use some sort of mapping implementation, so we can have terms with fractional or negative degrees
// Implement a derive function and then do tangents to functions at certain points
// Implement a gui

pub fn main() anyerror!void {
    var gpalloc = std.heap.GeneralPurposeAllocator(.{
        .verbose_log = true
    }){};
    var allocator = &gpalloc.allocator;
    defer _ = gpalloc.deinit();

    var squared: Equation = try Equation.init(allocator);
    defer squared.deinit();

    try squared.setTerm(2, 1);
    try squared.setTerm(0, 5);
    var points: []CoordinatePair = try squared.generatePoints(allocator, 0, 1.5, 10);
    defer allocator.free(points);
    var pointsToScreenSpace: []Vector2 = try allocator.alloc(Vector2, points.len);
    defer allocator.free(pointsToScreenSpace);

    for (points) |point, i| {
        var vec = coordinatePairToScreenSpaceVector(point);
        pointsToScreenSpace[i] = vec;
    }
    InitWindow(WIDTH, HEIGHT, "Graphing Calculator");
    defer CloseWindow();

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(WHITE);
     
        // Axes
        DrawLineEx(coordinatePairToScreenSpaceVector(CoordinatePair.init(-WIDTH, 0)), coordinatePairToScreenSpaceVector(CoordinatePair.init(WIDTH, 0)), 3, BLACK);
        DrawLineEx(coordinatePairToScreenSpaceVector(CoordinatePair.init(0, HEIGHT)), coordinatePairToScreenSpaceVector(CoordinatePair.init(0, -HEIGHT)), 3, BLACK);

        for (pointsToScreenSpace) |vector, _| {
            DrawCircleV(vector, 3, BLUE);
        }

        EndDrawing();       
    }
}
