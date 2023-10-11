# Zig Node-API example

Minimal repo to show how to create a Node.js native addon using Zig and the [Node-API](https://nodejs.org/api/n-api.html#node-api).

## Instructions

Use [zigup](https://github.com/marler8997/zigup) to download and fetch the latest Zig compiler:

```sh
zigup fetch master
zigup default master
```

Double check your Zig version:

```sh
zig version
```

Have a look at the [Node-API version matrix](Node-API version matrix) and decide which version of the Node-API you want to target, and what is the minimum Node.js version that uses that version of the Node-API. For example, Node-API version 9 is supported in Node.js v18.17.0+, 20.3.0+, 21.0.0 and all later versions. Remember: Node-API versions are additive and versioned independently from Node.js.

```sh
nvm install 18.17.0
nvm use 18.17.0
```

Double check your Node.js version:

```sh
node -v
```

Download the Node-API headers:

```sh
./download-node-headers.sh
# or zig build download-node-headers
```

Build the native addon using `zig build-lib` (both in [Debug](https://ziglang.org/documentation/master/#Debug) mode and in [ReleaseFast](ReleaseFast) mode):

```sh
npm run build
```

In alternative, you can build the native addon using `build.zig`:

```sh
zig build
mkdir -p dist/debug && mv zig-out/lib/libaddon.so dist/debug/addon.node

zig build -Doptimize=ReleaseFast
mkdir -p dist/release && mv zig-out/lib/libaddon.so dist/release/addon.node
```

Run all tests:

```sh
npm test
```

Try a few examples:

```sh
npm run example:bare-minimum
npm run example:greet
```

## Credits

- [zig-nodejs-example](https://github.com/staltz/zig-nodejs-example)
- [tigerbeetle-node](https://github.com/tigerbeetle/tigerbeetle/tree/main/src/clients/node)
