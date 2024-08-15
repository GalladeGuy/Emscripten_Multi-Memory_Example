# WebAssembly Multi-Memory Example

This is an example project that uses the WebAssembly multi-memory proposal with Emscripten.
The primary module (built with Emscripten) defines a second, shared linear memory.
After reading a counter from the shared memory, it calls a function in the secondary module (assembled from external.wat)
to increment the counter, and repeats.

You can also call `Module.wasmExports.test()` and `Module.externalModule.exports.update()`
yourself from the browser's developer console to see it working manually.
`test()` returns the value of the counter multiplied by 3, and `update()` increments the counter by 1.

## Dependencies

To build and run this project, you'll need:

- Emscripten (latest version recommended)
- CMake (version 3.10 or higher)

## Building

1. Clone this repository:
   ```
   git clone https://github.com/GalladeGuy/Emscripten_Multi-Memory_Example.git
   cd Emscripten_Multi-Memory_Example
   ```

2. Create a build directory and navigate to it:
   ```
   mkdir build
   cd build
   ```

3. Configure the project with CMake:
   ```
   path/to/emcmake cmake ..
   ```

4. Build the project:
   ```
   cmake --build .
   ```

## Running

1. Start a web server in the `bin` directory. For example, using Python:
   ```
   cd ../bin
   python -m http.server 8000
   ```

2. Open a web browser and navigate to `http://localhost:8000`

3. Open the browser's developer console to see the output of the program.
