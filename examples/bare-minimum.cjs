const addon = require("../dist/release/addon.node");

console.log("=== function with arity 0 ===");
console.log(addon.bare_minimum(123));
