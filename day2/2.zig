const std = @import("std");

const input = @embedFile("./input.txt");

pub fn main() void {
    const input_trimmed = std.mem.trim(u8, input, " \n");
    var ranges = std.mem.splitScalar(u8, input_trimmed, ',');

    var result: u64 = 0;

    while (ranges.next()) |range| {
        const comma_index = std.mem.indexOfScalar(u8, range, '-') orelse unreachable;

        const range_begin_string = range[0..comma_index];
        const range_end_string = range[comma_index + 1 ..];

        const range_begin = std.fmt.parseInt(u64, range_begin_string, 10) catch unreachable;
        const range_end = std.fmt.parseInt(u64, range_end_string, 10) catch unreachable;

        for (range_begin..range_end + 1) |num| {
            var buf: [16]u8 = undefined;
            const num_string = std.fmt.bufPrint(&buf, "{d}", .{num}) catch unreachable;

            if (std.mem.allEqual(u8, num_string, num_string[0])) {
                result += num;
                std.debug.print("{s}\n", .{num_string});
                continue;
            }
            const is_repeating = switch (num_string.len) {
                2 => blk: {
                    break :blk num_string[0] == num_string[1];
                },
                3 => false,
                4 => std.mem.eql(u8, num_string[0..2], num_string[2..]),
                5 => false,
                6 => blk: {
                    break :blk std.mem.eql(u8, num_string[0..3], num_string[3..]) or
                        std.mem.count(u8, num_string, num_string[0..2]) == 3;
                },
                7 => false,
                8 => blk: {
                    break :blk std.mem.count(u8, num_string, num_string[0..2]) == 4 or
                        std.mem.count(u8, num_string, num_string[0..4]) == 2;
                },
                9 => blk: {
                    break :blk std.mem.count(u8, num_string, num_string[0..3]) == 3;
                },
                10 => std.mem.eql(u8, num_string[0..5], num_string[5..]) or
                    std.mem.count(u8, num_string, num_string[0..2]) == 5,
                else => unreachable,
            };

            if (is_repeating) {
                std.debug.print("{s}\n", .{num_string});
                result += num;
            }
        }
    }

    std.debug.print("{d}\n", .{result});
}
