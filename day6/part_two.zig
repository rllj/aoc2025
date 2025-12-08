const std = @import("std");
const input = @embedFile("input.txt");

pub const OpOrNumber = union(enum) {
    operator: enum { add, mul },
    number: u64,
    end,
};

pub fn main() void {
    const first_line_end = std.mem.findScalar(u8, input, '\n') orelse unreachable;
    const mem = std.heap.page_allocator.alloc(OpOrNumber, first_line_end * 2) catch unreachable;

    var timer = std.time.Timer.start() catch unreachable;

    const line_count = std.mem.countScalar(u8, input, '\n') - 1;

    var operations: std.ArrayList(OpOrNumber) = .initBuffer(mem);

    for (0..first_line_end) |column| {
        var num_buffer: [4]u8 = [_]u8{' '} ** 4;

        for (0..line_count) |row| {
            num_buffer[row] = input[row * (first_line_end + 1) + column];
        }
        const num_string = std.mem.trim(u8, &num_buffer, &std.ascii.whitespace);

        if (num_string.len != 0) {
            const op_char = input[line_count * (first_line_end + 1) + column];
            const num = std.fmt.parseInt(u64, num_string, 10) catch unreachable;

            switch (op_char) {
                '*' => operations.appendAssumeCapacity(.{ .operator = .mul }),
                '+' => operations.appendAssumeCapacity(.{ .operator = .add }),
                else => {},
            }
            operations.appendAssumeCapacity(.{ .number = num });
        }
    }
    operations.appendAssumeCapacity(.end);

    const State = enum {
        start,
        add,
        mul,
    };

    var loc: u64 = 0;
    var acc: u64 = 0;
    var mul_scratch: u64 = 1;
    state: switch (State.start) {
        .start => {
            switch (operations.items[loc]) {
                .operator => |op| {
                    loc += 1;
                    continue :state switch (op) {
                        .add => .add,
                        .mul => .mul,
                    };
                },
                .end => {},
                else => unreachable,
            }
        },
        .add => switch (operations.items[loc]) {
            .operator => |op| {
                loc += 1;
                mul_scratch = 1;
                continue :state switch (op) {
                    .add => .add,
                    .mul => .mul,
                };
            },
            .number => |num| {
                loc += 1;
                acc += num;
                continue :state .add;
            },
            .end => {},
        },
        .mul => switch (operations.items[loc]) {
            .number => |num| {
                mul_scratch *= num;
                loc += 1;
                continue :state .mul;
            },
            .end => {
                acc += mul_scratch;
            },
            .operator => |op| {
                loc += 1;
                acc += mul_scratch;
                mul_scratch = 1;
                continue :state switch (op) {
                    .add => .add,
                    .mul => .mul,
                };
            },
        },
    }

    const elapsed = timer.read();

    std.debug.print("Part two finished in {d}us. Result: {d}\n", .{ elapsed / 1000, acc });
}
