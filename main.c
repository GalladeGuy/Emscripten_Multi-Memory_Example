#include <emscripten.h>
#include <stdio.h>


__attribute__((import_name("test"))) __attribute__((import_module("env"))) extern volatile int test();

int main() {
    for (int i = 0; i < 5; i++) {
        // Call test() and print the result (the external counter multiplied by 3)
        const int result = test();
        printf("Result from test() is %d\n", result);

        // Call update() from externalModule, incrementing the external counter
        EM_ASM(Module.externalModule.exports.update(););
    }
    return 0;
}