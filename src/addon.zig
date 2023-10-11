const std = @import("std");
const c = @import("c.zig");
const napi = @import("napi.zig");

fn bare_minimum(env: c.napi_env, cbinfo: c.napi_callback_info) callconv(.C) c.napi_value {
    _ = cbinfo;
    return napi.create_string(env, "Hi from the native addon!") catch return null;
}

// See this example
// https://github.com/tigerbeetle/tigerbeetle-node/blob/93139bdc6f2668d2cf1f50410cf52b5fb43ad5de/src/node.zig#L531

fn greet(env: c.napi_env, cbinfo: c.napi_callback_info) callconv(.C) c.napi_value {
    var argc: usize = 2; // The count of elements in the argv array
    var argv: [2]c.napi_value = undefined; // The array of arguments passed from JS

    // This method is used within a callback function to retrieve details about
    // the call like the arguments and the this pointer from a given callback info.
    // I don't know when and why this method could fail.
    // https://nodejs.org/api/n-api.html#napi_get_cb_info
    if (c.napi_get_cb_info(env, cbinfo, &argc, &argv, null, null) != c.napi_ok) {
        napi.throw(env, "Failed to get args and/or this pointer.") catch return null;
    }

    if (argc != 2) {
        napi.throw(
            env,
            "Function greet() requires exactly 2 arguments.",
        ) catch return null;
    }

    // Buffer to write the UTF8-encoded string into.
    var buffer: [32]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const memory = allocator.alloc(u8, buffer.len) catch return null;
    defer allocator.free(memory);

    std.log.debug("buffer allocated on the heap: {any}", .{buffer});

    // Number of bytes copied into the buffer, excluding the null terminator.
    var result: usize = undefined;

    // https://nodejs.org/api/n-api.html#napi_get_value_string_utf8
    // https://github.com/nodejs/node-addon-examples/issues/83
    // Returns napi_ok if the API succeeded. If a non-string napi_value is passed
    // in it returns napi_string_expected.
    // Copies UTF-8 encoded bytes from a string into a buffer.
    if (c.napi_get_value_string_utf8(env, argv[0], &buffer, buffer.len, &result) != c.napi_ok) {
        napi.throw(
            env,
            "argv[0] must be a string.",
        ) catch return null;
    }
    std.log.debug("napi_get_value_string_utf8 wrote {d} bytes to buffer: {s}", .{ result, buffer });

    // https://ziglang.org/documentation/0.10.0/#toc-Sentinel-Terminated-Slices
    const runtime_length: usize = result + 3;
    buffer[result] = 32; // space
    buffer[result + 1] = 104; // h
    buffer[result + 2] = 105; // i
    buffer[runtime_length] = 0;
    const slice = buffer[0..runtime_length :0];

    // in alternative, concat "hi " + buffer[0..result] using std.mem.copy
    // https://ziglang.org/documentation/master/#Memory

    std.log.debug("null terminated slice over buffer[0..{d}]: {s}", .{ runtime_length, slice });
    std.log.debug("null terminated slice over buffer[0..{d}]: {any}", .{ runtime_length, slice });

    // function defined in js_native_api.h
    // https://nodejs.org/api/n-api.html#napi_create_string_utf8
    return napi.create_string(env, slice) catch return null;
}

export fn napi_register_module_v1(env: c.napi_env, exports: c.napi_value) c.napi_value {
    napi.register_function(env, exports, "bare_minimum", bare_minimum) catch return null;
    napi.register_function(env, exports, "greet", greet) catch return null;
    return exports;
}
