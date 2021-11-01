const std = @import("std");
const math = std.math;
usingnamespace @import("c.zig");

const WIDTH = 800;
const HEIGHT = 800;
const RESOLUTION = 10;

const POINTS_PER_SIDE = WIDTH / 2 / RESOLUTION;

// wrapper for convenience and brevity
pub fn vector(x: f32, y: f32) Vector2 {
    return Vector2 {
        .x = x + (WIDTH / 2),
        .y = -y + (HEIGHT/2),
    };
}

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    InitWindow(WIDTH, HEIGHT, "raylib - your first window");
    defer CloseWindow();

    var points = [_]Vector2{Vector2{ .x = 0, .y = 0}} ** (POINTS_PER_SIDE * 2);

    var x: f32 = -1 * POINTS_PER_SIDE;
    var i: usize = 0;
    
    while (x < POINTS_PER_SIDE) : ({x += 1; i += 1;}) {
        const y = math.pow(f32, (x / 10), 3) - x;
        points[i] = vector(x * RESOLUTION, y * RESOLUTION);
    }

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(WHITE);
        
        // Axes
        DrawLineEx(vector(-WIDTH,0), vector(WIDTH, 0), 3, BLACK);
        DrawLineEx(vector(0, HEIGHT), vector(0, -HEIGHT), 3, BLACK);

        for (points) |*point, index| {
            if (index == (POINTS_PER_SIDE * 2) - 1) {
                break;
            }
            
            DrawLineEx(point.*, points[index + 1], 3, BLUE);
        }

        EndDrawing();       
    }
}
