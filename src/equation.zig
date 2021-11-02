const std = @import("std");
usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");

pub const Equation = struct {
    const Self = @This();

    terms: []f32,

    pub fn new(allocator: *std.mem.Allocator, maxDegrees: usize) !Equation {
        var terms_buffer: []f32 = try allocator.alloc(f32, maxDegrees);
        std.mem.set(f32, terms_buffer, 0);

        return Equation {
            .terms = terms_buffer
        };
    }

    pub fn setTerm(self: *Self, degree: usize, term: f32) void {
        self.terms[degree] = term;
    }

    pub fn getAt(self: *Self, x: f32) Vector2 {
        var y: f32 = 0;
        for (self.terms) |term, degree| {
            y += (term * std.math.pow(f32, x, @intToFloat(f32, degree)));
        }

        if (x == 99) {
            std.debug.print("In getAt: {}\n", .{vector(x,y)});
        }
        return vector(x, y);
    }

    pub fn getPoints(self: *Self, allocator: *std.mem.Allocator, xBegin: f32, xEnd: f32, xStep: f32) ![]Vector2 {
        var pointsToReturn = try allocator.alloc(Vector2, @floatToInt(usize, (-xBegin + xEnd) / xStep));

        var currentX = xBegin;
        var i: usize = 0;
        while (currentX < xEnd) : ({ i += 0; currentX += xStep;}) {
            pointsToReturn[i] = self.getAt(currentX);
            if (currentX == 99) {
                std.debug.print("Inside the loop of getPoints: {}\n", .{pointsToReturn[i]});
            }
        }

        std.debug.print("After all points have been done (getPoints): {}\n", .{pointsToReturn[99]});
        return pointsToReturn;
    }
};