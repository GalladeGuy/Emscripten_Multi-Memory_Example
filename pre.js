var wasmMemory1 = new WebAssembly.Memory({
    initial: 1,
    maximum: 2,
    shared: true
});
Module["wasmMemory1"] = wasmMemory1;