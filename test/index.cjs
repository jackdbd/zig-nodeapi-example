const test = require("node:test");
const assert = require("node:assert").strict;
const { bare_minimum, greet } = require("../dist/release/addon.node");

test("bare_minimum() returns the expected string", (t) => {
  const s = bare_minimum();
  assert.strictEqual(s, "Hi from the native addon!");
});

test("greet() throws when no arguments are passed in", (t) => {
  assert.throws(() => {
    greet();
  });
  // try {
  //   greet();
  // } catch (err) {
  //   assert.strictEqual(
  //     err.message,
  //     "Function greet() requires exactly 2 arguments."
  //   );
  // }
});

test("greet() throws when first argument is not a string", (t) => {
  assert.throws(() => {
    greet(123);
  });
});

test("greet() throws when too many arguments are passed in", (t) => {
  assert.throws(() => {
    greet("Huey", "Dewey", "Louie");
  });
});

test("greet() returns the expected string when passed in a string and a number", (t) => {
  const s = greet("John Doe", 123);
  assert.strictEqual(s, "John Doe hi");
});
