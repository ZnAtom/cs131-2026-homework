open Util.Assert
open Gradedtests

(* These tests are provided by you -- they will be graded manually *)

(* You should also add additional test cases here to help you   *)
(* debug your program.                                          *)

let provided_tests : suite =
  [ Test
      ( "submitted integration tests"
      , executed
          [ "llprograms/team_integration.ll", 16L
          ; "llprograms/ring_buffer_replay.ll", 100L
          ] )
  ]
;;
