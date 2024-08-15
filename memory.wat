(module
  (import "env" "memory1" (memory $mem1 1 2 shared))
  
  (func $test (result i32)
    (local $value i32)
    (local.set $value (i32.load8_u (i32.const 0)))
    (i32.mul (local.get $value) (i32.const 3))
  )
  (export "test" (func $test))
)