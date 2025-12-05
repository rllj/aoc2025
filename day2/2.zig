const std = @import("std");

const input = @embedFile("./input.txt");

pub const Range = struct {
    first: u64,
    last: u64,
};

pub fn solve_range_part_two(range: Range) u64 {
    var result: u64 = 0;
    for (range.first..range.last + 1) |num| {
        var buf: [16]u8 = undefined;
        const num_string = std.fmt.bufPrint(&buf, "{d}", .{num}) catch unreachable;

        if (num_string.len == 1) continue;
        const is_repeating = switch (num_string.len) {
            2 => num_string[0] == num_string[1],
            3 => false,
            4 => std.mem.eql(u8, num_string[0..2], num_string[2..]),
            5 => false,
            6 => std.mem.eql(u8, num_string[0..3], num_string[3..]) or
                std.mem.count(u8, num_string, num_string[0..2]) == 3,
            7 => false,
            8 => std.mem.count(u8, num_string, num_string[0..2]) == 4 or
                std.mem.count(u8, num_string, num_string[0..4]) == 2,
            9 => std.mem.count(u8, num_string, num_string[0..3]) == 3,
            10 => std.mem.eql(u8, num_string[0..5], num_string[5..]) or
                std.mem.count(u8, num_string, num_string[0..2]) == 5,
            else => unreachable,
        };

        if (is_repeating) {
            result += num;
        }
    }
    return result;
}

pub fn main() void {
    const input_trimmed = std.mem.trim(u8, input, " \n");
    var range_strings = std.mem.splitScalar(u8, input_trimmed, ',');

    var ranges = std.ArrayList(Range).initCapacity(std.heap.page_allocator, 1024) catch unreachable;

    while (range_strings.next()) |range_string| {
        const comma_index = std.mem.indexOfScalar(u8, range_string, '-') orelse unreachable;

        const range_begin_string = range_string[0..comma_index];
        const range_end_string = range_string[comma_index + 1 ..];

        const range_begin = std.fmt.parseInt(u64, range_begin_string, 10) catch unreachable;
        const range_end = std.fmt.parseInt(u64, range_end_string, 10) catch unreachable;

        ranges.append(
            std.heap.page_allocator,
            .{ .first = range_begin, .last = range_end },
        ) catch unreachable;
    }

    {
        var timer = std.time.Timer.start() catch unreachable;
        var sum: u64 = 0;
        for (ranges.items) |range| {
            sum += solve_range_part_one(range);
        }
        const elapsed = timer.read();

        std.debug.print(
            \\Part one:
            \\  Result: {d}
            \\  Completed in {d}µs
            \\
        , .{ sum, elapsed / 1000 });
    }

    {
        var timer = std.time.Timer.start() catch unreachable;
        var sum: u64 = 0;
        for (ranges.items) |range| {
            sum += solve_range_part_two(range);
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
