const std = @import("std");

const input = @embedFile("./input.txt");

pub fn solve(number: []const u8, length: usize) u64 {
    var result: [12]u8 = undefined;

    var largest_idx: usize = 0;
    for (0..length) |d| {
        const dst_from_end = 11 - d;

        var largest: u8 = 0;
        var idx = largest_idx;
        for (number[largest_idx .. number.len - dst_from_end]) |item| {
            if (item > largest) {
                largest = item;
                largest_idx = idx + 1;
            }
            idx += 1;
        }
        result[d] = largest;
    }

    return std.fmt.parseInt(usize, result[0..length], 10) catch unreachable;
}

pub fn main() void {
    var numbers = std.mem.tokenizeScalar(u8, input, '\n');

    var timer = std.time.Timer.start() catch unreachable;
    {
        var sum: usize = 0;
        while (numbers.next()) |number| {
            sum += solve(number, 2);
        }
        const elapsed = timer.read();

        std.debug.print(
            \\Part one:
            \\  Result: {d}
            \\  Completed in {d}µs
            \\
        , .{ sum, elapsed / 1000 });
    }
    numbers.reset();
    timer.reset();
    {
        var sum: usize = 0;
        while (numbers.next()) |number| {
            sum += solve(number, 12);
        }
        const elapsed = timer.read();

        std.debug.print(
            \\Part two:
            \\  Result: {d}
            \\  Completed in {d}µs
            \\
        , .{ sum, elapsed / 1000 });
    }
}
