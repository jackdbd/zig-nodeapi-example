const std = @import("std");
const assert = std.debug.assert;
const c = @import("c.zig");

// https://nodejs.org/api/n-api.html#napi_status
// pub const Status = enum(u5) {
//     ok = c.napi_ok,
//     invalid_arg = c.napi_invalid_arg,
//     object_expected = c.napi_object_expected,
//     string_expected = c.napi_string_expected,
//     // etc
// };

pub fn create_string(env: c.napi_env, value: [:0]const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    if (c.napi_create_string_utf8(env, value, value.len, &result) != c.napi_ok) {
        return throw(env, "Failed to create string");
    }

    return result;
}

pub fn register_function(
    env: c.napi_env,
    exports: c.napi_value,
    comptime name: [:0]const u8,
    function: *const fn (env: c.napi_env, info: c.napi_callback_info) callconv(.C) c.napi_value,
) !void {
    var napi_function: c.napi_value = undefined;
    if (c.napi_create_function(env, null, 0, function, null, &napi_function) != c.napi_ok) {
        return throw(env, "Failed to create function " ++ name ++ "().");
    }

    if (c.napi_set_named_property(env, exports, @as([*c]const u8, @ptrCast(name)), napi_function) != c.napi_ok) {
        return throw(env, "Failed to add " ++ name ++ "() to exports.");
    }
}

const TranslationError = error{ExceptionThrown};

pub fn throw(env: c.napi_env, comptime message: [:0]const u8) TranslationError {
    // https://nodejs.org/api/n-api.html#napi_throw_error
    var result = c.napi_throw_error(env, null, @as([*c]const u8, @ptrCast(message)));
    switch (result) {
        c.napi_ok, c.napi_pending_exception => {},
        else => unreachable,
    }

    return TranslationError.ExceptionThrown;
}
