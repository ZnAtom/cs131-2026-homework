; Student Test Case: Matrix Operations with Nested Structures
; This test demonstrates:
; 1. Structured data types (nested structs and arrays)
; 2. Non-trivial control flow (loops and conditionals)
; 3. Helper functions (call instructions)
; 4. Complex getelementptr usage

%struct.Matrix = type { i64, i64, [3 x [3 x i64]] }
%struct.Point = type { i64, i64 }
%struct.Container = type { %struct.Point, %struct.Matrix* }

@global_matrix = global %struct.Matrix {
    i64 3,
    i64 3,
    [3 x [3 x i64]] [
        [3 x i64] [i64 1, i64 2, i64 3],
        [3 x i64] [i64 4, i64 5, i64 6],
        [3 x i64] [i64 7, i64 8, i64 9]
    ]
}

@global_container = global %struct.Container {
    %struct.Point { i64 0, i64 0 },
    %struct.Matrix* @global_matrix
}

; Helper function: calculate sum of two numbers
define i64 @add_helper(i64 %a, i64 %b) {
entry:
    %sum = add i64 %a, %b
    ret i64 %sum
}

; Helper function: multiply two numbers
define i64 @multiply_helper(i64 %a, i64 %b) {
entry:
    %product = mul i64 %a, %b
    ret i64 %product
}

; Helper function: get matrix element at position (row, col)
define i64 @get_matrix_element(i64 %row, i64 %col) {
entry:
    ; Access nested array within struct using complex GEP
    %elem_ptr = getelementptr %struct.Matrix, %struct.Matrix* @global_matrix, i64 0, i32 2, i64 %row, i64 %col
    %elem = load i64, i64* %elem_ptr
    ret i64 %elem
}

; Main function: compute sum of diagonal elements with conditional processing
define i64 @main() {
entry:
    ; Initialize loop counter and accumulator
    %sum_ptr = alloca i64
    store i64 0, i64* %sum_ptr
    %i_ptr = alloca i64
    store i64 0, i64* %i_ptr
    
    ; Get matrix dimensions from global struct
    %rows_ptr = getelementptr %struct.Matrix, %struct.Matrix* @global_matrix, i64 0, i32 0
    %rows = load i64, i64* %rows_ptr
    
    br label %loop_cond

loop_cond:
    %i = load i64, i64* %i_ptr
    %cmp = icmp slt i64 %i, %rows
    br i1 %cmp, label %loop_body, label %loop_exit

loop_body:
    ; Get diagonal element (i, i)
    %elem = call i64 @get_matrix_element(i64 %i, i64 %i)
    
    ; Check if element is even or odd
    %mod = srem i64 %elem, 2
    %is_even = icmp eq i64 %mod, 0
    br i1 %is_even, label %even_branch, label %odd_branch

even_branch:
    ; For even elements, multiply by 2
    %even_result = call i64 @multiply_helper(i64 %elem, i64 2)
    br label %merge

odd_branch:
    ; For odd elements, add 10
    %odd_result = call i64 @add_helper(i64 %elem, i64 10)
    br label %merge

merge:
    ; Phi node to merge values from different branches
    %processed_val = phi i64 [ %even_result, %even_branch ], [ %odd_result, %odd_branch ]
    
    ; Add to sum
    %current_sum = load i64, i64* %sum_ptr
    %new_sum = call i64 @add_helper(i64 %current_sum, i64 %processed_val)
    store i64 %new_sum, i64* %sum_ptr
    
    ; Increment loop counter
    %next_i = add i64 %i, 1
    store i64 %next_i, i64* %i_ptr
    br label %loop_cond

loop_exit:
    ; Access point coordinates from nested struct
    %point_x_ptr = getelementptr %struct.Container, %struct.Container* @global_container, i64 0, i32 0, i32 0
    %point_x = load i64, i64* %point_x_ptr
    
    ; Add point coordinate to final result
    %final_sum = load i64, i64* %sum_ptr
    %result = call i64 @add_helper(i64 %final_sum, i64 %point_x)
    
    ret i64 %result
}
