const addon = require("../zig-out/lib/addon.node");

console.log("=== function with arity 0 ===");
console.log(addon.bare_minimum(123));
