const std = @import("std");
const consts = @import("./constants.zig");
const Dram = @import("./dram.zig").Dram;
const ArrayList = std.ArrayList;

const MemoryMapError = error{IllegalAddressError};

pub const MemoryMap = struct {
    dram: Dram,

    const Self = @This();

    pub fn init(code: []u8) !Self {
        return .{
            .dram = try Dram.init(code),
        };
    }

    pub fn load(self: *Self, addr: u64, size: u64) !u64 {
        switch (addr) {
            consts.RAM_BASE_ADDR...consts.RAM_END_ADDR => return try self.dram.load(addr, size),
            else => {
                // std.debug.print("Illegal address: {}, {}, {}\n", .{ addr, consts.RAM_BASE_ADDR, consts.RAM_END_ADDR });
                return MemoryMapError.IllegalAddressError;
            },
        }
    }

    pub fn store(self: *Self, addr: u64, size: u64, value: u64) !void {
        switch (addr) {
            consts.RAM_BASE_ADDR...consts.RAM_END_ADDR => return try self.dram.store(addr, size, value),
            else => {
                // std.debug.print("Illegal address: {}, {}, {}\n", .{ addr, consts.RAM_BASE_ADDR, consts.RAM_END_ADDR });
                return MemoryMapError.IllegalAddressError;
            },
        }
    }
};
