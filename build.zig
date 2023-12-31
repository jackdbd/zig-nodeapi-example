const std = @import("std");
const builtin = std.builtin;
const os = std.os;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const name = "addon";

    const lib = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = .{ .path = "src" ++ std.fs.path.sep_str ++ name ++ ".zig" },
        .link_libc = true,
        .target = target,
        .optimize = optimize,
    });

    lib.addSystemIncludePath(.{ .path = "deps/node-v18.17.0/include/node" });

    b.installArtifact(lib);

    const download_cmd = b.addSystemCommand(&.{"./download-node-headers.sh"});
    const download_step = b.step("download-node-headers", "Download Node.js header files");
    download_step.dependOn(&download_cmd.step);
}
