; Fenwick Tree / BIT
@tree = global [16 x i64] [i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0]
@n = global i64 0

; =====================
; lb(i64) = i & -i
define i64 @lb(i64 %i) {
entry:
  %neg = sub i64 0, %i
  %res = and i64 %i, %neg
  ret i64 %res
}

define void @bit_add(i64 %i, i64 %a) {
entry:
  %nval = load i64, i64* @n
  %i_p = alloca i64
  store i64 %i, i64* %i_p
  br label %loop

loop:
  %ii = load i64, i64* %i_p
  %cond = icmp sle i64 %ii, %nval
  br i1 %cond, label %body, label %done

body:
  %iii = load i64, i64* %i_p
  %ptr = getelementptr [16 x i64], [16 x i64]* @tree, i64 0, i64 %iii
  %old = load i64, i64* %ptr
  %new = add i64 %old, %a
  store i64 %new, i64* %ptr

  %lb_val = call i64 @lb(i64 %iii)
  %next = add i64 %iii, %lb_val
  store i64 %next, i64* %i_p
  br label %loop

done:
  ret void
}

define i64 @bit_sum(i64 %r) {
entry:
  %res = alloca i64
  store i64 0, i64* %res
  %r_p = alloca i64
  store i64 %r, i64* %r_p
  br label %loop

loop:
  %rr = load i64, i64* %r_p
  %cond = icmp sgt i64 %rr, 0
  br i1 %cond, label %body, label %done

body:
  %rrr = load i64, i64* %r_p
  %ptr = getelementptr [16 x i64], [16 x i64]* @tree, i64 0, i64 %rrr
  %val = load i64, i64* %ptr
  %old = load i64, i64* %res
  %new = add i64 %old, %val
  store i64 %new, i64* %res

  %lb_val = call i64 @lb(i64 %rrr)
  %next = sub i64 %rrr, %lb_val
  store i64 %next, i64* %r_p
  br label %loop

done:
  %sum = load i64, i64* %res
  ret i64 %sum
}
define i64 @main() {
entry:
  store i64 10, i64* @n

  call void @bit_add(i64 1, i64 5)
  call void @bit_add(i64 2, i64 3)
  call void @bit_add(i64 3, i64 7)
  call void @bit_add(i64 5, i64 2)

  %sum0 = call i64 @bit_sum(i64 5)
  %sum1 = call i64 @bit_sum(i64 2)
  
  %sum = add i64 %sum0, %sum1
  ret i64 %sum
}

