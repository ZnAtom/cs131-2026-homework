(* HW3 2025 Student Test Cases *)

let dir = "llprograms/sp25_hw3/"

(* Test cases that don't use any IO.

   - These test cases consist of a single `.ll` file with the standard "main"
     entry point.

   ```
   define i64 @main(i64 %argc, i8** %arcv) {
    %res = ...
    ret i64 %res
   }
   ```
   - each test's name will be expanded to: "llprograms/sp25_hw3/<name>.ll"

   - each test should specify the expected result (which will be returned by
     executing the compiled ll program)

   To add a new test case in this style:

   - create the test program `llprograms/sp25_hw3/<name>.ll`
   - add "<name>", resL to the list of tests below

   - we have given you the `add.ll` test case as an example
*)
let tests =
  List.map (fun (name, output) -> (dir ^ name ^ ".ll", output)) [
    "yangrenyi_matrix", 127L;      (* yang_ren_yi - complex matrix operations with structs and GEP *)
    "yangrenyi_array", 48L;        (* yang_ren_yi - array operations with nested structs *)
    "wangzirui_unionfind", 0L;     (* wang_zi_rui - union-find data structure with recursion *)
    "wangwenhao_gcd", 6L;          (* wang_wen_hao - GCD algorithm with loops *)
    "wangwenhao_distance", 3L;     (* wang_wen_hao - distance calculation *)
    "maruize_fenwick", 25L;        (* ma_rui_ze - fenwick tree data structure *)
    (* "tang_matrix_ops", 40L;        (* tang - complex matrix operations with nested structs *), not used because of errors in the test case *)
  ]
