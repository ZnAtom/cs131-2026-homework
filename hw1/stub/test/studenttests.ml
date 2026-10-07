open Util.Assert
open Hellocaml

(* These tests are provided by you -- they will be graded manually *)

(* You should also add additional test cases here to help you   *)
(* debug your program.                                          *)

let student_tests : suite =
  [
    Test
      ( "Student-Provided Tests For Problem 1-3",
        [
          ("case1", assert_eqf (fun () -> 42) prob3_ans);
          ("case2", assert_eqf (fun () -> 25) (prob3_case2 17));
          ("case3", assert_eqf (fun () -> prob3_case3) 64);
        ] );
    Test
      ( "Student-Provided Tests For Problem 4-3",
        [
          ("case 1", assert_eqf (fun () -> interpret [] (Const 42L)) 42L);
          ("case 2", assert_eqf (fun () -> interpret [] (Neg (Const 5L))) (-5L));
          ( "case 3",
            assert_eqf (fun () -> interpret [] (Add (Const 10L, Const 5L))) 15L
          );
          ( "case 4",
            assert_eqf (fun () -> interpret [] (Mult (Const 10L, Const 5L))) 50L
          );
          ( "case 5",
            assert_eqf (fun () -> interpret [ ("x", 10L) ] (Var "x")) 10L );
          ( "case 6",
            assert_eqf
              (fun () ->
                interpret [] (Add (Mult (Const 2L, Const 3L), Neg (Const 4L))))
              2L );
          ( "case 7",
            assert_eqf
              (fun () ->
                interpret
                  [ ("x", 2L); ("y", 3L) ]
                  (Add (Mult (Var "x", Var "y"), Neg (Const 4L))))
              2L );
          ( "lookup4",
            fun () ->
              try
                ignore (lookup "y" ctxt1);
                failwith "bad lookup"
              with Not_found -> () );
          ( "case 8",
            fun () ->
              try
                ignore
                  (interpret
                     [ ("x", 10L) ]
                     (Add (Mult (Var "x", Var "y"), Neg (Const 4L))));
                failwith "bad lookup"
              with Not_found -> () );
        ] );
    Test
      ( "Student-Provided Tests For Problem 5",
        [
          ("case 1", assert_eqf (fun () -> compile (Const 42L)) [ IPushC 42L ]);
          ("case 2", assert_eqf (fun () -> compile (Var "x")) [ IPushV "x" ]);
          ( "case 3",
            assert_eqf
              (fun () -> compile (Add (Const 1L, Const 2L)))
              [ IPushC 1L; IPushC 2L; IAdd ] );
          ( "case 4",
            assert_eqf
              (fun () -> compile (Mult (Const 2L, Const 3L)))
              [ IPushC 2L; IPushC 3L; IMul ] );
          ( "case 5",
            assert_eqf (fun () -> compile (Neg (Const 5L))) [ IPushC 5L; INeg ]
          );
          ( "case 6",
            assert_eqf
              (fun () ->
                let e = Add (Mult (Const 2L, Const 3L), Neg (Const 4L)) in
                run [] (compile e))
              (interpret [] (Add (Mult (Const 2L, Const 3L), Neg (Const 4L))))
          );
          ( "case 7",
            assert_eqf
              (fun () -> run [] (compile (Neg (Neg (Const 5L)))))
              (interpret [] (Neg (Neg (Const 5L)))) );
          ( "case 8",
            assert_eqf
              (fun () ->
                let e = Add (Mult (Var "x", Const 10L), Neg (Const 5L)) in
                run [ ("x", 5L) ] (compile e))
              (interpret
                 [ ("x", 5L) ]
                 (Add (Mult (Var "x", Const 10L), Neg (Const 5L)))) );
        ] );
  ]
