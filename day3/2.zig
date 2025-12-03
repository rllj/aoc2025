const std = @import("std");

const input = @embedFile("./input.txt");

pub fn main() void {
    const input_trimmed = std.mem.trim(u8, input, " \n");
    var ranges = std.mem.splitScalar(u8, input_trimmed, '\n');

    var sum: u64 = 0;

    while (ranges.next()) |range| {
        var result: [12]u8 = undefined;

        var largest_idx: usize = 0;
        for (0..12) |d| {
            const dst_from_end = 11 - d;

            var largest: u8 = 0;
            var idx = largest_idx;
            for (range[largest_idx .. range.len - dst_from_end]) |item| {
                if (item > largest) {
                    largest = item;
                    largest_idx = idx + 1;
                }
                idx += 1;
            }
            result[d] = largest;
        }

        const num = std.fmt.parseInt(u64, &result, 10) catch unreachable;
        std.debug.print("{d}\n", .{num});
        sum += num;
    }

    std.debug.print("Result: {d}\n", .{sum});
}
