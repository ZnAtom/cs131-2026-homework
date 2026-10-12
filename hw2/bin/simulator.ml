(* X86lite Simulator *)

(* See the documentation in the X86lite specification, available on the 
   course web pages, for a detailed explanation of the instruction
   semantics.
*)

open X86

(* simulator machine state -------------------------------------------------- *)

let mem_bot = 0x400000L          (* lowest valid address *)
let mem_top = 0x410000L          (* one past the last byte in memory *)
let mem_size = Int64.to_int (Int64.sub mem_top mem_bot)
let nregs = 17                   (* including Rip *)
let ins_size = 8L                (* assume we have a 8-byte encoding *)
let exit_addr = 0xfdeadL         (* halt when m.regs(%rip) = exit_addr *)

(* The simulator memory maps addresses to symbolic bytes.  Symbolic
   bytes are either actual data indicated by the Byte constructor or
   'symbolic instructions' that take up eight bytes for the purposes of
   layout.

   The symbolic bytes abstract away from the details of how
   instructions are represented in memory.  Each instruction takes
   exactly eight consecutive bytes, where the first byte InsB0 stores
   the actual instruction, and the next sevent bytes are InsFrag
   elements, which aren't valid data.

   For example, the two-instruction sequence:
        at&t syntax             ocaml syntax
      movq %rdi, (%rsp)       Movq,  [~%Rdi; Ind2 Rsp]
      decq %rdi               Decq,  [~%Rdi]

   is represented by the following elements of the mem array (starting
   at address 0x400000):

       0x400000 :  InsB0 (Movq,  [~%Rdi; Ind2 Rsp])
       0x400001 :  InsFrag
       0x400002 :  InsFrag
       0x400003 :  InsFrag
       0x400004 :  InsFrag
       0x400005 :  InsFrag
       0x400006 :  InsFrag
       0x400007 :  InsFrag
       0x400008 :  InsB0 (Decq,  [~%Rdi])
       0x40000A :  InsFrag
       0x40000B :  InsFrag
       0x40000C :  InsFrag
       0x40000D :  InsFrag
       0x40000E :  InsFrag
       0x40000F :  InsFrag
       0x400010 :  InsFrag
*)
type sbyte = InsB0 of ins       (* 1st byte of an instruction *)
           | InsFrag            (* 2nd - 8th bytes of an instruction *)
           | Byte of char       (* non-instruction byte *)

(* memory maps addresses to symbolic bytes *)
type mem = sbyte array

(* Flags for condition codes *)
type flags = { mutable fo : bool
             ; mutable fs : bool
             ; mutable fz : bool
             }

(* Register files *)
type regs = int64 array

(* Complete machine state *)
type mach = { flags : flags
            ; regs : regs
            ; mem : mem
            }

(* simulator helper functions ----------------------------------------------- *)

(* The index of a register in the regs array *)
let rind : reg -> int = function
  | Rip -> 16
  | Rax -> 0  | Rbx -> 1  | Rcx -> 2  | Rdx -> 3
  | Rsi -> 4  | Rdi -> 5  | Rbp -> 6  | Rsp -> 7
  | R08 -> 8  | R09 -> 9  | R10 -> 10 | R11 -> 11
  | R12 -> 12 | R13 -> 13 | R14 -> 14 | R15 -> 15

(* Helper functions for reading/writing sbytes *)

(* Convert an int64 to its sbyte representation *)
let sbytes_of_int64 (i:int64) : sbyte list =
  let open Char in 
  let open Int64 in
  List.map (fun n -> Byte (shift_right i n |> logand 0xffL |> to_int |> chr))
           [0; 8; 16; 24; 32; 40; 48; 56]

(* Convert an sbyte representation to an int64 *)
let int64_of_sbytes (bs:sbyte list) : int64 =
  let open Char in
  let open Int64 in
  let f b i = match b with
    | Byte c -> logor (shift_left i 8) (c |> code |> of_int)
    | _ -> 0L
  in
  List.fold_right f bs 0L

(* Convert a string to its sbyte representation *)
let sbytes_of_string (s:string) : sbyte list =
  let rec loop acc = function
    | i when i < 0 -> acc
    | i -> loop (Byte s.[i]::acc) (pred i)
  in
  loop [Byte '\x00'] @@ String.length s - 1

(* Serialize an instruction to sbytes *)
let sbytes_of_ins (op, args:ins) : sbyte list =
  let check = function
    | Imm (Lbl _) | Ind1 (Lbl _) | Ind3 (Lbl _, _) -> 
      invalid_arg "sbytes_of_ins: tried to serialize a label!"
    | _ -> ()
  in
  List.iter check args;
  [InsB0 (op, args); InsFrag; InsFrag; InsFrag;
   InsFrag; InsFrag; InsFrag; InsFrag]

(* Serialize a data element to sbytes *)
let sbytes_of_data : data -> sbyte list = function
  | Quad (Lit i) -> sbytes_of_int64 i
  | Asciz s -> sbytes_of_string s
  | Quad (Lbl _) -> invalid_arg "sbytes_of_data: tried to serialize a label!"


(* It might be useful to toggle printing of intermediate states of your 
   simulator. Our implementation uses this mutable flag to turn on/off
   printing.  For instance, you might write something like:

     [if !debug_simulator then print_endline @@ string_of_ins u; ...]

*)
let debug_simulator = ref false


(* override some useful operators  *)
let ( +. ) = Int64.add
let ( -. ) = Int64.sub
let ( *. ) = Int64.mul
let ( <. ) a b = (Int64.compare a b) < 0
let ( >. ) a b = (Int64.compare a b) > 0
let ( <=. ) a b = (Int64.compare a b) <= 0
let ( >=. ) a b = (Int64.compare a b) >= 0

(* Interpret a condition code with respect to the given flags. *)
(* !!! Check the Specification for Help *)
let interp_cnd {fo; fs; fz} : cnd -> bool = function
  | Eq -> fz
  | Neq -> not fz
  | Lt -> fs <> fo
  | Le -> fz || (fs <> fo)
  | Ge -> fs = fo
  | Gt -> (not fz) && (fs = fo)


(* Maps an X86lite address into Some OCaml array index,
   or None if the address is not within the legal address space. *)
let map_addr (addr:quad) : int option =
  if addr >=. mem_bot && addr <. mem_top then 
    Some (Int64.to_int(addr -. mem_bot))
  else None

(* Your simulator should raise this exception if it tries to read from or
   store to an address not within the valid address space. *)
exception X86lite_segfault

(* Raise X86lite_segfault when addr is invalid. *)
let map_addr_segfault (addr:quad) : int =
  match map_addr addr with
  | Some i -> i
  | None -> raise X86lite_segfault
(* Simulates one step of the machine:
    - fetch the instruction at %rip
    - compute the source and/or destination information from the operands
    - simulate the instruction semantics
    - update the registers and/or memory appropriately
    - set the condition flags

  We provide the basic structure of step function and helper functions.
  Implement the subroutine below to complete the step function.
  See step function to understand each subroutine and how they 
  are glued together.
*)

let readquad (m:mach) (addr:quad) : quad =
int64_of_sbytes 
  (List.init 8 (fun i ->
    let a = addr +. (Int64.of_int i) in
    let idx = map_addr_segfault a in
    m.mem.(idx)
    ))

(* 首先，int64_of_sbytes，因为输出是int64
  其次，应该使用+.*)


let writequad (m:mach) (addr:quad) (w:quad) : unit =
  let byte = sbytes_of_int64 w in
  List.iteri (fun i _ ->
    let a = addr +. Int64.of_int i in 
    ignore(map_addr_segfault a) 
    )byte;
  List.iteri (fun i element ->
    let a = addr +. Int64.of_int i in 
    let idx = map_addr_segfault a in 
    m.mem.(idx) <- element
    )byte
  (* failwith "writequad not implemented" *)

(* 
List.iteri 会遍历列表，同时提供元素下标：
List.iteri (fun i element ->
  (* 使用 i 和 element *)
) list


List.iteri 的回调必须返回 unit
它的类型是：
List.iteri : (int -> 'a -> unit) -> 'a list -> unit
第一个参数是回调函数，接收下标和元素，每次调用必须返回 unit。
你的第一遍遍历最后写的是：
map_addr_segfault a
这个表达式返回 int，所以回调返回了整数，与 List.iteri 要求的 unit 不匹配。
这里你只想确认地址合法，不需要保存下标，可以使用：
ignore (map_addr_segfault a)
ignore 的含义是：先执行参数表达式，再丢弃它的返回值，返回 ()。




第一遍遍历
第二遍遍历
OCaml 中，换行不是语句分隔符。连续写两个表达式，编译器可能把后面的内容当成前面函数调用的额外参数，导致“参数过多”等类型错误。
要表达“先执行 A，再执行 B”，使用：
表达式A;
表达式B
所以第一遍遍历结束处应该是：
) byte;
第二遍结束处仍然是：
) byte


*)

let fetchins (m:mach) (addr:quad) : ins =
  let idx = map_addr_segfault addr in 
  match m.mem.(idx) with
  | InsB0 ins -> ins
  | InsFrag -> failwith "expected an instruction"
  | Byte _ -> failwith "expected an instruction"
  (* failwith "fetchins not implemented" *)

let effective_addr (m:mach) : operand -> quad = function
  | Ind1 (Lit addr) -> addr
  | Ind2 r -> m.regs.(rind r)
  | Ind3 (Lit offset, r) -> offset +. m.regs.(rind r)
  | _ -> invalid_arg "effective_addr: expected a resolved memory operand"

let shift_amount (amount:quad) : int =
  Int64.to_int (Int64.logand amount 0x3fL)

(* Compute the instruction result.
 * NOTE: See int64_overflow.ml for the definition of the return type
*  Int64_overflow.t. *)
let interp_opcode (m: mach) (o:opcode) (args:int64 list) : Int64_overflow.t = 
    let open Int64 in
    let open Int64_overflow in
    match o, args with
    | Negq , [value] -> neg value
    | Incq , [value] -> succ value
    | Decq , [value] -> pred value

    | Addq , [src; dst] -> add dst src
    | Subq , [src; dst] -> sub dst src
    | Imulq , [src; dst] -> mul dst src

    | Andq , [src; dst] -> ok (Int64.logand dst src)
    | Orq , [src; dst] -> ok (Int64.logor dst src)
    | Xorq , [src; dst] -> ok (Int64.logxor dst src)
    | Notq , [v] -> ok (Int64.lognot v)

    |Cmpq , [src; dst] -> sub dst src
    |Movq , [src; _] -> ok src

    |Leaq, [src; _] -> ok src 
    |Shlq, [sh; dst] -> ok (shift_left dst (shift_amount sh))
    |Sarq, [sh; dst] -> ok (shift_right dst (shift_amount sh))
    |Shrq, [sh; dst] -> ok (shift_right_logical dst (shift_amount sh))

    |Set condition , [_] -> ok (if interp_cnd m.flags condition then 1L else 0L)
    |Jmp,  [target] ->  ok target
    |J condition, [target] -> 
      if interp_cnd m.flags condition then ok target
      else ok m.regs.(rind Rip)
    (* | Callq, [target] -> ok target
    | Retq, []        -> ok 0L *)

    
    | _ -> invalid_arg "interp_opcode: unsupported instruction or operands"

(** Update machine state with instruction results. *)
let ins_writeback (m: mach) : ins -> int64 -> unit =
  fun (op, args) result ->
    let write_quad = function
      | Reg r -> m.regs.(rind r) <- result
      | dst -> writequad m (effective_addr m dst) result
    in
    let write_byte = function
      | Reg r ->
          let upper = Int64.logand m.regs.(rind r) (Int64.lognot 0xffL) in
          let lower = Int64.logand result 0xffL in
          m.regs.(rind r) <- Int64.logor upper lower
      | dst ->
          let idx = map_addr_segfault (effective_addr m dst) in
          let lower = Int64.to_int (Int64.logand result 0xffL) in
          m.mem.(idx) <- Byte (Char.chr lower)
    in
    match op, args with
    | Cmpq, [_; _] -> ()
    | (Jmp | J _), [_] -> m.regs.(rind Rip) <- result
    | Set _, [dst] -> write_byte dst
    | (Negq | Incq | Decq | Notq), [dst] -> write_quad dst
    | (Movq | Leaq | Addq | Subq | Imulq | Andq | Orq | Xorq
      | Shlq | Sarq | Shrq), [_; dst] -> write_quad dst
    | _ -> invalid_arg "ins_writeback: unsupported instruction"


(* mem addr ---> mem array index *)
let interp_operands (m:mach) : ins -> int64 list =
  fun (op, args) ->
    let read_operand = function
      | Imm (Lit value) -> value
      | Reg r -> m.regs.(rind r)
      | (Ind1 _ | Ind2 _ | Ind3 _) as operand ->
          readquad m (effective_addr m operand)
      | Imm (Lbl _) -> invalid_arg "interp_operands: unresolved label"
    in
    match op, args with
    | Movq, [src; _] -> [read_operand src; 0L]
    | Leaq, [src; _] -> [effective_addr m src; 0L]
    | Set _, [_] -> [0L]
    | _ -> List.map read_operand args

let validate_operands : ins -> unit = function
  | ins ->
      let memory = function
        | Ind1 _ | Ind2 _ | Ind3 _ -> true
        | Imm _ | Reg _ -> false
      in
      let location = function
        | Reg _ | Ind1 _ | Ind2 _ | Ind3 _ -> true
        | Imm _ -> false
      in
      let check condition =
        if not condition then invalid_arg "validate_operands: invalid operands"
      in
      let op, args = ins in
      List.iter (function
        | Imm (Lbl _) | Ind1 (Lbl _) | Ind3 (Lbl _, _) ->
            invalid_arg "validate_operands: unresolved label"
        | _ -> ()) args;
      match op, args with
      | Retq, [] -> ()
      | (Pushq | Callq | Jmp | J _), [_] -> ()
      | (Popq | Negq | Incq | Decq | Notq | Set _), [dst] ->
          check (location dst)
      | Leaq, [src; dst] ->
          check (memory src && location dst && not (memory dst))
      | Imulq, [_; Reg _] -> ()
      | (Shlq | Sarq | Shrq), [amount; dst] ->
          let valid_amount = match amount with
            | Imm (Lit _) | Reg Rcx -> true
            | _ -> false
          in
          check (valid_amount && location dst)
      | (Movq | Addq | Subq | Cmpq | Andq | Orq | Xorq), [src; dst] ->
          check (location dst && not (memory src && memory dst))
      | _ -> invalid_arg "validate_operands: invalid instruction"


let crack : ins -> ins list = function
  | Pushq, [src] -> 
    [
      (Subq, [Imm (Lit 8L ); Reg Rsp]);
      (Movq, [src; Ind2 Rsp])
    ]
  | Popq, [dst] -> 
    [
      (Movq, [Ind2 Rsp; dst]);
      (Addq, [Imm (Lit 8L); Reg Rsp])
    ]
  | Callq, [target] -> 
    [
      (Subq, [Imm (Lit 8L); Reg Rsp]);
      (Movq, [Reg Rip; Ind2 Rsp]);
      (Jmp, [target])
    ]
  | Retq, [] -> 
    [
      (Movq, [Ind2 Rsp; Reg Rip]);
      (Addq, [Imm (Lit 8L); Reg Rsp])
    ]
  | ins -> [ins]
  (* | _ -> failwith "crack not implemented" *)

(* 最后一行为什么不是 _？
| ins -> [ins]
变量 ins 保存匹配到的原指令，[ins] 把它包装成单元素列表。例如普通 Addq 不需要拆分，就返回它自身。
 *)

 
let set_flags (m:mach) (op:opcode) (ws: quad list) (w : Int64_overflow.t) : unit =
  let set_sign_zero () =
    m.flags.fs <- w.value <. 0L;
    m.flags.fz <- w.value = 0L
  in
  match op with
  | Negq | Incq | Decq | Addq | Subq | Cmpq ->
      set_sign_zero ();
      m.flags.fo <- w.overflow
  | Imulq -> m.flags.fo <- w.overflow
  | Andq | Orq | Xorq ->
      set_sign_zero ();
      m.flags.fo <- false
  | Shlq | Sarq | Shrq ->
      (match ws with
       | [amount; original] ->
           let amount = shift_amount amount in
           if amount <> 0 then begin
             set_sign_zero ();
             if amount = 1 then
               m.flags.fo <- (match op with
                 | Sarq -> false
                 | Shrq -> original <. 0L
                 | Shlq ->
                     (original <. 0L) <> (Int64.shift_left original 1 <. 0L)
                 | _ -> assert false)
           end
       | _ -> invalid_arg "set_flags: invalid shift operands")
  | Movq | Leaq | Notq | Set _ | Jmp | J _
  | Pushq | Popq | Callq | Retq -> ()

let step (m:mach) : unit =
  (* execute an instruction *)
  let (op, args) as ins = fetchins m m.regs.(rind Rip) in
  validate_operands ins;
  
  (* Some instructions involve running two or more basic instructions. 
   * For other instructions, just return a list of one instruction.
   * See the X86lite specification for details. *)
  let uops: ins list = crack (op,args) in

  m.regs.(rind Rip) <- m.regs.(rind Rip) +. ins_size;

  List.iter
    (fun (uop,_ as u) ->
     if !debug_simulator then print_endline @@ string_of_ins u;
     let ws = interp_operands m u in
     let res = interp_opcode m uop ws in
     ins_writeback m u @@ res.Int64_overflow.value;
     set_flags m op ws res
    ) uops

(* Runs the machine until the rip register reaches a designated
   memory address. Returns the contents of %rax when the 
   machine halts. *)
let run (m:mach) : int64 = 
  while m.regs.(rind Rip) <> exit_addr do step m done;
  m.regs.(rind Rax)

(* assembling and linking --------------------------------------------------- *)

(* A representation of the executable *)
type exec = { entry    : quad              (* address of the entry point *)
            ; text_pos : quad              (* starting address of the code *)
            ; data_pos : quad              (* starting address of the data *)
            ; text_seg : sbyte list        (* contents of the text segment *)
            ; data_seg : sbyte list        (* contents of the data segment *)
            }

(* Assemble should raise this when a label is used but not defined *)
exception Undefined_sym of lbl

(* Assemble should raise this when a label is defined more than once *)
exception Redefined_sym of lbl

(* Convert an X86 program into an object file:
   - separate the text and data segments
   - compute the size of each segment
      Note: the size of an Asciz string section is (1 + the string length)
            due to the null terminator

   - resolve the labels to concrete addresses and 'patch' the instructions to 
     replace Lbl values with the corresponding Imm values.
     HINT: consider building a mapping from symboli Lbl to memory address

   - the text segment starts at the lowest address
   - the data segment starts after the text segment

  HINT: List.fold_left and List.fold_right are your friends.
 *)
let is_size (is: ins list): quad = 
  Int64.of_int (List.length is) *. ins_size

let ds_size (ds: data list): quad = 
  let size_of_data (d: data) : quad =
    match d with
    | Quad _ -> 8L
    | Asciz s -> Int64.of_int (String.length s + 1)
  in
  List.fold_left (fun acc d -> acc +. size_of_data d) 0L ds
  

let assemble (p:prog) : exec =
(* pass1 *)
  (* split text and data *)
  let is_text (e: elem) : bool =
    match e.asm with
    | Text _ -> true
    | Data _ -> false
  in
  let is_data (e: elem) : bool =
    match e.asm with
    | Data _ -> true
    | Text _ -> false
  in
  let text_elems = List.filter is_text p in
  let data_elems = List.filter is_data p in
  (* parse one block *) 
  let add_sym (addr, current_table) (e: elem) =
    let label_name = e.lbl in
    (* whether label already exists *)
    let already_exists = List.mem_assoc label_name current_table in
    if already_exists then
      raise (Redefined_sym label_name)
    else
      (* size *)
      let block_size = match e.asm with
        | Text instructions -> is_size instructions
        | Data data_items   -> ds_size data_items
      in
      (* next address *)
      let next_addr = addr +. block_size in
      (* new table *)
      let new_table = (label_name, addr) :: current_table in
      (next_addr, new_table)
  in
  (* ins *)
  let text_pos = mem_bot in
  let (data_pos, symtab_after_text) = List.fold_left add_sym (text_pos, []) text_elems in
  (* data *)
  let (_, full_symtab) = List.fold_left add_sym (data_pos, symtab_after_text) data_elems in
  (* main *)
  let entry = match List.assoc_opt "main" full_symtab with
    | Some main_address -> main_address
    | None -> raise (Undefined_sym "main")
  in

(* pass2 *)
  (* patch immediate *)
  let patch_imm (i: imm) : imm =
    match i with
    | Lit n -> Lit n
    | Lbl name ->
        match List.assoc_opt name full_symtab with
        | Some addr -> Lit addr
        | None -> raise (Undefined_sym name)
  in

  (* patch operand *)
  let patch_operand (op: operand) : operand =
    match op with
    | Imm i       -> Imm (patch_imm i)
    | Reg r       -> Reg r
    | Ind1 i      -> Ind1 (patch_imm i)
    | Ind2 r      -> Ind2 r
    | Ind3 (i, r) -> Ind3 (patch_imm i, r)
  in

  (* patch instruction *)
  let patch_ins (op, args : ins) : ins =
    let patched_args = List.map patch_operand args in
    (op, patched_args)
  in

  (* patch data *)
  let patch_data (d: data) : data =
    match d with
    | Asciz s -> Asciz s
    | Quad i  -> Quad (patch_imm i)
  in

  (* serialize text segment *)
  let process_one_text_elem (e: elem) : sbyte list =
    match e.asm with
    | Text instructions ->
        let patched_instructions = List.map patch_ins instructions in
        List.concat_map sbytes_of_ins patched_instructions
    | Data _ -> []
  in
  let text_seg = List.concat_map process_one_text_elem text_elems in

  (* serialize data segment *)
  let process_one_data_elem (e: elem) : sbyte list =
    match e.asm with
    | Data data_items ->
        let patched_items = List.map patch_data data_items in
        List.concat_map sbytes_of_data patched_items
    | Text _ -> []
  in
  let data_seg = List.concat_map process_one_data_elem data_elems in

  (* return executable *)
  { entry = entry;
    text_pos = text_pos;
    data_pos = data_pos;
    text_seg = text_seg;
    data_seg = data_seg;
  }



(* Convert an object file into an executable machine state. 
    - allocate the mem array
    - set up the memory state by writing the symbolic bytes to the 
      appropriate locations 
    - create the inital register state
      - initialize rip to the entry point address
      - initializes rsp to the last word in memory 
      - the other registers are initialized to 0
    - the condition code flags start as 'false'

  Hint: The Array.make, Array.blit, and Array.of_list library functions 
  may be of use.
*)
let load {entry; text_pos; data_pos; text_seg; data_seg} : mach = 
  (* init mem *)
  let m_mem = Array.make mem_size (Byte '\x00') in
  let text_offset = map_addr_segfault text_pos in
  List.iteri (fun i b -> m_mem.(text_offset + i) <- b) text_seg;
  let data_offset = map_addr_segfault data_pos in
  List.iteri (fun i b -> m_mem.(data_offset + i) <- b) data_seg;

  (* init regs *)
  let m_regs = Array.make nregs 0L in
  m_regs.(rind Rip) <- entry;
  m_regs.(rind Rsp) <- mem_top -. 8L;

  (* go *)
  let m = {
    flags = { fo = false; fs = false; fz = false };
    regs = m_regs;
    mem = m_mem;
  } in
  writequad m (mem_top -. 8L) exit_addr;
  m
