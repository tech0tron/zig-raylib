const std = @import("std");
const math = std.math;

const equationNamespace = @import("equation.zig");
const Equation = equationNamespace.Equation;
const CoordinatePair = equationNamespace.CoordinatePair;

usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");


// TODO:
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

    try squared.setTerm(3, 2);
    try squared.setTerm(1, -10);
    var points: []CoordinatePair = try squared.generatePoints(allocator, -100, 0.25, 800);
    defer allocator.free(points);
    var pointsToScreenSpace: []Vector2 = try coordinatePairsToScreenSpaceVectors(allocator, points);
    defer allocator.free(pointsToScreenSpace);
    InitWindow(WIDTH, HEIGHT, "Graphing Calculator");
    defer CloseWindow();

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(WHITE);
     
        // Axes
        DrawLineEx(coordinatePairToScreenSpaceVector(CoordinatePair.init(-WIDTH, 0)), coordinatePairToScreenSpaceVector(CoordinatePair.init(WIDTH, 0)), 3, BLACK);
        DrawLineEx(coordinatePairToScreenSpaceVector(CoordinatePair.init(0, HEIGHT)), coordinatePairToScreenSpaceVector(CoordinatePair.init(0, -HEIGHT)), 3, BLACK);

        for (pointsToScreenSpace[0..pointsToScreenSpace.len - 1]) |vector, index| {
            DrawLineEx(vector, pointsToScreenSpace[index + 1], 3, BLUE);
        }

        EndDrawing();       
    }
}
