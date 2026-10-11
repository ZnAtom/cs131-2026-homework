open Util.Assert
open X86
open Sim.Simulator
open Gradedtests
open Asm 
(* These tests are provided by you -- they will be graded manually *)

(* You should also add additional test cases here to help you   *)
(* debug your program.                                          *)


let test_my =
  let bin = [
    InsB0 (Movq, Asm.[ ~$42; ~%Rax ]);
    InsFrag;
    InsFrag;
    InsFrag;
    InsFrag;
    InsFrag;
    InsFrag;
    InsFrag;
    ] 
  
  in 

  let asm =  [gtext "main"
  [ 
    Movq,  [~$42; ~%Rax]];
  ] in 

  (assert_eqf (fun() ->  (assemble asm).text_seg) bin )

 
let mov_ri =
 test_machine
 [
 InsB0 (Movq, Asm.[ ~$42; ~%Rax ]);
 InsFrag;
 InsFrag;
 InsFrag;
 InsFrag;
 InsFrag;
 InsFrag;
 InsFrag;
 ]

let part1_machine instructions =
  test_machine (List.concat_map sbytes_of_ins instructions)

let expect_segfault f =
  try f (); failwith "expected X86lite_segfault"
  with X86lite_segfault -> ()

let part1_tests = [
  ("address boundaries", fun () ->
    assert_eq (map_addr mem_bot) (Some 0) ();
    assert_eq (map_addr (mem_top -. 1L)) (Some (mem_size - 1)) ();
    assert_eq (map_addr mem_top) None ();
    assert_eq (map_addr (mem_bot -. 1L)) None ());
  ("quad round trips and little endian", fun () ->
    let m = part1_machine [] in
    List.iter (fun value ->
      writequad m (mem_bot +. 3L) value;
      assert_eq (readquad m (mem_bot +. 3L)) value ()
    ) [0L; -1L; Int64.min_int; Int64.max_int; 0x0123456789abcdefL];
    assert_eq m.mem.(3) (Byte '\xef') ();
    assert_eq m.mem.(10) (Byte '\x01') ());
  ("invalid write preserves memory", fun () ->
    let m = part1_machine [] in
    let before = Array.copy m.mem in
    expect_segfault (fun () -> writequad m (mem_top -. 4L) (-1L));
    assert_eq m.mem before ());
  ("invalid quad read", fun () ->
    let m = part1_machine [] in
    expect_segfault (fun () -> ignore (readquad m (mem_top -. 7L))));
  ("lea computes address without reading memory", fun () ->
    let m = part1_machine [Leaq, [Ind3 (Lit 16L, Rbx); Reg Rax]] in
    m.regs.(rind Rbx) <- 0x123000L;
    step m;
    assert_eq m.regs.(rind Rax) 0x123010L ());
  ("set preserves upper register bytes", fun () ->
    let m = part1_machine [Set Eq, [Reg Rax]; Set Neq, [Reg Rax]] in
    m.regs.(rind Rax) <- 0x123456789abcdeffL;
    m.flags.fz <- true;
    step m;
    assert_eq m.regs.(rind Rax) 0x123456789abcde01L ();
    step m;
    assert_eq m.regs.(rind Rax) 0x123456789abcde00L ());
  ("set writes only one memory byte", fun () ->
    let m = part1_machine [Set Eq, [Ind1 (Lit (mem_top -. 1L))]] in
    m.flags.fz <- true;
    m.mem.(mem_size - 2) <- Byte '\x7f';
    step m;
    assert_eq m.mem.(mem_size - 1) (Byte '\x01') ();
    assert_eq m.mem.(mem_size - 2) (Byte '\x7f') ());
  ("unary arithmetic overflow", fun () ->
    List.iter (fun (op, value, expected) ->
      let m = part1_machine [op, [Reg Rax]] in
      m.regs.(rind Rax) <- value;
      step m;
      assert_eq m.regs.(rind Rax) expected ();
      assert_eq m.flags.fo true ()
    ) [Incq, Int64.max_int, Int64.min_int;
       Decq, Int64.min_int, Int64.max_int;
       Negq, Int64.min_int, Int64.min_int]);
  ("comparison handles signed overflow without writing", fun () ->
    let m = part1_machine [Cmpq, [Imm (Lit 1L); Reg Rax]] in
    m.regs.(rind Rax) <- Int64.min_int;
    step m;
    assert_eq m.regs.(rind Rax) Int64.min_int ();
    assert_eq (interp_cnd m.flags Lt) true ();
    assert_eq m.flags.fo true ());
  ("multiply preserves undefined flags", fun () ->
    let m = part1_machine [Imulq, [Imm (Lit 2L); Reg Rax]] in
    m.regs.(rind Rax) <- Int64.max_int;
    m.flags.fz <- true;
    step m;
    assert_eq m.flags {fo = true; fs = false; fz = true} ());
  ("not preserves flags", fun () ->
    let m = part1_machine [Notq, [Reg Rax]] in
    m.regs.(rind Rax) <- 5L;
    m.flags.fo <- true;
    m.flags.fs <- true;
    m.flags.fz <- true;
    step m;
    assert_eq m.regs.(rind Rax) (-6L) ();
    assert_eq m.flags {fo = true; fs = true; fz = true} ());
  ("zero shifts preserve all flags", fun () ->
    List.iter (fun op ->
      let m = part1_machine [op, [Imm (Lit 0L); Reg Rax]] in
      m.regs.(rind Rax) <- 7L;
      m.flags.fo <- true;
      m.flags.fs <- true;
      m.flags.fz <- true;
      step m;
      assert_eq m.regs.(rind Rax) 7L ();
      assert_eq m.flags {fo = true; fs = true; fz = true} ()
    ) [Shlq; Sarq; Shrq]);
  ("one bit shifts compute overflow", fun () ->
    List.iter (fun (op, value, expected, overflow) ->
      let m = part1_machine [op, [Imm (Lit 1L); Reg Rax]] in
      m.regs.(rind Rax) <- value;
      m.flags.fo <- true;
      step m;
      assert_eq m.regs.(rind Rax) expected ();
      assert_eq m.flags.fo overflow ()
    ) [Shlq, 0x4000000000000000L, Int64.min_int, true;
       Shlq, -1L, -2L, false;
       Sarq, -8L, -4L, false;
       Shrq, -8L, 0x7ffffffffffffffcL, true]);
  ("multiple bit shifts preserve overflow", fun () ->
    List.iter (fun op ->
      List.iter (fun overflow ->
        let m = part1_machine [op, [Imm (Lit 2L); Reg Rax]] in
        m.regs.(rind Rax) <- 8L;
        m.flags.fo <- overflow;
        step m;
        assert_eq m.flags.fo overflow ()
      ) [false; true]
    ) [Shlq; Sarq; Shrq]);
  ("shift count uses low six bits", fun () ->
    let m = part1_machine [Shlq, [Reg Rcx; Reg Rax]] in
    m.regs.(rind Rcx) <- 65L;
    m.regs.(rind Rax) <- 3L;
    step m;
    assert_eq m.regs.(rind Rax) 6L ());
  ("conditional jump and fallthrough", fun () ->
    List.iter (fun taken ->
      let target = mem_bot +. 24L in
      let m = part1_machine [J Eq, [Imm (Lit target)]] in
      m.flags.fz <- taken;
      step m;
      assert_eq m.regs.(rind Rip)
        (if taken then target else mem_bot +. ins_size) ()
    ) [false; true]);
  ("push pop preserve value stack and flags", fun () ->
    let m = part1_machine [Pushq, [Imm (Lit 42L)]; Popq, [Reg Rax]] in
    let old_rsp = m.regs.(rind Rsp) in
    m.flags.fo <- true;
    m.flags.fs <- true;
    m.flags.fz <- true;
    step m;
    assert_eq (readquad m (old_rsp -. 8L)) 42L ();
    step m;
    assert_eq m.regs.(rind Rax) 42L ();
    assert_eq m.regs.(rind Rsp) old_rsp ();
    assert_eq m.flags {fo = true; fs = true; fz = true} ());
  ("call return and sentinel termination", fun () ->
    let m = part1_machine [
      Callq, [Imm (Lit (mem_bot +. 16L))]; Retq, [];
      Movq, [Imm (Lit 42L); Reg Rax]; Retq, []
    ] in
    writequad m m.regs.(rind Rsp) exit_addr;
    m.flags.fo <- true;
    m.flags.fs <- true;
    m.flags.fz <- true;
    step m;
    assert_eq (readquad m m.regs.(rind Rsp)) (mem_bot +. 8L) ();
    assert_eq (run m) 42L ();
    assert_eq m.regs.(rind Rsp) mem_top ();
    assert_eq m.flags {fo = true; fs = true; fz = true} ());
  ("recursive factorial without assembler", fun () ->
    let m = part1_machine [
      Subq, [Imm (Lit 8L); Reg Rsp];
      Cmpq, [Imm (Lit 1L); Reg Rdi];
      J Le, [Imm (Lit (mem_bot +. 72L))];
      Movq, [Reg Rdi; Ind2 Rsp];
      Decq, [Reg Rdi];
      Callq, [Imm (Lit mem_bot)];
      Imulq, [Ind2 Rsp; Reg Rax];
      Addq, [Imm (Lit 8L); Reg Rsp];
      Retq, [];
      Movq, [Imm (Lit 1L); Reg Rax];
      Addq, [Imm (Lit 8L); Reg Rsp];
      Retq, [];
      Movq, [Imm (Lit 6L); Reg Rdi];
      Callq, [Imm (Lit mem_bot)];
      Retq, []
    ] in
    m.regs.(rind Rip) <- mem_bot +. 96L;
    writequad m m.regs.(rind Rsp) exit_addr;
    assert_eq (run m) 720L ());
  ("invalid operands fail before executing", fun () ->
    let m = part1_machine [Movq, [Imm (Lit 1L); Imm (Lit 2L)]] in
    let before = Array.copy m.regs in
    (try step m; failwith "expected Invalid_argument"
     with Invalid_argument _ -> ());
    assert_eq m.regs before ())
]

let provided_tests : suite = [

  Test ("Part I Regression Tests", part1_tests);
  
  Test ("My Tests", [
    ("assert", test_my)
  ]);

  Test ("Student-Provided Big Test for Part III: Score recorded as PartIIITestCase", [
    
  ]);

] 
