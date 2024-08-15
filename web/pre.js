var wasmMemory1 = new WebAssembly.Memory({
    initial: 1,
    maximum: 2,
    shared: true
});
Module["wasmMemory1"] = wasmMemory1;

WebAssembly.instantiateStreaming(fetch('external.wasm'), {
    env: {
        memory1: wasmMemory1
    }
}).then(function(result) {
    Module["externalModule"] = result.instance;
});