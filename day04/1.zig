const std = @import("std");

const input = @embedFile("./input.txt");

pub fn main() void {
    //const input_trimmed = std.mem.trim(u8, input, "\n");

    var rows = std.ArrayList([]const u8).initCapacity(std.heap.page_allocator, 256) catch unreachable;

    var row_iterator = std.mem.tokenizeScalar(u8, input, '\n');

    while (row_iterator.next()) |row| {
        rows.appendAssumeCapacity(row);
    }

    var result: usize = 0;
    for (0..rows.items.len) |y| {
        for (0..rows.items[0].len) |x| {
            if (rows.items[y][x] == '.') continue;

            var neighbour_count: u8 = 0;
            const can_move_right = x != rows.items[0].len - 1;
            const can_move_left = x != 0;
            const can_move_up = y != 0;
            const can_move_down = y != rows.items.len - 1;

            if (can_move_right) {
                const right = rows.items[y][x + 1];
                neighbour_count += @intFromBool(right == '@');

                if (can_move_up) {
                    const up_right = rows.items[y - 1][x + 1];
                    neighbour_count += @intFromBool(up_right == '@');
                }
                if (can_move_down) {
                    const down_right = rows.items[y + 1][x + 1];
                    neighbour_count += @intFromBool(down_right == '@');
                }
            }
            if (can_move_left) {
                const left = rows.items[y][x - 1];
                neighbour_count += @intFromBool(left == '@');

                if (can_move_up) {
                    const up_left = rows.items[y - 1][x - 1];
                    neighbour_count += @intFromBool(up_left == '@');
                }
                if (can_move_down) {
                    const down_left = rows.items[y + 1][x - 1];
                    neighbour_count += @intFromBool(down_left == '@');
                }
            }
            if (can_move_up) {
                const up = rows.items[y - 1][x];
                neighbour_count += @intFromBool(up == '@');
            }
            if (can_move_down) {
                const down = rows.items[y + 1][x];
                neighbour_count += @intFromBool(down == '@');
            }

            if (neighbour_count < 4) {
                result += 1;
            }
        }
    }

    std.debug.print("Result: {d}\n", .{result});
}
