const std = @import("std");

const input = @embedFile("./input.txt");

pub fn main() void {
    const input_trimmed = std.mem.trim(u8, input, " \n");
    var ranges = std.mem.splitScalar(u8, input_trimmed, '\n');

    var result: u64 = 0;

    while (ranges.next()) |range| {
        std.debug.print("{s}\n", .{range});

        var largest: u64 = 0;
        var largest_idx: usize = 0;
        for (range, 0..) |item, i| {
            if (item > largest) {
                largest = item;
                largest_idx = i;
            }
        }

        var second: u64 = 0;
        if (largest_idx == range.len - 1) {
            for (range[0 .. range.len - 1]) |item| {
                if (item > second) {
                    second = item;
                }
            }
            std.debug.print("{d}{d}\n", .{ (second - '0'), (largest - '0') });
            result += (second - '0') * 10 + (largest - '0');
        } else {
            for (range[largest_idx + 1 ..]) |item| {
                if (item > second) {
                    second = item;
                }
            }
            std.debug.print("{d}{d}\n", .{ (largest - '0'), (second - '0') });
            result += (largest - '0') * 10 + (second - '0');
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}
