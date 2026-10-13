define i64 @gcd(i64 %a, i64 %b) {
entry:
  %pa = alloca i64
  %pb = alloca i64
  store i64 %a, i64* %pa
  store i64 %b, i64* %pb
  br label %loop

loop:
  %va = load i64, i64* %pa
  %vb = load i64, i64* %pb
  ; if vb == 0 -> return va
  %vb_zero = icmp eq i64 %vb, 0
  br i1 %vb_zero, label %ret_a, label %check_va

check_va:
  ; if va == 0 -> return vb
  %va_zero = icmp eq i64 %va, 0
  br i1 %va_zero, label %ret_b, label %check_eq

check_eq:
  ; if va == vb -> return va
  %eq = icmp eq i64 %va, %vb
  br i1 %eq, label %ret_a, label %compare

compare:
  %ge = icmp sge i64 %va, %vb
  br i1 %ge, label %suba, label %subb

suba:
  %va2 = load i64, i64* %pa
  %vb2 = load i64, i64* %pb
  %newa = sub i64 %va2, %vb2
  store i64 %newa, i64* %pa
  br label %loop

subb:
  %va3 = load i64, i64* %pa
  %vb3 = load i64, i64* %pb
  %newb = sub i64 %vb3, %va3
  store i64 %newb, i64* %pb
  br label %loop

ret_a:
  %res_a = load i64, i64* %pa
  ret i64 %res_a

ret_b:
  %res_b = load i64, i64* %pb
  ret i64 %res_b
}

define i64 @main(i64 %argc, i8** %argv) {
entry:
  %g = call i64 @gcd(i64 48, i64 18)
  ret i64 %g
}