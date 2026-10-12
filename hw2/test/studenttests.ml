open Util.Assert
open X86
open Asm
open Sim.Simulator

(* Student-Provided Big Test for Part III.
 *
 * This handwritten program stably merge-sorts (value, original_index) records
 * and counts strict inversions. It exercises two recursive calls, stack frames,
 * nested loops, signed comparisons, indirect calls and unaligned memory.
 * Small instruction tests cover behavior the algorithm does not use.
 *
 * Reference: https://faculty.sist.shanghaitech.edu.cn/cs131/hw2/doc/x86lite.html
 * imulq's SF/ZF are undefined; shift counts here are 0..63; unaligned accesses
 * are legal; set writes ONE byte. Do not impose additional real-x86 behavior
 * on X86lite (e.g. shift-count masking or push/pop %rsp evaluation order).
 * Expected answers do not use the tested interpreter's helper functions.
 *)

let check label condition = if not condition then failwith label

let equal64 label expected actual =
  if expected <> actual then
    failwith (Printf.sprintf "%s: expected %Ld (0x%Lx), got %Ld (0x%Lx)"
                label expected expected actual actual)

let context label f =
  try f () with
  | Failure message -> failwith (label ^ ": " ^ message)
  | exn -> failwith (label ^ ": " ^ Printexc.to_string exn)

let imm value = Imm (Lit value)
let offset value reg = Ind3 (Lit (Int64.of_int value), reg)
let address base delta = Int64.add base (Int64.of_int delta)
let index addr = Int64.to_int (Int64.sub addr mem_bot)

(* Independent little-endian readers/writers for test setup and assertions. *)
let quad_bytes value =
  List.init 8 (fun i ->
    Byte (Char.chr (Int64.to_int
      (Int64.logand (Int64.shift_right_logical value (8 * i)) 255L))))

let store_bytes m addr bytes =
  List.iteri (fun i byte -> m.mem.(index addr + i) <- byte) bytes

let store_quad m addr value = store_bytes m addr (quad_bytes value)

let read_quad m addr =
  let result = ref 0L in
  for i = 0 to 7 do
    match m.mem.(index addr + i) with
    | Byte c ->
        result := Int64.logor !result
          (Int64.shift_left (Int64.of_int (Char.code c)) (8 * i))
    | _ -> failwith "expected data byte, found instruction byte"
  done;
  !result

let expect_bytes label m addr bytes =
  List.iteri (fun i expected ->
    if m.mem.(index addr + i) <> expected then
      failwith (Printf.sprintf "%s: wrong byte at 0x%Lx" label (address addr i))
  ) bytes

let set_test_flags m (o, s, z) =
  m.flags.fo <- o; m.flags.fs <- s; m.flags.fz <- z

let expect_flags m (o, s, z) =
  let eo = match o with None -> true | Some v -> v = m.flags.fo in
  let es = match s with None -> true | Some v -> v = m.flags.fs in
  let ez = match z with None -> true | Some v -> v = m.flags.fz in
  let show = function None -> "undefined" | Some v -> string_of_bool v in
  if not (eo && es && ez) then
    failwith (Printf.sprintf "OF/SF/ZF: expected %s/%s/%s, got %b/%b/%b"
      (show o) (show s) (show z) m.flags.fo m.flags.fs m.flags.fz)

let known_flags (o, s, z) = (Some o, Some s, Some z)

let all_flags =
  List.concat_map (fun o -> List.concat_map (fun s ->
    List.map (fun z -> (o, s, z)) [false; true]) [false; true]) [false; true]

let condition (o, s, z) = function
  | Eq -> z | Neq -> not z | Lt -> s <> o | Le -> z || s <> o
  | Gt -> not z && s = o | Ge -> s = o

let conditions = [Eq; Neq; Lt; Le; Gt; Ge]

(* Calculate the specified layout from source, independently of assemble/load. *)
let source_layout program =
  let text_length = List.fold_left (fun n e -> match e.asm with
    | Text instructions -> n + 8 * List.length instructions | Data _ -> n
  ) 0 program in
  let text_cursor = ref mem_bot in
  let data_cursor = ref (address mem_bot text_length) in
  let symbols = List.map (fun e ->
    let cursor, size = match e.asm with
      | Text instructions -> text_cursor, 8 * List.length instructions
      | Data values -> data_cursor, List.fold_left (fun n -> function
          | Quad _ -> n + 8 | Asciz s -> n + String.length s + 1) 0 values
    in
    let here = !cursor in
    cursor := address here size;
    (e.lbl, here)
  ) program in
  (symbols, address mem_bot text_length)

let resolve symbols = function Lit value -> value | Lbl name -> List.assoc name symbols

let data_bytes symbols values =
  List.concat_map (function
    | Quad value -> quad_bytes (resolve symbols value)
    | Asciz s -> List.init (String.length s) (fun i -> Byte s.[i]) @ [Byte '\000']
  ) values

let checked_load program =
  let symbols, data_start = source_layout program in
  let executable = assemble program in
  equal64 "text_pos" mem_bot executable.text_pos;
  equal64 "data_pos" data_start executable.data_pos;
  equal64 "entry" (List.assoc "main" symbols) executable.entry;
  let patch = function
    | Imm v -> Imm (Lit (resolve symbols v))
    | Ind1 v -> Ind1 (Lit (resolve symbols v))
    | Ind3 (v, r) -> Ind3 (Lit (resolve symbols v), r)
    | operand -> operand
  in
  let expected_text = List.concat_map (fun e -> match e.asm with
    | Data _ -> []
    | Text instructions -> List.concat_map (fun (op, args) ->
        InsB0 (op, List.map patch args) :: List.init 7 (fun _ -> InsFrag)
      ) instructions
  ) program in
  let expected_data = List.concat_map (fun e -> match e.asm with
    | Text _ -> [] | Data values -> data_bytes symbols values
  ) program in
  check "assembled instruction bytes / label relocation" (executable.text_seg = expected_text);
  check "assembled data bytes / label relocation" (executable.data_seg = expected_data);
  let m = load executable in
  expect_bytes "loaded text" m mem_bot expected_text;
  expect_bytes "loaded data" m data_start expected_data;
  equal64 "initial RIP" executable.entry m.regs.(rind Rip);
  equal64 "initial RSP" (Int64.sub mem_top 8L) m.regs.(rind Rsp);
  equal64 "exit sentinel" exit_addr (read_quad m (Int64.sub mem_top 8L));
  expect_flags m (known_flags (false, false, false));
  List.iter (fun r -> equal64 ("initial " ^ string_of_reg r) 0L m.regs.(rind r))
    [Rax; Rbx; Rcx; Rdx; Rsi; Rdi; Rbp; R08; R09; R10; R11; R12; R13; R14; R15];
  (m, symbols)

let run_bounded m =
  let steps = ref 0 in
  while m.regs.(rind Rip) <> exit_addr && !steps < 200_000 do
    step m;
    incr steps
  done;
  check "exceeded 200000 instructions (possible control-flow error)"
    (m.regs.(rind Rip) = exit_addr);
  equal64 "final RSP" mem_top m.regs.(rind Rsp)

let preserved_registers =
  [Rbx, 0x123456789abcdef0L; Rbp, 0x2233445566778899L;
   R12, 0x876543210fedcba9L; R13, 0x3141592653589793L;
   R14, 0xfedcba9876543210L; R15, 0x55aa55aaaa55aa55L]

(* sort(RDI=records, RSI=scratch, RDX=count) -> RAX=inversions.
 * Records are 16 bytes: signed value at +0, original index at +8.
 * RBX/R12/R13/R14/R15 hold base/scratch/count/mid/inversions.
 * Both recursive calls preserve these registers. During merging, R08/R09/R10
 * are the left, right and output indices. compare preserves data registers
 * and returns its comparison flags through RET, consumed immediately by J Le.
 *)
let merge_sort_program values =
  let records = List.concat (List.mapi (fun i value ->
    [Quad (Lit value); Quad (Lit (Int64.of_int i))]) values) in
  [data "prefix" [Asciz "MS"];
   text "sort" [
     Pushq, [~%Rbp]; Movq, [~%Rsp; ~%Rbp];
     Pushq, [~%Rbx]; Pushq, [~%R12]; Pushq, [~%R13];
     Pushq, [~%R14]; Pushq, [~%R15];
     Movq, [~%Rdi; ~%Rbx]; Movq, [~%Rsi; ~%R12]; Movq, [~%Rdx; ~%R13];
     Cmpq, [~$1; ~%R13]; J Le, [~$$"sort_base"];
     Movq, [~%R13; ~%R14]; Shrq, [~$1; ~%R14];
     Movq, [~%R14; ~%Rdx]; Callq, [~$$"sort"];
     Movq, [~%Rax; ~%R15];
     Movq, [~%R14; ~%R09]; Shlq, [~$4; ~%R09];
     Movq, [~%Rbx; ~%Rdi]; Addq, [~%R09; ~%Rdi];
     Movq, [~%R12; ~%Rsi]; Addq, [~%R09; ~%Rsi];
     Movq, [~%R13; ~%Rdx]; Subq, [~%R14; ~%Rdx];
     Callq, [~$$"sort"]; Addq, [~%Rax; ~%R15];
     Xorq, [~%R08; ~%R08]; Movq, [~%R14; ~%R09]; Xorq, [~%R10; ~%R10]
   ];
   data "array_before" [Quad (Lit 0xdeadbeefcafebabeL)];
   text "merge" [
     Cmpq, [~%R13; ~%R10]; J Ge, [~$$"copy_begin"];
     Movq, [~%R08; ~%Rax]; Shlq, [~$4; ~%Rax]; Addq, [~%Rbx; ~%Rax];
     Movq, [~%R09; ~%Rcx]; Shlq, [~$4; ~%Rcx]; Addq, [~%Rbx; ~%Rcx];
     Cmpq, [~%R14; ~%R08]; J Ge, [~$$"take_right"];
     Cmpq, [~%R13; ~%R09]; J Ge, [~$$"take_left"];
     Movq, [Ind2 Rax; ~%Rdi]; Movq, [Ind2 Rcx; ~%Rsi];
     Callq, [Ind1 (Lbl "compare_pointer")]; J Le, [~$$"take_left"]
   ];
   text "take_right" [
     Movq, [~%Rcx; ~%R11]; Incq, [~%R09];
     Addq, [~%R14; ~%R15]; Subq, [~%R08; ~%R15]; Jmp, [~$$"merge_store"]
   ];
   data "array" records;
   text "take_left" [Movq, [~%Rax; ~%R11]; Incq, [~%R08]];
   text "merge_store" [
     Movq, [~%R10; ~%Rdx]; Shlq, [~$4; ~%Rdx]; Addq, [~%R12; ~%Rdx];
     Movq, [Ind2 R11; ~%Rax]; Movq, [~%Rax; Ind2 Rdx];
     Movq, [offset 8 R11; ~%Rax]; Movq, [~%Rax; offset 8 Rdx];
     Incq, [~%R10]; Jmp, [~$$"merge"]
   ];
   data "array_after" [Quad (Lit 0x1020304050607080L)];
   text "copy_begin" [
     Movq, [~%Rbx; ~%R08]; Movq, [~%R12; ~%R09]; Movq, [~%R13; ~%R10]
   ];
   text "copy_loop" [
     Movq, [Ind2 R09; ~%Rax]; Movq, [~%Rax; Ind2 R08];
     Movq, [offset 8 R09; ~%Rax]; Movq, [~%Rax; offset 8 R08];
     Leaq, [offset 16 R08; ~%R08]; Leaq, [offset 16 R09; ~%R09];
     Decq, [~%R10]; J Gt, [~$$"copy_loop"];
     Movq, [~%R15; ~%Rax]; Jmp, [~$$"sort_return"]
   ];
   data "scratch_before" [Quad (Lit 0x1122334455667788L)];
   text "sort_base" [Movq, [~$0; ~%Rax]];
   text "sort_return" [
     Popq, [~%R15]; Popq, [~%R14]; Popq, [~%R13];
     Popq, [~%R12]; Popq, [~%Rbx]; Popq, [~%Rbp]; Retq, []
   ];
   data "scratch" (List.init (2 * List.length values) (fun _ -> Quad (Lit (-1L))));
   gtext "main" (List.map (fun (r, value) -> Movq, [imm value; Reg r]) preserved_registers @ [
     Movq, [Ind1 (Lbl "array_pointer"); ~%Rdi];
     Leaq, [Ind1 (Lbl "scratch"); ~%Rsi];
     Movq, [~$(List.length values); ~%Rdx]; Callq, [~$$"sort"]; Retq, []
   ]);
   data "scratch_after" [Quad (Lit 0x8877665544332211L)];
   data "array_pointer" [Quad (Lbl "array")];
   data "compare_pointer" [Quad (Lbl "compare")];
   text "compare" [Cmpq, [~%Rsi; ~%Rdi]; Retq, []];
   data "embedded_zero" [Asciz "a\000b\255"; Quad (Lit 0x0123456789abcdefL)]
  ]

let inversion_count values =
  let rec count = function
    | [] -> 0
    | x :: xs -> List.length (List.filter (fun y -> Int64.compare x y > 0) xs) + count xs
  in Int64.of_int (count values)

let sort_case values () =
  let program = merge_sort_program values in
  let m, symbols = checked_load program in
  let sorted = List.stable_sort (fun (x, _) (y, _) -> Int64.compare x y)
    (List.mapi (fun i x -> (x, Int64.of_int i)) values) in
  let record_bytes = List.concat_map (fun (value, i) -> quad_bytes value @ quad_bytes i) sorted in
  run_bounded m;
  equal64 "strict inversions" (inversion_count values) m.regs.(rind Rax);
  List.iter (fun (r, value) -> equal64 ("preserved " ^ string_of_reg r) value m.regs.(rind r))
    preserved_registers;
  (* Check every data byte: record identities, guards, pointers and strings. *)
  List.iter (fun e -> match e.asm with
    | Text _ -> ()
    | Data values ->
        let expected = if e.lbl = "array" ||
          (e.lbl = "scratch" && List.length sorted > 1)
          then record_bytes else data_bytes symbols values in
        expect_bytes e.lbl m (List.assoc e.lbl symbols) expected
  ) program

let sorting_cases =
  let extremes = [Int64.min_int; Int64.max_int; 0L; -1L; 1L;
                  0x4000000000000000L; -0x4000000000000000L] in
  let explicit = [
    "empty", []; "singleton", [Int64.min_int];
    "two reversed extremes", [Int64.max_int; Int64.min_int];
    "two equal", [-1L; -1L]; "all equal", List.init 17 (fun _ -> -7L);
    "signed extremes", extremes @ List.rev extremes;
    "ascending", List.init 33 (fun i -> Int64.of_int (i - 16));
    "descending", List.init 33 (fun i -> Int64.of_int (16 - i));
    "duplicates", [3L; -2L; 3L; 0L; -2L; 3L; 0L; 0L; -2L]
  ] in
  (* Local deterministic generator; does not alter OCaml's global Random state. *)
  let generated = List.map (fun n ->
    let state = ref (Int64.of_int (n + 131)) in
    let values = List.init n (fun i ->
      state := Int64.add (Int64.mul !state 6364136223846793005L) 1442695040888963407L;
      if i mod 3 = 0 then List.nth extremes (i mod List.length extremes) else !state
    ) in
    (Printf.sprintf "deterministic length %d" n, values)
  ) [0; 1; 2; 3; 4; 7; 8; 9; 15; 16; 17; 31; 32; 33] in
  List.map (fun (name, values) -> ("merge sort / " ^ name, sort_case values)) (explicit @ generated)

(* Each group owns a fixture; every probe resets ALL memory, registers and flags.
 * Reusing the allocation makes thousands of independent probes inexpensive. *)
let new_fixture () =
  { mem = Array.make mem_size (Byte '\000'); regs = Array.make nregs 0L;
    flags = {fo = false; fs = false; fz = false} }

let reset_fixture m instruction =
  Array.fill m.mem 0 mem_size (Byte '\000');
  Array.iteri (fun i _ -> m.regs.(i) <- Int64.add 0x1122334455667700L (Int64.of_int i)) m.regs;
  m.regs.(rind Rip) <- mem_bot;
  m.regs.(rind Rsp) <- Int64.sub mem_top 8L;
  set_test_flags m (false, false, false);
  m.mem.(0) <- InsB0 instruction;
  for i = 1 to 7 do m.mem.(i) <- InsFrag done;
  store_quad m (Int64.sub mem_top 8L) exit_addr

let probe ?(next = address mem_bot 8) m name instruction changed setup verify =
  context (name ^ " / " ^ string_of_ins instruction) (fun () ->
    reset_fixture m instruction;
    setup m;
    let before = Array.copy m.regs in
    step m;
    equal64 "next RIP" next m.regs.(rind Rip);
    for i = 0 to nregs - 1 do
      if i <> rind Rip && not (List.exists (fun r -> rind r = i) changed) then
        equal64 (Printf.sprintf "unchanged register index %d" i) before.(i) m.regs.(i)
    done;
    verify m
  )

let slot = address mem_bot 0x203
let left_guard = 0xfedcba9876543210L
let right_guard = 0x1023456789abcdefL

let prepare_slot m value =
  store_quad m (address slot (-8)) left_guard;
  store_quad m slot value;
  store_quad m (address slot 8) right_guard

let expect_slot m value =
  expect_bytes "memory operand and adjacent bytes" m (address slot (-8))
    (quad_bytes left_guard @ quad_bytes value @ quad_bytes right_guard)

let operand_form form src = match form with
  | 0 -> [imm src; Reg Rax]
  | 1 -> [Reg Rbx; Reg Rax]
  | 2 -> [Ind1 (Lit slot); Reg Rax]
  | 3 -> [Reg Rbx; Ind2 R10]
  | 4 -> [imm src; offset (-13) R11]
  | 5 -> [Ind2 R10; Reg Rax]
  | 6 -> [offset (-13) R11; Reg Rax]
  | 7 -> [imm src; Ind1 (Lit slot)]
  | 8 -> [Reg Rbx; Ind1 (Lit slot)]
  | 9 -> [imm src; Ind2 R10]
  | 10 -> [Reg Rbx; offset (-13) R11]
  | 11 -> [offset 13 R11; Reg Rax]
  | 12 -> [Reg Rbx; offset 13 R11]
  | 13 -> [imm src; offset 13 R11]
  | _ -> invalid_arg "test operand form"

let memory_destination form = List.mem form [3; 4; 7; 8; 9; 10; 12; 13]

let prepare_binary m form src dst initial_flags =
  m.regs.(rind Rax) <- dst;
  m.regs.(rind Rbx) <- src;
  m.regs.(rind R10) <- slot;
  m.regs.(rind R11) <- address slot (if form >= 11 then -13 else 13);
  prepare_slot m (if memory_destination form then dst else src);
  set_test_flags m initial_flags

let sign value = Int64.compare value 0L < 0

let binary_result op src dst = match op with
  | Addq -> Int64.add dst src
  | Subq | Cmpq -> Int64.sub dst src
  | Andq -> Int64.logand dst src
  | Orq -> Int64.logor dst src
  | Xorq -> Int64.logxor dst src
  | Movq -> src
  | _ -> invalid_arg "binary reference operation"

let binary_flags op src dst result initial =
  let overflow = match op with
    | Addq -> sign src = sign dst && sign result <> sign dst
    | Subq | Cmpq -> sign src <> sign dst && sign result <> sign dst
    | _ -> false
  in
  if op = Movq then known_flags initial
  else known_flags (overflow, sign result, result = 0L)

let boundary_values =
  [0L; 1L; -1L; Int64.min_int; Int64.max_int;
   Int64.succ Int64.min_int; Int64.pred Int64.max_int;
   0x4000000000000000L; -0x4000000000000000L;
   0x0123456789abcdefL; 0xfedcba9876543210L]

let binary_tests () =
  let m = new_fixture () in
  List.iter (fun op -> List.iter (fun src -> List.iter (fun dst ->
    List.iter (fun form ->
      let result = binary_result op src dst in
      (* Seed opposite flags so forgetting to update or clear a flag is visible. *)
      let initial = (true, not (sign result), result <> 0L) in
      let expected = if op = Cmpq then dst else result in
      let memory = memory_destination form in
      let changed = if not memory && op <> Cmpq then [Rax] else [] in
      probe m (Printf.sprintf "src=%Ld dst=%Ld form=%d" src dst form)
        (op, operand_form form src) changed
        (fun m -> prepare_binary m form src dst initial)
        (fun m ->
          equal64 "destination" expected
            (if memory then read_quad m slot else m.regs.(rind Rax));
          expect_slot m (if memory then expected else src);
          expect_flags m (binary_flags op src dst result initial))
    ) (List.init 14 Fun.id)
  ) boundary_values) boundary_values) [Addq; Subq; Cmpq; Andq; Orq; Xorq; Movq];
  (* A source register may also be its destination. *)
  List.iter (fun op -> List.iter (fun value ->
    let result = binary_result op value value in
    let initial = (true, false, false) in
    probe m (Printf.sprintf "aliased operands value=%Ld" value)
      (op, [Reg Rax; Reg Rax]) (if op = Cmpq then [] else [Rax])
      (fun m -> m.regs.(rind Rax) <- value; set_test_flags m initial)
      (fun m ->
        equal64 "aliased destination" (if op = Cmpq then value else result) m.regs.(rind Rax);
        expect_flags m (binary_flags op value value result initial))
  ) boundary_values) [Addq; Subq; Cmpq; Andq; Orq; Xorq; Movq]

let multiply_tests () =
  let m = new_fixture () in
  (* Overflow answers are explicit, including both sides of sqrt(MAX_INT). *)
  let cases = [
    0L, Int64.min_int, false; 1L, Int64.min_int, false;
    -1L, Int64.min_int, true; 2L, Int64.max_int, true;
    -2L, Int64.min_int, true; -1L, Int64.max_int, false;
    3L, -7L, false; -3L, -7L, false;
    Int64.max_int, Int64.max_int, true;
    Int64.min_int, Int64.min_int, true;
    3037000499L, 3037000499L, false;
    3037000500L, 3037000500L, true;
    -3037000500L, 3037000500L, true;
    0x4000000000000000L, -2L, false;
    0x4000000000000000L, 4L, true
  ] in
  List.iter (fun (src, dst, overflow) -> List.iter (fun form ->
    probe m (Printf.sprintf "multiply src=%Ld dst=%Ld" src dst)
      (Imulq, operand_form form src) [Rax]
      (fun m -> prepare_binary m form src dst (not overflow, true, true))
      (fun m ->
        equal64 "product" (Int64.mul src dst) m.regs.(rind Rax);
        expect_slot m src;
        expect_flags m (Some overflow, None, None))
  ) [0; 1; 2; 5; 6; 11]) cases;
  List.iter (fun value ->
    let overflow = value = Int64.max_int || value = Int64.min_int in
    probe m "multiply aliased registers" (Imulq, [Reg Rax; Reg Rax]) [Rax]
      (fun m -> m.regs.(rind Rax) <- value; set_test_flags m (not overflow, true, true))
      (fun m ->
        equal64 "square" (Int64.mul value value) m.regs.(rind Rax);
        expect_flags m (Some overflow, None, None))
  ) [0L; 1L; -1L; 2L; Int64.max_int; Int64.min_int]

let unary_tests () =
  let m = new_fixture () in
  List.iter (fun op -> List.iter (fun value -> List.iter (fun form ->
    let memory = form <> 0 in
    let result, overflow = match op with
      | Incq -> Int64.succ value, value = Int64.max_int
      | Decq -> Int64.pred value, value = Int64.min_int
      | Negq -> Int64.neg value, value = Int64.min_int
      | Notq -> Int64.lognot value, false
      | _ -> invalid_arg "unary reference operation"
    in
    List.iter (fun initial ->
      let operand = match form with
        | 0 -> Reg Rax | 1 -> Ind1 (Lit slot) | 2 -> Ind2 R10
        | 3 -> offset (-13) R11 | _ -> offset 13 R11 in
      probe m (Printf.sprintf "unary value=%Ld" value) (op, [operand])
        (if memory then [] else [Rax])
        (fun m -> prepare_binary m (if form = 4 then 13 else 4) 0L value initial)
        (fun m ->
          equal64 "unary result" result
            (if memory then read_quad m slot else m.regs.(rind Rax));
          expect_slot m (if memory then result else value);
          expect_flags m (known_flags (if op = Notq then initial
            else (overflow, sign result, result = 0L))))
    ) [(false, false, false); (true, true, true)]
  ) [0; 1; 2; 3; 4]) boundary_values) [Incq; Decq; Negq; Notq]

let shift_tests () =
  let m = new_fixture () in
  let values = [0L; 1L; -1L; Int64.min_int; Int64.max_int; 0x4000000000000000L] in
  List.iter (fun op -> List.iter (fun amount -> List.iter (fun value ->
    List.iter (fun form -> List.iter (fun ((old_o, _, _) as initial) ->
      let result = match op with
        | Shlq -> Int64.shift_left value amount
        | Sarq -> Int64.shift_right value amount
        | Shrq -> Int64.shift_right_logical value amount
        | _ -> invalid_arg "shift reference operation"
      in
      let expected_flags = if amount = 0 then initial else
        let o = if amount <> 1 then old_o else match op with
          | Sarq -> false | Shrq -> sign value
          | Shlq -> (Int64.logand value 0x4000000000000000L <> 0L) <> sign value
          | _ -> false
        in (o, sign result, result = 0L)
      in
      let count = if List.mem form [0; 3; 5; 6] then ~$amount else Reg Rcx in
      let dst = match form with
        | 0 | 1 -> Reg Rax | 2 | 6 -> Ind2 R10
        | 3 | 7 -> Ind1 (Lit slot) | _ -> offset (-13) R11 in
      let memory = form >= 2 in
      probe m (Printf.sprintf "shift value=%Ld amount=%d" value amount) (op, [count; dst])
        (if memory then [] else [Rax])
        (fun m -> prepare_binary m 4 0L value initial;
          m.regs.(rind Rcx) <- Int64.of_int amount)
        (fun m ->
          equal64 "shift result" result
            (if memory then read_quad m slot else m.regs.(rind Rax));
          expect_slot m (if memory then result else value);
          expect_flags m (known_flags expected_flags))
    ) [(false, false, false); (true, true, true)]) (List.init 8 Fun.id)
  ) values) [0; 1; 2; 31; 32; 63]) [Shlq; Sarq; Shrq];
  List.iter (fun op -> List.iter (fun amount ->
    let value = Int64.of_int amount in
    let result = match op with
      | Shlq -> Int64.shift_left value amount
      | Sarq -> Int64.shift_right value amount
      | _ -> Int64.shift_right_logical value amount
    in
    probe m "RCX is both count and destination" (op, [Reg Rcx; Reg Rcx]) [Rcx]
      (fun m -> m.regs.(rind Rcx) <- value)
      (fun m -> equal64 "aliased shift" result m.regs.(rind Rcx))
  ) [0; 1; 2; 63]) [Shlq; Sarq; Shrq]

let general_registers =
  [Rax; Rbx; Rcx; Rdx; Rsi; Rdi; Rbp; Rsp; R08; R09; R10; R11; R12; R13; R14; R15]

let set_tests () =
  let m = new_fixture () in
  let original = 0xf123456789abcdffL in
  List.iter (fun initial -> List.iter (fun c ->
    let bit = if condition initial c then 1L else 0L in
    List.iter (fun r ->
      probe m "set preserves upper seven register bytes" (Set c, [Reg r]) [r]
        (fun m -> m.regs.(rind r) <- original; set_test_flags m initial)
        (fun m ->
          equal64 "set result" (Int64.logor (Int64.logand original (-256L)) bit) m.regs.(rind r);
          expect_flags m (known_flags initial))
    ) general_registers;
    List.iter (fun target -> List.iter (fun form ->
      let operand = match form with
        | 0 -> Ind1 (Lit target) | 1 -> Ind2 R10 | _ -> offset (-13) R11 in
      let start = address target (-7) in
      let length = if target = Int64.sub mem_top 1L then 8 else 16 in
      let before = List.init length (fun i -> Byte (Char.chr (0x80 + i))) in
      let expected = List.mapi (fun i byte ->
        if i = 7 then Byte (Char.chr (Int64.to_int bit)) else byte) before in
      probe m "set changes exactly one memory byte" (Set c, [operand]) []
        (fun m ->
          m.regs.(rind R10) <- target; m.regs.(rind R11) <- address target 13;
          store_bytes m start before; set_test_flags m initial)
        (fun m ->
          expect_bytes "set byte and neighbors" m start expected;
          expect_flags m (known_flags initial))
    ) [0; 1; 2]) [slot; address slot 3; Int64.sub mem_top 1L]
  ) conditions) all_flags

(* Indirect control transfers use the VALUE at the address, not the address.
 * None of these operands depend on RSP, avoiding ambiguous evaluation order. *)
let target_operand form target = match form with
  | 0 -> imm target | 1 -> Reg R11 | 2 -> Ind1 (Lit slot)
  | 3 -> Ind2 R10 | _ -> offset (-13) R11

let prepare_target m form target initial =
  m.regs.(rind R10) <- slot;
  m.regs.(rind R11) <- (if form = 1 then target else address slot 13);
  prepare_slot m target;
  set_test_flags m initial

let branch_tests () =
  let m = new_fixture () in
  let target = address mem_bot 128 in
  List.iter (fun initial -> List.iter (fun form ->
    let operand = target_operand form target in
    List.iter (fun c ->
      let next = if condition initial c then target else address mem_bot 8 in
      probe ~next m "conditional branch" (J c, [operand]) []
        (fun m -> prepare_target m form target initial)
        (fun m -> expect_slot m target; expect_flags m (known_flags initial))
    ) conditions;
    probe ~next:target m "unconditional jump" (Jmp, [operand]) []
      (fun m -> prepare_target m form target initial)
      (fun m -> expect_slot m target; expect_flags m (known_flags initial));
    probe ~next:target m "call target and return address" (Callq, [operand]) [Rsp]
      (fun m -> prepare_target m form target initial)
      (fun m ->
        equal64 "call RSP" (Int64.sub mem_top 16L) m.regs.(rind Rsp);
        equal64 "pushed return address" (address mem_bot 8) (read_quad m (Int64.sub mem_top 16L));
        equal64 "outer return address" exit_addr (read_quad m (Int64.sub mem_top 8L));
        expect_slot m target; expect_flags m (known_flags initial))
  ) [0; 1; 2; 3; 4];
    probe ~next:target m "return target and stack" (Retq, []) [Rsp]
      (fun m -> store_quad m (Int64.sub mem_top 8L) target; set_test_flags m initial)
      (fun m ->
        equal64 "return RSP" mem_top m.regs.(rind Rsp);
        equal64 "return does not erase stack" target (read_quad m (Int64.sub mem_top 8L));
        expect_flags m (known_flags initial))
  ) all_flags

let stack_tests () =
  let m = new_fixture () in
  let value = 0xfedcba9876543210L in
  List.iter (fun initial ->
    List.iter (fun form ->
      probe m "push source and stack" (Pushq, [target_operand form value]) [Rsp]
        (fun m -> prepare_target m form value initial)
        (fun m ->
          equal64 "push RSP" (Int64.sub mem_top 16L) m.regs.(rind Rsp);
          equal64 "pushed value" value (read_quad m (Int64.sub mem_top 16L));
          equal64 "stack neighbor" exit_addr (read_quad m (Int64.sub mem_top 8L));
          expect_slot m value; expect_flags m (known_flags initial))
    ) [0; 1; 2; 3; 4];
    List.iter (fun dst ->
      let changed = match dst with Reg r -> [Rsp; r] | _ -> [Rsp] in
      probe m "pop destination and stack" (Popq, [dst]) changed
        (fun m ->
          m.regs.(rind R10) <- slot; m.regs.(rind R11) <- address slot 13;
          prepare_slot m 0x1122334455667788L;
          store_quad m (Int64.sub mem_top 8L) value;
          set_test_flags m initial)
        (fun m ->
          equal64 "pop RSP" mem_top m.regs.(rind Rsp);
          (match dst with
           | Reg r -> equal64 "popped value" value m.regs.(rind r); expect_slot m 0x1122334455667788L
           | _ -> expect_slot m value);
          equal64 "pop does not erase stack" value (read_quad m (Int64.sub mem_top 8L));
          expect_flags m (known_flags initial))
    ) [Reg Rax; Reg R12; Reg Rbp; Ind1 (Lit slot); Ind2 R10; offset (-13) R11]
  ) all_flags

let movement_tests () =
  let m = new_fixture () in
  let value = 0xfedcba9876543210L in
  List.iter (fun initial ->
    List.iter (fun src -> List.iter (fun dst ->
      probe m "register-to-register move" (Movq, [Reg src; Reg dst]) [dst]
        (fun m -> m.regs.(rind src) <- value; set_test_flags m initial)
        (fun m -> equal64 "moved value" value m.regs.(rind dst); expect_flags m (known_flags initial))
    ) general_registers) general_registers;
    List.iter (fun (operand, base, expected) ->
      probe m "lea computes address without reading memory" (Leaq, [operand; Reg Rax]) [Rax]
        (fun m -> m.regs.(rind Rax) <- base; set_test_flags m initial)
        (fun m -> equal64 "effective address" expected m.regs.(rind Rax); expect_flags m (known_flags initial))
    ) [Ind1 (Lit slot), 0L, slot;
       Ind1 (Lit 0x123L), 0L, 0x123L;
       Ind2 Rax, slot, slot;
       offset 19 Rax, slot, address slot 19;
       offset (-19) Rax, slot, address slot (-19)];
    (* Source addressing uses the original register even when it is the destination. *)
    List.iter (fun (operand, base) ->
      probe m "load through destination register" (Movq, [operand; Reg Rax]) [Rax]
        (fun m -> m.regs.(rind Rax) <- base; prepare_slot m value; set_test_flags m initial)
        (fun m -> equal64 "aliased load" value m.regs.(rind Rax);
          expect_slot m value; expect_flags m (known_flags initial))
    ) [Ind2 Rax, slot; offset (-13) Rax, address slot 13; offset 13 Rax, address slot (-13)]
  ) [(false, false, false); (true, true, true)]

let relocation_test () =
  let program = [
    data "prefix" [Asciz ""; Asciz "a\000b"];
    text "increment" [Incq, [Reg Rax]; Retq, []];
    data "jump_pointer" [Quad (Lbl "finish")];
    gtext "main" [
      Movq, [~$8; Reg R08];
      Movq, [Ind3 (Lbl "values", R08); Reg Rax];
      Leaq, [Ind3 (Lbl "values", R08); Reg R11];
      Movq, [~$$"increment"; Reg R12]; Callq, [Reg R12];
      Movq, [Reg Rax; Ind3 (Lbl "output", R08)];
      Jmp, [Ind1 (Lbl "jump_pointer")]
    ];
    data "values" [Quad (Lit (-99L)); Quad (Lit 41L)];
    data "output" [Quad (Lit 0xabcdef0123456789L); Quad (Lit (-1L))];
    text "finish" [Retq, []]
  ] in
  let m, symbols = checked_load program in
  run_bounded m;
  equal64 "relocated program result" 42L m.regs.(rind Rax);
  equal64 "symbolic offset LEA" (address (List.assoc "values" symbols) 8) m.regs.(rind R11);
  List.iter (fun e -> match e.asm with
    | Text _ -> ()
    | Data ds ->
        let bytes = if e.lbl = "output" then quad_bytes 0xabcdef0123456789L @ quad_bytes 42L
          else data_bytes symbols ds in
        expect_bytes e.lbl m (List.assoc e.lbl symbols) bytes
  ) program

let install_instruction m addr instruction =
  m.mem.(index addr) <- InsB0 instruction;
  for i = 1 to 7 do m.mem.(index addr + i) <- InsFrag done

let memory_tests () =
  let m = new_fixture () in
  (* Overlapping stores distinguish byte-addressed memory from quadword arrays. *)
  let a = 0x0123456789abcdefL and b = 0xfedcba9876543210L in
  reset_fixture m (Movq, [imm a; Ind1 (Lit slot)]);
  prepare_slot m 0L;
  set_test_flags m (true, true, true);
  install_instruction m (address mem_bot 8) (Movq, [imm b; Ind1 (Lit (address slot 3))]);
  install_instruction m (address mem_bot 16) (Movq, [Ind1 (Lit slot); Reg Rax]);
  install_instruction m (address mem_bot 24) (Movq, [Ind1 (Lit (address slot 3)); Reg Rbx]);
  for _ = 1 to 4 do step m done;
  let prefix = List.filteri (fun i _ -> i < 3) (quad_bytes a) in
  let suffix = List.filteri (fun i _ -> i >= 3) (quad_bytes right_guard) in
  expect_bytes "overlapping stores" m (address slot (-8))
    (quad_bytes left_guard @ prefix @ quad_bytes b @ suffix);
  equal64 "overlapping load" 0x9876543210abcdefL m.regs.(rind Rax);
  equal64 "second unaligned load" b m.regs.(rind Rbx);
  expect_flags m (known_flags (true, true, true));
  List.iter (fun addr ->
    probe m "last legal quadword" (Movq, [imm a; Ind1 (Lit addr)]) []
      (fun _ -> ()) (fun m -> equal64 "boundary write" a (read_quad m addr))
  ) [Int64.sub mem_top 8L];
  List.iter (fun addr -> List.iter (fun instruction ->
    context (Printf.sprintf "invalid memory 0x%Lx / %s" addr (string_of_ins instruction)) (fun () ->
      reset_fixture m instruction;
      try step m; failwith "expected X86lite_segfault"
      with X86lite_segfault -> ())
  ) [Movq, [Ind1 (Lit addr); Reg Rax]; Movq, [imm 7L; Ind1 (Lit addr)]])
    [Int64.sub mem_bot 1L; Int64.sub mem_top 7L; mem_top; 0L; -1L];
  List.iter (fun value ->
    reset_fixture m (Retq, []);
    m.regs.(rind Rax) <- value;
    equal64 "run returns RAX" value (run m);
    equal64 "run terminates at sentinel" exit_addr m.regs.(rind Rip);
    equal64 "run restores stack" mem_top m.regs.(rind Rsp)
  ) [0L; 42L; Int64.min_int]

let semantic_cases = [
  "binary operations", binary_tests;
  "multiply / defined flags only", multiply_tests;
  "unary operations", unary_tests;
  "shifts", shift_tests;
  "all conditional sets", set_tests;
  "all branches and calls", branch_tests;
  "push and pop", stack_tests;
  "moves and effective addresses", movement_tests;
  "symbolic offsets and control pointers", relocation_test;
  "memory boundaries and overlap", memory_tests
]

let student_big_test () =
  List.iter (fun (name, test) -> context name test) (sorting_cases @ semantic_cases)

let provided_tests : suite = [
  Test ("Student-Provided Big Test for Part III: Score recorded as PartIIITestCase",
    ["stable recursive merge sort and X86lite semantics", student_big_test])
]
