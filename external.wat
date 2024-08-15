(module
  (import "env" "memory1" (memory $mem1 1 2 shared))

  (global $value (mut i32) (i32.const 1))

  (func $update
    (i32.store8 (i32.const 0) (global.get $value))
    (global.set $value (i32.add (global.get $value) (i32.const 1)))
  )

  (export "update" (func $update))
)