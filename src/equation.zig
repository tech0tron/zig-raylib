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
            std.debug.print("coefficient = {d}, degree = {d}, ", .{coefficient.*, degree});
            y += coefficient.* * std.math.pow(f64, x, @intToFloat(f64, degree));
            std.debug.print(" y = {d}\n", .{y});
        }

        std.debug.print("Final y = {d}\n", .{y});

        return CoordinatePair.init(x, y);
    }
};