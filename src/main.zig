const std = @import("std");
const math = std.math;
usingnamespace @import("c.zig");

const WIDTH = 800;
const HEIGHT = 800;
const RESOLUTION = 4;

const POINTS_PER_SIDE = WIDTH / 2 / RESOLUTION;

// wrapper for convenience and brevity
pub fn vector(x: f32, y: f32) Vector2 {
    return Vector2 {
        .x = x + (WIDTH / 2),
        .y = -y + (HEIGHT/2),
    };
}

const SquareFunction = struct {
    pub fn yAt(x: f32) Vector2 {
        return vector(x, x*x);
    }

    pub fn points() [POINTS_PER_SIDE * 2]Vector2 {
        var pointsArray = [_]Vector2{Vector2{ .x = 0, .y = 0}} ** (POINTS_PER_SIDE * 2);

        var x: f32 = -1 * POINTS_PER_SIDE;
        var i: usize = 0;
    
        while (x < POINTS_PER_SIDE) : ({x += 1; i += 1;}) {
            pointsArray[i] = yAt(x);
        }

        return pointsArray;
    }
};

const TangentFunction = struct {
    pub fn yAt(x: f32, tangentX: f32) Vector2 {
        return vector(x, tangentX * tangentX + (2 * tangentX) * (x - tangentX));
    }

    pub fn points(tangentX: f32) [POINTS_PER_SIDE * 2]Vector2 {
        var pointsArray = [_]Vector2{Vector2{ .x = 0, .y = 0}} ** (POINTS_PER_SIDE * 2);

        var x: f32 = -1 * POINTS_PER_SIDE;
        var i: usize = 0;
    
        while (x < POINTS_PER_SIDE) : ({x += 1; i += 1;}) {
            pointsArray[i] = yAt(x, tangentX);
        }

        return pointsArray;
    }
};

pub fn main() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    InitWindow(WIDTH, HEIGHT, "raylib - your first window");
    defer CloseWindow();

    var points1 = SquareFunction.points();
    var points2 = TangentFunction.points(4);
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(WHITE);
        
        // Axes
        DrawLineEx(vector(-WIDTH,0), vector(WIDTH, 0), 3, BLACK);
        DrawLineEx(vector(0, HEIGHT), vector(0, -HEIGHT), 3, BLACK);

        for (points1) |*point, index| {
            if (index == (POINTS_PER_SIDE * 2) - 1) {
                break;
            }
            
            DrawLineEx(point.*, points1[index + 1], 3, BLUE);
        }

        for (points2) |*point, index| {
            if (index == (POINTS_PER_SIDE * 2) - 1) {
                break;
            }
            
            DrawLineEx(point.*, points2[index + 1], 3, GREEN);
        }

        EndDrawing();       
    }
}
