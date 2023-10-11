const addon = require("../dist/debug/addon.node");
// const addon = require("../dist/release/addon.node");

console.log("\n=== function with arity 2 ===");

// no args
// console.log(addon.greet());

// incorrect number of args
// console.log(addon.greet("John", 123, 456));

// incorrect argument
// console.log(addon.greet(123));

// correct invocation
console.log(addon.greet("John Smith", 123));

// index out of bounds because the input string is longer than the size of the
// memory buffer we set in addon.zig (we allow 32 chars)
// console.log(addon.greet("This string is longer than the buffer", 123));
