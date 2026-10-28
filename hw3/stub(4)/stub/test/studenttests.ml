open Util.Assert
open Gradedtests
open Ll

module Backend = Llbackend.Backend

let block insns term = { insns; term = ("term", term) }

let program params cfg =
  { tdecls = []; gdecls = []; edecls = [];
    fdecls = ["main", { f_ty = (List.map (fun _ -> I64) params, I64);
                        f_param = params; f_cfg = cfg }] }

let return_program insns result =
  program [] (block insns (Ret (I64, Some result)), [])

let run ast expected =
  assert_eqf (fun () -> exec_e2e_ast ast "" []) expected

(* Check the complete i64 result before converting it into an exit status. *)
let result_test name insns result expected =
  let insns = insns @ ["correct", Icmp (Eq, I64, result, Const expected)] in
  name, run (return_program insns (Id "correct")) 1L

let arithmetic_tests =
  [ result_test "i64 addition wraps"
      ["sum", Binop (Add, I64, Const Int64.max_int, Const 1L)]
      (Id "sum") Int64.min_int
  ; result_test "negative subtraction and local operand"
      ["x", Binop (Sub, I64, Const 2L, Const 9L);
       "y", Binop (Mul, I64, Id "x", Const (-3L))]
      (Id "y") 21L
  ; result_test "dynamic left shift"
      ["count", Binop (Add, I64, Const 30L, Const 33L);
       "shifted", Binop (Shl, I64, Const 1L, Id "count")]
      (Id "shifted") Int64.min_int
  ; result_test "logical right shift of negative number"
      ["shifted", Binop (Lshr, I64, Const (-8L), Const 2L)]
      (Id "shifted") 4611686018427387902L
  ; result_test "arithmetic right shift of negative number"
      ["shifted", Binop (Ashr, I64, Const (-8L), Const 2L)]
      (Id "shifted") (-2L)
  ; result_test "bitcast preserves every bit"
      ["cast", Bitcast (I64, Const Int64.min_int, Ptr I64);
       "back", Bitcast (Ptr I64, Id "cast", I64)]
      (Id "back") Int64.min_int
  ; result_test "null is zero"
      ["cast", Bitcast (Ptr I64, Null, I64)] (Id "cast") 0L
  ]

let comparison_tests =
  List.map
    (fun (name, condition, lhs, rhs, expected) ->
      result_test name ["cmp", Icmp (condition, I64, Const lhs, Const rhs)]
        (Id "cmp") expected)
    [ "eq true clears upper bytes", Eq, -1L, -1L, 1L
    ; "eq false clears upper bytes", Eq, -1L, 0L, 0L
    ; "ne true", Ne, -1L, 0L, 1L
    ; "ne false", Ne, -1L, -1L, 0L
    ; "slt signed overflow", Slt, Int64.min_int, Int64.max_int, 1L
    ; "slt equal", Slt, 7L, 7L, 0L
    ; "sle signed negative", Sle, -5L, -3L, 1L
    ; "sle equal", Sle, 7L, 7L, 1L
    ; "sgt signed overflow", Sgt, Int64.max_int, Int64.min_int, 1L
    ; "sgt false", Sgt, -5L, -3L, 0L
    ; "sge equal", Sge, -7L, -7L, 1L
    ; "sge false", Sge, -5L, -3L, 0L ]

let control_flow_tests =
  let diamond condition =
    program []
      (block [] (Cbr (Const condition, "yes", "no")),
       [ "no", block [] (Ret (I64, Some (Const 19L)))
       ; "yes", block [] (Br "finish")
       ; "finish", block ["answer", Binop (Add, I64, Const 20L, Const 22L)]
           (Ret (I64, Some (Id "answer"))) ])
  in
  [ "empty blocks and true branch", run (diamond 1L) 42L
  ; "empty blocks and false branch", run (diamond 0L) 19L
  ; "argc copied to its stack slot",
      run (program ["argc"; "argv"]
        (block [] (Ret (I64, Some (Id "argc"))), [])) 1L
  ; "global operand computes its address",
      run { (return_program
        ["same", Icmp (Eq, Ptr I64, Gid "value", Gid "value")]
        (Id "same")) with gdecls = ["value", (I64, GInt 23L)] } 1L
  ]

(* C generates the calls, so receiving stack arguments and ret void can be
   tested before the teammate implements LLVMlite Call. *)
let run_from_c declaration body expected =
  fun () ->
    let path = Filename.temp_file "hw3-params-" ".c" in
    Fun.protect ~finally:(fun () -> Sys.remove path)
      (fun () ->
        let channel = open_out path in
        Fun.protect ~finally:(fun () -> close_out channel)
          (fun () -> output_string channel body);
        let ast = { tdecls = []; gdecls = []; edecls = [];
                    fdecls = ["receive", declaration] } in
        assert_eqf (fun () -> exec_e2e_ast ast "" [path]) expected ())

let parameter_tests =
  [ "eight incoming arguments including two stack arguments",
      run_from_c
        { f_ty = (List.init 8 (fun _ -> I64), I64);
          f_param = ["a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"];
          f_cfg = (block
            ["left", Binop (Add, I64, Id "a", Id "g");
             "right", Binop (Add, I64, Id "f", Id "h");
             "answer", Binop (Add, I64, Id "left", Id "right")]
            (Ret (I64, Some (Id "answer"))), []) }
        "extern long receive(long,long,long,long,long,long,long,long);\nint main(void) { return receive(1,2,3,4,5,6,7,8); }\n"
        22L
  ; "empty void function restores the stack",
      run_from_c
        { f_ty = ([], Void); f_param = [];
          f_cfg = (block [] (Ret (Void, None)), []) }
        "extern void receive(void);\nint main(void) { receive(); return 7; }\n"
        7L ]

(* These tests are provided by you -- they will be graded manually *)

(* You should also add additional test cases here to help you   *)
(* debug your program.                                          *)

let provided_tests : suite =
  [ Test ("my part: arithmetic and bitcast", arithmetic_tests)
  ; Test ("my part: signed comparisons", comparison_tests)
  ; Test ("my part: branches and operands", control_flow_tests)
  ; Test ("my part: function entry and exit", parameter_tests)
  ]
