const std = @import("std");
usingnamespace @import("c.zig");

const CoordinatePair = @import("equation.zig").CoordinatePair;

pub const WIDTH = 800;
pub const HEIGHT = 800;
pub const SCALE = 20;

// wrapper for convenience and brevity
pub fn coordinatePairToScreenSpaceVector(pair: CoordinatePair) Vector2 {
    var x: f64 = (pair.x * SCALE) + (WIDTH / 2);
    var y: f64= (-pair.y * SCALE) + (HEIGHT/2);
    return Vector2 {
        .x = @floatCast(f32, x),
        .y = @floatCast(f32, y)
    };
}

pub fn coordinatePairsToScreenSpaceVectors(allocator: *std.mem.Allocator, pairs: []CoordinatePair) ![]Vector2 {
    var allocated = try allocator.alloc(Vector2, pairs.len);

    for (pairs) |pair, index| {
        allocated[index] = coordinatePairToScreenSpaceVector(pair);
    }

    return allocated;
}