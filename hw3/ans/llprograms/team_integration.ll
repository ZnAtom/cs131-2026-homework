; Expected exit status: 16. Double and sum the positive values: 2 + 6 + 8.
; Covers an array, dynamic GEP, a loop, conditional branches and helper calls.
@values = global [4 x i64] [i64 1, i64 -2, i64 3, i64 4]

define i64 @double(i64 %x) {
  %answer = add i64 %x, %x
  ret i64 %answer
}

define i64 @sum_positive([4 x i64]* %values) {
  %i_addr = alloca i64
  %sum_addr = alloca i64
  store i64 0, i64* %i_addr
  store i64 0, i64* %sum_addr
  br label %loop
loop:
  %i = load i64, i64* %i_addr
  %done = icmp eq i64 %i, 4
  br i1 %done, label %exit, label %check
check:
  %slot = getelementptr [4 x i64], [4 x i64]* %values, i64 0, i64 %i
  %value = load i64, i64* %slot
  %positive = icmp sgt i64 %value, 0
  br i1 %positive, label %body, label %skip
body:
  %twice = call i64 @double(i64 %value)
  %sum_body = load i64, i64* %sum_addr
  %updated = add i64 %sum_body, %twice
  store i64 %updated, i64* %sum_addr
  %next = add i64 %i, 1
  store i64 %next, i64* %i_addr
  br label %loop
skip:
  %next_skip = add i64 %i, 1
  store i64 %next_skip, i64* %i_addr
  br label %loop
exit:
  %sum_final = load i64, i64* %sum_addr
  ret i64 %sum_final
}

define i64 @main(i64 %argc, i8** %argv) {
  %result = call i64 @sum_positive([4 x i64]* @values)
  ret i64 %result
}
