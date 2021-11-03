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

    terms: []f64,
    allocator: *std.mem.Allocator,

    pub fn init(allocator: *std.mem.Allocator) !Equation {
        var allocated = try allocator.alloc(f64, 4);
        std.mem.set(f64, allocated, 0);

        return Equation {
            .terms = allocated,
            .allocator = allocator
        };
    }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.terms);
    } 

    const setTermError = error {
        NegativeDegreeNotSupported
    };
    pub fn setTerm(self: *Self, degree: usize, coefficient: f64) !void {
        if (degree < 0) {
            return setTermError.NegativeDegreeNotSupported;
        }

        if (degree > self.terms.len - 1) {
            const newAllocation = try self.allocator.alloc(f64, self.terms.len + EquationInitialTermsSize);
            
            std.mem.set(f64, newAllocation, 0);
            std.mem.copy(f64, newAllocation, self.terms);
            self.allocator.free(self.terms);
            self.terms = newAllocation;
        }

        self.terms[degree] = coefficient;
    }

    pub fn generatePoint(self: *Self, x: f64) CoordinatePair {
        var y: f64 = 0;

        for (self.terms) |*coefficient, degree| {
            y += coefficient.* * std.math.pow(f64, x, @intToFloat(f64, degree));
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