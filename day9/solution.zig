const std = @import("std");
const input = @embedFile("input.txt");

const Position = struct { x: i64, y: i64 };

pub fn main() void {
    const allocator = std.heap.c_allocator;

    var timer = std.time.Timer.start() catch unreachable;

    var row_iter = std.mem.splitScalar(u8, input, '\n');

    var positions = std.ArrayList(Position).initCapacity(allocator, 512) catch unreachable;
    defer positions.deinit(allocator);

    var idx: usize = 0;
    while (row_iter.next()) |row| {
        if (row.len == 0) continue;

        const comma_idx = std.mem.findScalar(u8, row, ',') orelse unreachable;

        const x = std.fmt.parseInt(i64, row[0..comma_idx], 10) catch unreachable;
        const y = std.fmt.parseInt(i64, row[comma_idx + 1 ..], 10) catch unreachable;

        positions.appendAssumeCapacity(.{ .x = x, .y = y });

        idx += 1;
    }

    var differences = std.ArrayList(u64).initCapacity(allocator, positions.items.len * positions.items.len) catch unreachable;
    defer differences.deinit(allocator);
    for (positions.items, 0..) |pos, i| {
        for (positions.items, 0..) |pos2, j| {
            if (i > j) {
                differences.appendAssumeCapacity((@abs(pos.x - pos2.x) + 1) * (@abs(pos.y - pos2.y) + 1));
            }
        }
    }

    const result = std.mem.max(u64, differences.items);
    const elapsed_part_one = timer.read();
    std.debug.print("Part one: {d} in {d}µs\n", .{ result, elapsed_part_one / 1000 });
}

fn dst(a: Position, b: Position) u64 {
    return @abs(@reduce(.Add, (b - a) * (b - a)));
}
