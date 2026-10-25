%point = type { i64, i64 }
%points = type [ 6 x %point ]
@input_points = global %points [ %point {i64 3, i64 3}, %point {i64 6, i64 1}, %point {i64 1, i64 0}, %point {i64 100, i64 0}, %point {i64 2, i64 0}, %point {i64 1, i64 2} ]

define i64 @main (i64 %argc, i8** %argv)
{
  %count = alloca i64
  store i64 0, i64* %count
  %i = alloca i64
  store i64 0, i64* %i
  
  br label %loop_cond
  
  ; get every point in input_points
  loop_cond:
    %i_val = load i64, i64* %i
    %cond = icmp slt i64 %i_val, 6
    br i1 %cond, label %loop_body, label %loop_end
    
  loop_body:
    %point_ptr = getelementptr %points, %points* @input_points, i64 0, i64 %i_val
  
    %distance = call i64 @distance_to_origin(%point %point_ptr)
  
    %is_less_than_4 = icmp slt i64 %distance, 4
    br i1 %is_less_than_4, label %got_one_point, label %next_iter
    
  got_one_point:
    %current_count = load i64, i64* %count
    %new_count = add i64 %current_count, 1
    store i64 %new_count, i64* %count
    br label %next_iter

  next_iter:
    %next_i = add i64 %i_val, 1
    store i64 %next_i, i64* %i
    br label %loop_cond
  
  loop_end:
    %result = load i64, i64* %count
    ret i64 %result
}

define i64 @distance_to_origin (%point* %t)
{
  ; return distance to (0, 0)
  %x_ptr = getelementptr %point, %point* %t, i64 0, i32 0
  %x = load i64, i64* %x_ptr
  
  %y_ptr = getelementptr %point, %point* %t, i64 0, i32 1
  %y = load i64, i64* %y_ptr
  
  %distance = add i64 %x, %y
  ret i64 %distance
}


