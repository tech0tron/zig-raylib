usingnamespace @import("c.zig");

const CoordinatePair = @import("equation.zig").CoordinatePair;

pub const WIDTH = 800;
pub const HEIGHT = 800;
pub const RESOLUTION = 4;

pub const POINTS_PER_SIDE = WIDTH / 2 / RESOLUTION;

// wrapper for convenience and brevity
pub fn coordinatePairToScreenSpaceVector(pair: CoordinatePair) Vector2 {
    var x: f64 = pair.x + (WIDTH / 2);
    var y: f64= -pair.y + (HEIGHT/2);
    return Vector2 {
        .x = @floatCast(f32, x),
        .y = @floatCast(f32, y)
    };
}