(module
  (import "env" "memory1" (memory $mem1 1 2 shared))
  
  (func $test (result i32)
    (i32.store8 (i32.const 0) (i32.const 42))
    i32.const 7
  )
  (export "test" (func $test))
)
