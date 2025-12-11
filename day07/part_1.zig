const std = @import("std");
const input = @embedFile("input.txt");

const Tile = enum {
    splitter,
    space,
    beam,
};

pub fn main() void {
    var map: [142][141]Tile = undefined;

    var row_iter = std.mem.splitScalar(u8, input, '\n');
    {
        var row_i: usize = 0;
        while (row_iter.next()) |row| : (row_i += 1) {
            for (row, 0..) |row_char, i| {
                map[row_i][i] = switch (row_char) {
                    '.' => .space,
                    'S' => .beam,
                    '^' => .splitter,
                    else => unreachable,
                };
            }
        }
    }

    var split_cnt: usize = 0;
    for (map[0 .. map.len - 1], 0..) |row, row_i| {
        for (row, 0..) |tile, col_i| {
            if (tile == .beam) {
                if (map[row_i + 1][col_i] == .splitter) {
                    map[row_i + 1][col_i + 1] = .beam;
                    map[row_i + 1][col_i - 1] = .beam;
                    split_cnt += 1;
                } else {
                    map[row_i + 1][col_i] = .beam;
                }
            }
        }
    }

    for (map) |row| {
        for (row) |tile| {
            const char: u8 = switch (tile) {
                .splitter => '^',
                .space => '.',
                .beam => '|',
            };
            std.debug.print("{c}", .{char});
        }
        std.debug.print("\n", .{});
    }

    std.debug.print("{d}\n", .{split_cnt});
}
