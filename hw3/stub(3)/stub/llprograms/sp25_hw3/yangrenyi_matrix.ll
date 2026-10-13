; Matrix Operations

; Define row type and matrix data type separately for LLVMlite
%Row = type [3 x i64]
%MatrixData = type [3 x %Row]
%Matrix3x3 = type { i64, i64, %MatrixData }

; Global matrix initialized with some values
@matrix = global %Matrix3x3 { 
  i64 3, 
  i64 3, 
  %MatrixData [
    %Row [ i64 1, i64 2, i64 3 ],
    %Row [ i64 4, i64 5, i64 6 ],
    %Row [ i64 7, i64 8, i64 9 ]
  ]
}

; Helper function 1: Get element at position (row, col)
define i64 @get_element(%Matrix3x3* %mat, i64 %row, i64 %col) {
  %data_ptr = getelementptr %Matrix3x3, %Matrix3x3* %mat, i32 0, i32 2
  %row_ptr = getelementptr %MatrixData, %MatrixData* %data_ptr, i32 0, i64 %row
  %elem_ptr = getelementptr %Row, %Row* %row_ptr, i32 0, i64 %col
  %value = load i64, i64* %elem_ptr
  ret i64 %value
}

; Helper function 2: Set element at position (row, col)
define void @set_element(%Matrix3x3* %mat, i64 %row, i64 %col, i64 %value) {
  %data_ptr = getelementptr %Matrix3x3, %Matrix3x3* %mat, i32 0, i32 2
  %row_ptr = getelementptr %MatrixData, %MatrixData* %data_ptr, i32 0, i64 %row
  %elem_ptr = getelementptr %Row, %Row* %row_ptr, i32 0, i64 %col
  store i64 %value, i64* %elem_ptr
  ret void
}

; Helper function 3: Calculate sum of diagonal elements
define i64 @sum_diagonal(%Matrix3x3* %mat) {
entry:
  %sum_ptr = alloca i64
  store i64 0, i64* %sum_ptr
  
  %i_ptr = alloca i64
  store i64 0, i64* %i_ptr
  br label %loop_check

loop_check:
  %i = load i64, i64* %i_ptr
  %continue = icmp slt i64 %i, 3
  br i1 %continue, label %loop_body, label %loop_end

loop_body:
  ; Get diagonal element at (i, i)
  %elem = call i64 @get_element(%Matrix3x3* %mat, i64 %i, i64 %i)
  
  ; Add to sum
  %current_sum = load i64, i64* %sum_ptr
  %new_sum = add i64 %current_sum, %elem
  store i64 %new_sum, i64* %sum_ptr
  
  ; Increment counter
  %next_i = add i64 %i, 1
  store i64 %next_i, i64* %i_ptr
  br label %loop_check

loop_end:
  %result = load i64, i64* %sum_ptr
  ret i64 %result
}

; Helper function 4: Count elements greater than threshold
define i64 @count_above_threshold(%Matrix3x3* %mat, i64 %threshold) {
entry:
  %count_ptr = alloca i64
  store i64 0, i64* %count_ptr
  
  %row_ptr = alloca i64
  store i64 0, i64* %row_ptr
  br label %row_loop

row_loop:
  %row = load i64, i64* %row_ptr
  %row_done = icmp slt i64 %row, 3
  br i1 %row_done, label %row_body, label %done

row_body:
  %col_ptr = alloca i64
  store i64 0, i64* %col_ptr
  br label %col_loop

col_loop:
  %col = load i64, i64* %col_ptr
  %col_done = icmp slt i64 %col, 3
  br i1 %col_done, label %col_body, label %row_increment

col_body:
  ; Get current element
  %value = call i64 @get_element(%Matrix3x3* %mat, i64 %row, i64 %col)
  
  ; Check if greater than threshold
  %is_greater = icmp sgt i64 %value, %threshold
  br i1 %is_greater, label %increment_count, label %col_increment

increment_count:
  %current_count = load i64, i64* %count_ptr
  %new_count = add i64 %current_count, 1
  store i64 %new_count, i64* %count_ptr
  br label %col_increment

col_increment:
  %next_col = add i64 %col, 1
  store i64 %next_col, i64* %col_ptr
  br label %col_loop

row_increment:
  %next_row = add i64 %row, 1
  store i64 %next_row, i64* %row_ptr
  br label %row_loop

done:
  %final_count = load i64, i64* %count_ptr
  ret i64 %final_count
}

; Helper function 5: Apply transformation (multiply by factor if even, add offset if odd)
define void @transform_matrix(%Matrix3x3* %mat, i64 %factor, i64 %offset) {
entry:
  %row_ptr = alloca i64
  store i64 0, i64* %row_ptr
  br label %row_loop

row_loop:
  %row = load i64, i64* %row_ptr
  %row_continue = icmp slt i64 %row, 3
  br i1 %row_continue, label %row_body, label %done

row_body:
  %col_ptr = alloca i64
  store i64 0, i64* %col_ptr
  br label %col_loop

col_loop:
  %col = load i64, i64* %col_ptr
  %col_continue = icmp slt i64 %col, 3
  br i1 %col_continue, label %col_body, label %row_next

col_body:
  ; Get current value
  %old_value = call i64 @get_element(%Matrix3x3* %mat, i64 %row, i64 %col)
  
  ; Check if even or odd
  %mod_bit = and i64 %old_value, 1
  %is_even = icmp eq i64 %mod_bit, 0
  br i1 %is_even, label %multiply, label %add_offset

multiply:
  %multiplied = mul i64 %old_value, %factor
  call void @set_element(%Matrix3x3* %mat, i64 %row, i64 %col, i64 %multiplied)
  br label %col_next

add_offset:
  %added = add i64 %old_value, %offset
  call void @set_element(%Matrix3x3* %mat, i64 %row, i64 %col, i64 %added)
  br label %col_next

col_next:
  %next_col = add i64 %col, 1
  store i64 %next_col, i64* %col_ptr
  br label %col_loop

row_next:
  %next_row = add i64 %row, 1
  store i64 %next_row, i64* %row_ptr
  br label %row_loop

done:
  ret void
}

; Main function
define i64 @main(i64 %argc, i8** %argv) {
entry:
  ; Allocate local matrix copy
  %local_mat = alloca %Matrix3x3
  
  ; Allocate stack variable for results
  %result_ptr = alloca i64
  
  ; Copy dimensions from global matrix
  %global_rows_ptr = getelementptr %Matrix3x3, %Matrix3x3* @matrix, i32 0, i32 0
  %rows = load i64, i64* %global_rows_ptr
  %local_rows_ptr = getelementptr %Matrix3x3, %Matrix3x3* %local_mat, i32 0, i32 0
  store i64 %rows, i64* %local_rows_ptr
  
  ; Test 1: Get initial diagonal sum from global matrix
  %initial_diag_sum = call i64 @sum_diagonal(%Matrix3x3* @matrix)
  
  ; Test 2: Count elements > 5 in global matrix
  %count_above_5 = call i64 @count_above_threshold(%Matrix3x3* @matrix, i64 5)
  
  ; Test 3: Get specific elements and perform operations
  %elem_0_0 = call i64 @get_element(%Matrix3x3* @matrix, i64 0, i64 0)
  %elem_2_2 = call i64 @get_element(%Matrix3x3* @matrix, i64 2, i64 2)
  %corner_sum = add i64 %elem_0_0, %elem_2_2
  
  ; Test 4: Conditional branch based on corner sum
  %is_corner_sum_large = icmp sgt i64 %corner_sum, 8
  br i1 %is_corner_sum_large, label %large_corner, label %small_corner

large_corner:
  %adjusted_1 = sub i64 %corner_sum, 3
  store i64 %adjusted_1, i64* %result_ptr
  br label %after_corner_check

small_corner:
  %adjusted_2 = add i64 %corner_sum, 5
  store i64 %adjusted_2, i64* %result_ptr
  br label %after_corner_check

after_corner_check:
  %corner_result = load i64, i64* %result_ptr
  
  ; Test 5: Apply transformation to global matrix
  call void @transform_matrix(%Matrix3x3* @matrix, i64 2, i64 10)
  
  ; Test 6: Get new diagonal sum after transformation
  %new_diag_sum = call i64 @sum_diagonal(%Matrix3x3* @matrix)
  
  ; Test 7: Calculate difference
  %diag_diff = sub i64 %new_diag_sum, %initial_diag_sum
  
  ; Test 8: Complex arithmetic combining all results
  ; Formula: (diag_diff * count_above_5) + corner_result
  %product = mul i64 %diag_diff, %count_above_5
  %sum = add i64 %product, %corner_result
  
  store i64 %sum, i64* %result_ptr
  %result = load i64, i64* %result_ptr
  ret i64 %result
}
