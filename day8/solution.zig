const std = @import("std");
const input = @embedFile("input.txt");

const Position = @Vector(3, i64);
const Pair = struct { pos1_idx: usize, pos2_idx: usize, dst: u64 };

fn cmp_pairs(_: void, a: Pair, b: Pair) bool {
    return a.dst < b.dst;
}

pub fn find(parents: []usize, idx: usize) usize {
    if (idx == parents[idx]) {
        return idx;
    }
    parents[idx] = find(parents, parents[idx]);
    return parents[idx];
}

pub fn merge(parents: []usize, idx1: usize, idx2: usize) void {
    parents[find(parents, parents[idx1])] = find(parents, idx2);
}

pub fn main() void {
    const allocator = std.heap.c_allocator;
    const line_count = std.mem.countScalar(u8, input, '\n');
    const numbers: []Position = allocator.alloc(Position, line_count) catch unreachable;
    defer allocator.free(numbers);

    var timer = std.time.Timer.start() catch unreachable;

    var pairs = std.ArrayList(Pair).initCapacity(allocator, line_count * line_count) catch unreachable;
    defer pairs.deinit(allocator);

    const parents: []usize = allocator.alloc(usize, line_count) catch unreachable;
    defer allocator.free(parents);

    var row_iter = std.mem.splitScalar(u8, input, '\n');

    var idx: usize = 0;
    while (row_iter.next()) |row| {
        if (row.len == 0) continue;

        var coord: [3]i64 = undefined;

        var numbers_iter = std.mem.splitScalar(u8, row, ',');
        for (0..3) |i| {
            const num_str = numbers_iter.next() orelse unreachable;
            const num = std.fmt.parseInt(i64, num_str, 10) catch unreachable;
            coord[i] = num;
        }

        numbers[idx] = @bitCast(coord);
        parents[idx] = idx;
        idx += 1;
    }

    for (numbers, 0..) |pos, i| {
        for (numbers, 0..) |pos2, j| {
            if (i > j) {
                pairs.appendAssumeCapacity(.{ .pos1_idx = i, .pos2_idx = j, .dst = dst(pos, pos2) });
            }
        }
    }

    std.mem.sort(Pair, pairs.items, {}, cmp_pairs);

    var last_merged: struct { idx1: usize, idx2: usize } = undefined;
    for (pairs.items, 0..) |pair, i| {
        if (i + 1 == 1000) {
            const counts: []usize = allocator.alloc(usize, line_count) catch unreachable;
            defer allocator.free(counts);
            @memset(counts, 0);

            for (0..numbers.len) |j| {
                counts[find(parents, j)] += 1;
            }

            std.mem.sort(usize, counts, {}, std.sort.desc(usize));

            const elapsed_part_one = timer.read();
            std.debug.print("Part one: {d} in {d}µs\n", .{ counts[0] * counts[1] * counts[2], elapsed_part_one / 1000 });
        }
        if (find(parents, pair.pos1_idx) != find(parents, pair.pos2_idx)) {
            merge(parents, pair.pos1_idx, pair.pos2_idx);
            last_merged = .{ .idx1 = pair.pos1_idx, .idx2 = pair.pos2_idx };
        }
    }
    const elapsed_part_two = timer.read();
    std.debug.print("Part two: {d} in {d}µs\n", .{ numbers[last_merged.idx1][0] * numbers[last_merged.idx2][0], elapsed_part_two / 1000 });
}

fn dst(a: Position, b: Position) u64 {
    return @abs(@reduce(.Add, (b - a) * (b - a)));
}
