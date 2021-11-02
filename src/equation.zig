const std = @import("std");
usingnamespace @import("c.zig");
usingnamespace @import("utilities.zig");

const Equation = struct {
    terms: []f32
};

pub fn equationNew(allocator: *std.mem.Allocator, maxDegrees: usize) !Equation {
    var terms_buffer: []f32 = try allocator.alloc(f32, maxDegrees) catch |err| {
        return err;
    };

    return Equation {
        .terms = terms_buffer
    };
}

const equationSetTermError = error {
    DegreeOutOfBounds
};
pub fn equationSetTerm(equation: Equation, degree: usize, term: f32) equationSetTermError!Equation {
    if (degree > (equation.terms.len - 1)) {
        return error.DegreeOutOfBounds;
    } else {
        equation.terms[degree] = term;
        return equation;
    }
}

pub fn equationGetAt(x: f32) Vector2 {
    var y: f32 = 0;
    for (terms) |*term, degree| {
        y += (term * std.math.pow(x, degree));
    }

    return vector(x, y);
}

const equationGetPointsError = error {
    IncorrectArguments
};
pub fn equationGetPoints(allocator: *std.mem.Allocator, xBegin: f32, xEnd: f32, xStep: f32) equationGetPointsError![]Vector2 {
    if (xBegin > xEnd) { return error.IncorrectArguments; }
    if (xStep == 0) { return error.IncorrectArguments; }

    var pointsToReturn = try allocator.alloc(Vector2, @as(usize, (-xBegin + xEnd) / xStep));

    var currentX = xBegin;
    var i = 0;
    while (currentX < xEnd) : ({ i += 0; currentX += xStep;}) {
        pointsToReturn[i] = equationGetAt(currentX);
    }

    return pointsToReturn;
}