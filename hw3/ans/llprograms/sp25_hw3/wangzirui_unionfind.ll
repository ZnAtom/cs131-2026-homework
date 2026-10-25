; Union-Find Data Structure with Union by Size and Path Compression.

; If `fasiz[i]` is negative, then `i` is a root and `-fasiz[i]` is the size of
; the tree. Otherwise, `fasiz[i]` is the parent of `i`.
%arr_t = type [10 x i64]
@fasiz = global %arr_t [i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0]

; Initialize the union-find with `n` elements.
define void @dsu_init(i64 %n) {
  %i = alloca i64
  store i64 0, i64* %i
  br label %test

test:
  %i_val = load i64, i64* %i
  %t = icmp slt i64 %i_val, %n
  br i1 %t, label %body, label %end

body:
  %i_val2 = load i64, i64* %i
  %ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %i_val2
  store i64 -1, i64* %ptr
  %i_val3 = add i64 %i_val2, 1
  store i64 %i_val3, i64* %i
  br label %test

end:
  ret void
}

; Finds the root of `x`. This function is considered private and should not be
; called directly by users.
define i64 @dsu_find(i64 %x) {
  %ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %x
  %ptr_val = load i64, i64* %ptr
  %t = icmp slt i64 %ptr_val, 0
  br i1 %t, label %is_root, label %not_root

is_root:
  ret i64 %x

not_root:
  %fa = call i64 @dsu_find(i64 %ptr_val)
  store i64 %fa, i64* %ptr
  ret i64 %fa
}

; If `x` and `y` are in different sets, merges the two sets and returns 1.
; Otherwise, do nothing and returns 0.
define i64 @dsu_union(i64 %x, i64 %y) {
  %fx = call i64 @dsu_find(i64 %x)
  %fy = call i64 @dsu_find(i64 %y)

  %t = icmp eq i64 %fx, %fy
  br i1 %t, label %same, label %diff

same:
  ret i64 0

diff:
  %fx_ptr = alloca i64
  %fy_ptr = alloca i64

  store i64 %fx, i64* %fx_ptr
  store i64 %fy, i64* %fy_ptr

  %size_x_ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %fx
  %size_y_ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %fy

  %size_x = load i64, i64* %size_x_ptr
  %size_y = load i64, i64* %size_y_ptr

  %t2 = icmp slt i64 %size_x, %size_y
  br i1 %t2, label %x_bigger, label %y_bigger

y_bigger:
  ; `swap(fx, fy)`.
  %tmp1 = load i64, i64* %fx_ptr
  %tmp2 = load i64, i64* %fy_ptr
  store i64 %tmp2, i64* %fx_ptr
  store i64 %tmp1, i64* %fy_ptr
  br label %x_bigger

x_bigger:
  ; Union `fy` into `fx`.
  %fx_val = load i64, i64* %fx_ptr
  %fy_val = load i64, i64* %fy_ptr

  %fasiz_fx_ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %fx_val
  %fasiz_fy_ptr = getelementptr %arr_t, %arr_t* @fasiz, i64 0, i64 %fy_val

  %fasiz_fx_val = load i64, i64* %fasiz_fx_ptr
  %fasiz_fy_val = load i64, i64* %fasiz_fy_ptr

  %new_size = add i64 %fasiz_fx_val, %fasiz_fy_val
  store i64 %new_size, i64* %fasiz_fx_ptr

  store i64 %fx_val, i64* %fasiz_fy_ptr

  ret i64 1
}

; Checks whether `x` and `y` are in the same set.
define i1 @dsu_same(i64 %x, i64 %y) {
  %fx = call i64 @dsu_find(i64 %x)
  %fy = call i64 @dsu_find(i64 %y)
  %t = icmp eq i64 %fx, %fy
  ret i1 %t
}

; Returns 0 if passed.
define i64 @test() {
  call void @dsu_init(i64 10)
  br label %step1

step1:
  ; `dsu_same(1, 2)` should be false.
  %resp1 = call i1 @dsu_same(i64 1, i64 2)
  %t1 = icmp eq i1 %resp1, 0
  br i1 %t1, label %step2, label %fail

step2:
  ; `dsu_union(1, 2)` should be true.
  %resp2 = call i64 @dsu_union(i64 1, i64 2)
  %t2 = icmp eq i64 %resp2, 1
  br i1 %t2, label %step3, label %fail

step3:
  ; `dsu_same(1, 2)` should be true.
  %resp3 = call i1 @dsu_same(i64 1, i64 2)
  %t3 = icmp eq i1 %resp3, 1
  br i1 %t3, label %step4, label %fail

step4:
  ; `dsu_union(3, 4)` should be true.
  %resp4 = call i64 @dsu_union(i64 3, i64 4)
  %t4 = icmp eq i64 %resp4, 1
  br i1 %t4, label %step5, label %fail

step5:
  ; `dsu_same(1, 4)` should be false.
  %resp5 = call i1 @dsu_same(i64 1, i64 4)
  %t5 = icmp eq i1 %resp5, 0
  br i1 %t5, label %step6, label %fail

step6:
  ; `dsu_union(2, 3)` should be true.
  %resp6 = call i64 @dsu_union(i64 2, i64 3)
  %t6 = icmp eq i64 %resp6, 1
  br i1 %t6, label %step7, label %fail

step7:
  ; `dsu_union(2, 3)` should be false.
  %resp7 = call i64 @dsu_union(i64 2, i64 3)
  %t7 = icmp eq i64 %resp7, 0
  br i1 %t7, label %step8, label %fail

step8:
  ; `dsu_same(1, 4)` should be true.
  %resp8 = call i1 @dsu_same(i64 1, i64 4)
  %t8 = icmp eq i1 %resp8, 1
  br i1 %t8, label %pass, label %fail

pass:
  ret i64 0

fail:
  ret i64 1
}


define i64 @main(i64 %argc, i8** %arcv) {
  %resp = call i64 @test()
  ret i64 %resp
}

