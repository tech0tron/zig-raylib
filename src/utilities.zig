usingnamespace @import("c.zig");

pub const WIDTH = 800;
pub const HEIGHT = 800;
pub const RESOLUTION = 4;

pub const POINTS_PER_SIDE = WIDTH / 2 / RESOLUTION;

// wrapper for convenience and brevity
pub fn vector(x: f32, y: f32) Vector2 {
    return Vector2 {
        .x = x + (WIDTH / 2),
        .y = -y + (HEIGHT/2),
    };
}