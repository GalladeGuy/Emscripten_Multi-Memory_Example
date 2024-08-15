#include <stdio.h>


/*__attribute__((import_name("test"))) __attribute__((import_module("env"))) extern int test_inner();
int test() {
    return test_inner();
}*/
__attribute__((import_name("test"))) __attribute__((import_module("env"))) extern int test();

int main() {
    const int result = test();
    printf("Result from test() is %d\n", result);
    return 0;
}