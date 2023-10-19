const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const name = "addon";

    const lib = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = .{ .path = "src" ++ std.fs.path.sep_str ++ name ++ ".zig" },
        .link_libc = true,
        .target = .{
            .cpu_arch = .x86_64,
            .os_tag = .windows,
        },
        .optimize = optimize,
    });

    lib.addSystemIncludePath(.{ .path = "deps/node-v18.17.0/include/node" });

    lib.addObjectFile(.{ .path = "deps/node-v18.17.0/win-x64/node.lib" });

    const install_lib = b.addInstallArtifact(lib, .{
        .dest_sub_path = name ++ ".node",
    });
    b.getInstallStep().dependOn(&install_lib.step);
}
