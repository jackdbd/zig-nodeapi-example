# Zig Node-API example

[![Node-API - 9](https://img.shields.io/static/v1?label=Node-API&message=9&color=2ea44f)](https://nodejs.org/api/n-api.html)
[![CI Linux](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-linux.yaml/badge.svg)](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-linux.yaml)
[![CI MacOS](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-macos.yaml/badge.svg)](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-macos.yaml)
[![CI Windows](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-windows.yaml/badge.svg)](https://github.com/jackdbd/zig-nodeapi-example/actions/workflows/ci-windows.yaml)

<!-- Node-API badge generated here: https://michaelcurrin.github.io/badge-generator/#/ -->

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

Have a look at the [Node-API version matrix](https://nodejs.org/api/n-api.html#node-api-version-matrix) and decide which version of the Node-API you want to target, and what is the minimum Node.js version that uses that version of the Node-API. For example, Node-API version 9 is supported in Node.js v18.17.0+, 20.3.0+, 21.0.0 and all later versions.

> :warning: Node-API versions are additive and versioned independently from Node.js.

For example, let's say you want to target Node-API version 9. The minimum Node.js version that supports Node-API version 9 is 18.17.0. So, be sure to use Node.js when building and testing this native addon.

```sh
nvm install 18.17.0
nvm use 18.17.0
```

Double check your Node.js version:

```sh
node -v
```

## Compile for Linux

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

## Compile for Windows

Download the Node-API headers (if you haven't already) and both `node.exe` and `node.lib`:

```sh
./download-node-headers.sh
./download-node-exe-and-lib.sh
```

Compile for Windows x86_64:

```sh
zig build --build-file build-windows-x86-64.zig
```

Try a few examples:

```sh
NODE_SKIP_PLATFORM_CHECK=1 wine deps/node-v18.17.0/win-x64/node.exe examples/bare-minimum-win.cjs

NODE_SKIP_PLATFORM_CHECK=1 wine deps/node-v18.17.0/win-x64/node.exe examples/greet-win.cjs
```

> :warning: You need to set `NODE_SKIP_PLATFORM_CHECK=1` otherwise a Node.js check immediately stops the script execution.

## Credits

- [zig-nodejs-example](https://github.com/staltz/zig-nodejs-example)
- [tigerbeetle-node](https://github.com/tigerbeetle/tigerbeetle/tree/main/src/clients/node)
- [Cross compiling a Node.js addon for windows / macOS (ziggit.dev)](https://ziggit.dev/t/cross-compiling-a-node-js-addon-for-windows-macos/1935)
