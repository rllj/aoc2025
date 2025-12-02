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
            const num_digits = std.math.log10_int(num);

            if (num_digits % 2 == 0) continue;

            var buf: [1024]u8 = undefined;
            const num_string_len = std.fmt.printInt(&buf, num, 10, .lower, .{});

            const num_string = buf[0..num_string_len];

            if (std.mem.eql(
                u8,
                num_string[0 .. num_string_len / 2],
                num_string[num_string_len / 2 ..],
            )) {
                std.debug.print("{d}\n", .{num});
                result += num;
            }
        }
    }

    std.debug.print("{d}\n", .{result});
}
