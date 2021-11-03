const std = @import("std");
usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");

pub const CoordinatePair = struct {
    x: f64,
    y: f64,

    pub fn init(x: f64, y: f64) CoordinatePair {
        return CoordinatePair {
            .x = x,
            .y = y
        };
    }
};

const EquationInitialTermsSize = 4;
pub const Equation = struct {
    const Self = @This();

    terms: []CoordinatePair,
    allocator: *std.mem.Allocator,

    pub fn init(allocator: *std.mem.Allocator) !Equation {
        var allocated = try allocator.alloc(CoordinatePair, 4);
        std.mem.set(CoordinatePair, allocated, .{ .x = 0, .y = 0} );

        return Equation {
            .terms = allocated,
            .allocator = allocator
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.terms);
    } 

    pub fn setTerm(self: *Self, degree: f64, coefficient: f64) !void {
        for (self.terms) |*term| {
            if (term.x == degree) {
                (term.*).y = coefficient;
                return;
            }
        }
        
        const newAllocation = try self.allocator.alloc(CoordinatePair, self.terms.len + 1);
        std.mem.set(CoordinatePair, newAllocation, .{ .x = 0, .y = 0});
        std.mem.copy(CoordinatePair, newAllocation, self.terms);
        self.allocator.free(self.terms);
        self.terms = newAllocation;

        self.terms[self.terms.len - 1] = CoordinatePair { .x = degree, .y = coefficient };
    }

    pub fn generatePoint(self: *Self, x: f64) CoordinatePair {
        var y: f64 = 0;

        for (self.terms) |term| {
            y += term.y * std.math.pow(f64, x, term.x);
        }

        std.debug.print("Point: ({d}, {d})\n", .{x, y});

        return CoordinatePair.init(x, y);
    }

    pub fn generatePoints(self: *Self, allocator: *std.mem.Allocator, initialX: f64, stepX: f64, numberOfPoints: usize) ![]CoordinatePair {
        var allocated = try allocator.alloc(CoordinatePair, numberOfPoints);

        var i: usize = 0;
        while (i < numberOfPoints): (i += 1) {
            allocated[i] = self.generatePoint(initialX + (stepX * @intToFloat(f64, i)));
        }

        return allocated;
    } 
};