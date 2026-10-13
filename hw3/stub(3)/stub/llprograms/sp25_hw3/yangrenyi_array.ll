%Point_one = type { i64, i64 }
%Point = type [1 x %Point_one]

define i64 @calc_something(%Point* %s, i64 %val) {
entry:
  %x_ptr = getelementptr %Point, %Point* %s, i32 0, i32 0, i32 0
  %x_val = load i64, i64* %x_ptr
  %y_ptr = getelementptr %Point, %Point* %s, i32 0, i32 0, i32 1
  %y_val = load i64, i64* %y_ptr
  %sum = add i64 %x_val, %y_val
  %result = xor i64 %sum, %val
  ret i64 %result
}

;   循环 10 次 (i = 0 到 9)
;   在栈上分配一个 %Point 结构体 p
;   每次循环:
;     p.x = i
;     p.y = i * 2
;     if (i % 3 == 0):
;       acc = acc + calc_something(&p, i)
;   返回最终的 acc
define i64 @main(i64 %argc, i8** %arcv) {
entry:
  ; 在栈上为结构体和累加器分配空间
  %p_ptr = alloca %Point
  %acc_ptr = alloca i64
  
  %i_ptr = alloca i64

  ; 初始化累加器为 0
  store i64 0, i64* %acc_ptr
  
  ; 初始化 'i' 为 0 
  store i64 0, i64* %i_ptr
  
  ; 跳转到循环头
  br label %loop_header

loop_header:
  %i = load i64, i64* %i_ptr

  ; 循环退出条件: i < 10 
  %cmp_exit = icmp slt i64 %i, 10
  br i1 %cmp_exit, label %loop_body, label %loop_exit

loop_body:
  ; (循环体内部完全不变，它使用从 header 加载的 %i)
  %x_ptr = getelementptr %Point,  %Point* %p_ptr, i32 0, i32 0, i32 0
  store i64 %i, i64* %x_ptr

  %y_val = mul i64 %i, 2
  %y_ptr = getelementptr %Point, %Point* %p_ptr, i32 0, i32 0, i32 1
  store i64 %y_val, i64* %y_ptr

  ; 检查 %i == 0
  %cmp0 = icmp eq i64 %i, 0
  ; 检查 %i == 3
  %cmp3 = icmp eq i64 %i, 3
  ; 检查 %i == 6
  %cmp6 = icmp eq i64 %i, 6
  ; 检查 %i == 9
  %cmp9 = icmp eq i64 %i, 9
  
  ; 合并检查: (i==0 || i==3)
  %or1 = or i1 %cmp0, %cmp3
  ; 合并检查: (i==6 || i==9)
  %or2 = or i1 %cmp6, %cmp9
  %cmp_cond = or i1 %or1, %or2
  br i1 %cmp_cond, label %call_helper, label %skip_call

call_helper:
  %call_val = call i64 @calc_something(%Point* %p_ptr, i64 %i)
  %current_acc = load i64, i64* %acc_ptr
  %new_acc = add i64 %current_acc, %call_val
  store i64 %new_acc, i64* %acc_ptr
  br label %loop_latch

skip_call:
  br label %loop_latch

loop_latch:
  ;  i + 1
  %i_next = add i64 %i, 1
  ; 将新值存回 'i' 的内存地址
  store i64 %i_next, i64* %i_ptr
  
  ; 无条件跳转回循环头
  br label %loop_header

loop_exit:
  %final_val = load i64, i64* %acc_ptr
  ret i64 %final_val
}