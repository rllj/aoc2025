const std = @import("std");

const input = @embedFile("./input.txt");

const Position = struct {
    x: usize,
    y: usize,
};

pub fn main() void {
    var timer = std.time.Timer.start() catch unreachable;

    var rows = std.ArrayList([]u8).initCapacity(std.heap.page_allocator, 256) catch unreachable;
    var row_iterator = std.mem.tokenizeScalar(u8, input, '\n');

    while (row_iterator.next()) |row| {
        const duped = std.heap.page_allocator.dupe(u8, row) catch unreachable;
        rows.appendAssumeCapacity(duped);
    }

    var stack: [16 * 1024]Position = undefined;
    var stack_len: usize = 0;

    var result: usize = 0;
    for (0..rows.items.len) |y| {
        for (0..rows.items[0].len) |x| {
            if (rows.items[y][x] == '@') {
                stack[stack_len] = .{ .x = x, .y = y };
                stack_len += 1;
            }
        }
    }

    while (stack_len > 0) {
        stack_len -= 1;
        const x = stack[stack_len].x;
        const y = stack[stack_len].y;
        if (rows.items[y][x] == '.') continue;

        var neighbour_count: usize = 0;

        const previous_stack_len: usize = stack_len;
        for (y -| 1..@min(y + 2, rows.items.len)) |neighbour_y| {
            for (x -| 1..@min(x + 2, rows.items[0].len)) |neighbour_x| {
                const neighbour = rows.items[neighbour_y][neighbour_x];

                if (neighbour == '@') {
                    neighbour_count += 1;
                    stack[stack_len] = .{ .x = neighbour_x, .y = neighbour_y };
                    stack_len += 1;
                }
            }
        }
        if (neighbour_count <= 4) {
            rows.items[y][x] = '.';
            result += 1;
        } else {
            stack_len = previous_stack_len;
        }
    }

    const elapsed = timer.read();

    std.debug.print("Result: {d}\nTook {d}µs\n", .{ result, elapsed / 1000 });
}
