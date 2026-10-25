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
  if addr >=. mem_bot && addr <. mem_top then
    Int64.to_int (addr -. mem_bot)
  else raise X86lite_segfault
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

(* Preallocated immutable Byte blocks.  Writing a byte into memory reuses
   one of these blocks instead of allocating a fresh one on every store,
   which keeps the garbage collector out of the simulator's hot loop. *)
let byte_cache : sbyte array =
  Array.init 256 (fun i -> Byte (Char.chr i))

let readquad (m:mach) (addr:quad) : quad =
  let i = map_addr_segfault addr in
  let mem = m.mem in
  if i + 7 < mem_size then begin
    (* fast path: all 8 bytes are in bounds *)
    let b k = match mem.(i + k) with
      | Byte c -> Char.code c
      | _ -> 0
    in
    let lo = (b 0) lor ((b 1) lsl 8) lor ((b 2) lsl 16) lor ((b 3) lsl 24) in
    let hi = (b 4) lor ((b 5) lsl 8) lor ((b 6) lsl 16) lor ((b 7) lsl 24) in
    Int64.logor (Int64.of_int lo) (Int64.shift_left (Int64.of_int hi) 32)
  end else
    int64_of_sbytes
      (List.init 8 (fun k ->
         let idx = map_addr_segfault (addr +. (Int64.of_int k)) in
         mem.(idx)
      ))

let writequad (m:mach) (addr:quad) (w:quad) : unit =
  let i = map_addr_segfault addr in
  let mem = m.mem in
  if i + 7 < mem_size then begin
    (* fast path: all 8 bytes are in bounds *)
    let lo = Int64.to_int (Int64.logand w 0xffffffffL) in
    let hi = Int64.to_int (Int64.shift_right_logical w 32) in
    mem.(i)     <- byte_cache.(lo land 0xff);
    mem.(i + 1) <- byte_cache.((lo lsr 8) land 0xff);
    mem.(i + 2) <- byte_cache.((lo lsr 16) land 0xff);
    mem.(i + 3) <- byte_cache.((lo lsr 24) land 0xff);
    mem.(i + 4) <- byte_cache.(hi land 0xff);
    mem.(i + 5) <- byte_cache.((hi lsr 8) land 0xff);
    mem.(i + 6) <- byte_cache.((hi lsr 16) land 0xff);
    mem.(i + 7) <- byte_cache.((hi lsr 24) land 0xff)
  end else begin
    (* slow path (crosses the top of memory): check every address first,
       then write, so that an invalid write touches no bytes *)
    let byte = sbytes_of_int64 w in
    List.iteri (fun k _ ->
      let a = addr +. (Int64.of_int k) in
      ignore (map_addr_segfault a)
    ) byte;
    List.iteri (fun k element ->
      let idx = map_addr_segfault (addr +. (Int64.of_int k)) in
      mem.(idx) <- element
    ) byte
  end

let fetchins (m:mach) (addr:quad) : ins =
  let idx = map_addr_segfault addr in 
  match m.mem.(idx) with
  | InsB0 ins -> ins
  | InsFrag -> failwith "expected an instruction"
  | Byte _ -> failwith "expected an instruction"

let effective_addr (m:mach) : operand -> quad = function
  | Ind1 (Lit addr) -> addr
  | Ind2 r -> m.regs.(rind r)
  | Ind3 (Lit offset, r) -> offset +. m.regs.(rind r)
  | _ -> invalid_arg "effective_addr: expected a resolved memory operand"

let shift_amount (amount:quad) : int =
  Int64.to_int (Int64.logand amount 0x3fL)

(* Native-arithmetic versions of the Int64_overflow operations.  They
   compute the same values and overflow flags, but avoid the
   big-integer conversions, which are far too slow in the hot path. *)
let mk_ovf (value:quad) (overflow:bool) : Int64_overflow.t =
  { Int64_overflow.value = value; Int64_overflow.overflow = overflow }

let neg_ovf (i:quad) : Int64_overflow.t =
  mk_ovf (Int64.neg i) (Int64.equal i Int64.min_int)
let succ_ovf (i:quad) : Int64_overflow.t =
  mk_ovf (Int64.succ i) (Int64.equal i Int64.max_int)
let pred_ovf (i:quad) : Int64_overflow.t =
  mk_ovf (Int64.pred i) (Int64.equal i Int64.min_int)
let add_ovf (i:quad) (j:quad) : Int64_overflow.t =
  let res = Int64.add i j in
  mk_ovf res ((i <. 0L) = (j <. 0L) && (res <. 0L) <> (i <. 0L))
let sub_ovf (i:quad) (j:quad) : Int64_overflow.t =
  let res = Int64.sub i j in
  mk_ovf res ((i <. 0L) <> (j <. 0L) && (res <. 0L) <> (i <. 0L))
let mul_ovf (i:quad) (j:quad) : Int64_overflow.t =
  let res = Int64.mul i j in
  let overflow =
    if Int64.equal i 0L || Int64.equal j 0L then false
    else if Int64.equal i (-1L) || Int64.equal j (-1L)
    then Int64.equal res Int64.min_int
    else Int64.div res j <> i
  in
  mk_ovf res overflow

(* Compute the instruction result.
 * NOTE: See int64_overflow.ml for the definition of the return type
*  Int64_overflow.t. *)
let interp_opcode (m: mach) (o:opcode) (args:int64 list) : Int64_overflow.t =
  let ok = Int64_overflow.ok in
  match o, args with
  | Negq , [value] -> neg_ovf value
  | Incq , [value] -> succ_ovf value
  | Decq , [value] -> pred_ovf value

  | Addq , [src; dst] -> add_ovf dst src
  | Subq , [src; dst] -> sub_ovf dst src
  | Imulq , [src; dst] -> mul_ovf dst src

  | Andq , [src; dst] -> ok (Int64.logand dst src)
  | Orq , [src; dst] -> ok (Int64.logor dst src)
  | Xorq , [src; dst] -> ok (Int64.logxor dst src)
  | Notq , [v] -> ok (Int64.lognot v)

  |Cmpq , [src; dst] -> sub_ovf dst src
  |Movq , [src; _] -> ok src

  |Leaq, [src; _] -> ok src
  |Shlq, [sh; dst] -> ok (Int64.shift_left dst (shift_amount sh))
  |Sarq, [sh; dst] -> ok (Int64.shift_right dst (shift_amount sh))
  |Shrq, [sh; dst] -> ok (Int64.shift_right_logical dst (shift_amount sh))

  |Set condition , [_] -> ok (if interp_cnd m.flags condition then 1L else 0L)
  |Jmp,  [target] ->  ok target
  |J condition, [target] ->
    if interp_cnd m.flags condition then ok target
    else ok m.regs.(rind Rip)
  | _ -> invalid_arg "interp_opcode: unsupported instruction or operands"

(** Write an instruction result to a register or memory location. *)
let write_result (m: mach) (result:quad) (dst:operand) : unit =
  match dst with
  | Reg r -> m.regs.(rind r) <- result
  | dst -> writequad m (effective_addr m dst) result

(** setb writes only the lowest byte of its destination. *)
let write_result_byte (m: mach) (result:quad) (dst:operand) : unit =
  match dst with
  | Reg r ->
      let upper = Int64.logand m.regs.(rind r) (Int64.lognot 0xffL) in
      let lower = Int64.logand result 0xffL in
      m.regs.(rind r) <- Int64.logor upper lower
  | dst ->
      let idx = map_addr_segfault (effective_addr m dst) in
      m.mem.(idx) <- byte_cache.(Int64.to_int (Int64.logand result 0xffL))

(** Update machine state with instruction results. *)
let ins_writeback (m: mach) : ins -> int64 -> unit =
  fun (op, args) result ->
    match op, args with
    | Cmpq, [_; _] -> ()
    | (Jmp | J _), [_] -> m.regs.(rind Rip) <- result
    | Set _, [dst] -> write_result_byte m result dst
    | (Negq | Incq | Decq | Notq), [dst] -> write_result m result dst
    | (Movq | Leaq | Addq | Subq | Imulq | Andq | Orq | Xorq
      | Shlq | Sarq | Shrq), [_; dst] -> write_result m result dst
    | _ -> invalid_arg "ins_writeback: unsupported instruction"


(* Read the value of an operand from the machine state. *)
let read_operand (m:mach) : operand -> int64 = function
  | Imm (Lit value) -> value
  | Reg r -> m.regs.(rind r)
  | (Ind1 _ | Ind2 _ | Ind3 _) as operand ->
      readquad m (effective_addr m operand)
  | Imm (Lbl _) -> invalid_arg "read_operand: unresolved label"

(* Evaluate the operand values of an instruction. *)
let interp_operands (m:mach) ((op, args):ins) : int64 list =
  match op, args with
  | Movq, [src; _] -> [read_operand m src; 0L]
  | Leaq, [src; _] -> [effective_addr m src; 0L]
  | Set _, [_] -> [0L]
  | _ -> List.map (read_operand m) args

let is_mem_operand : operand -> bool = function
  | Ind1 _ | Ind2 _ | Ind3 _ -> true
  | Imm _ | Reg _ -> false

let is_writable : operand -> bool = function
  | Reg _ | Ind1 _ | Ind2 _ | Ind3 _ -> true
  | Imm _ -> false

(* Reject operands that still refer to unresolved labels. *)
let check_resolved : operand list -> unit =
  List.iter (function
    | Imm (Lbl _) | Ind1 (Lbl _) | Ind3 (Lbl _, _) ->
        invalid_arg "validate_operands: unresolved label"
    | _ -> ())

let require condition =
  if not condition then invalid_arg "validate_operands: invalid operands"

let validate_operands : ins -> unit = function
  | ins ->
      let op, args = ins in
      check_resolved args;
      match op, args with
      | Retq, [] -> ()
      | (Pushq | Callq | Jmp | J _), [_] -> ()
      | (Popq | Negq | Incq | Decq | Notq | Set _), [dst] ->
          require (is_writable dst)
      | Leaq, [src; dst] ->
          require (is_mem_operand src && is_writable dst
                   && not (is_mem_operand dst))
      | Imulq, [_; Reg _] -> ()
      | (Shlq | Sarq | Shrq), [amount; dst] ->
          let valid_amount = match amount with
            | Imm (Lit _) | Reg Rcx -> true
            | _ -> false
          in
          require (valid_amount && is_writable dst)
      | (Movq | Addq | Subq | Cmpq | Andq | Orq | Xorq), [src; dst] ->
          require (is_writable dst
                   && not (is_mem_operand src && is_mem_operand dst))
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

(* TODO: double check against spec *)
let set_sign_zero (m:mach) (v:quad) : unit =
  m.flags.fs <- v <. 0L;
  m.flags.fz <- v = 0L

let set_flags (m:mach) (op:opcode) (ws: quad list) (w : Int64_overflow.t) : unit =
  match op with
  | Negq | Incq | Decq | Addq | Subq | Cmpq ->
      set_sign_zero m w.value;
      m.flags.fo <- w.overflow
  | Imulq -> m.flags.fo <- w.overflow
  | Andq | Orq | Xorq ->
      set_sign_zero m w.value;
      m.flags.fo <- false
  | Shlq | Sarq | Shrq ->
      (match ws with
       | [amount; original] ->
           let amount = shift_amount amount in
           if amount <> 0 then begin
             set_sign_zero m w.value;
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
  let add_sym (addr, current_table) (e: elem) =
    let label_name = e.lbl in
    let already_exists = List.mem_assoc label_name current_table in
    if already_exists then
      raise (Redefined_sym label_name)
    else
      let block_size = match e.asm with
        | Text instructions -> is_size instructions
        | Data data_items   -> ds_size data_items
      in
      let next_addr = addr +. block_size in
      let new_table = (label_name, addr) :: current_table in
      (next_addr, new_table)
  in
  let text_pos = mem_bot in
  let (data_pos, symtab_after_text) = List.fold_left add_sym (text_pos, []) text_elems in
  let (_, full_symtab) = List.fold_left add_sym (data_pos, symtab_after_text) data_elems in
  let entry = match List.assoc_opt "main" full_symtab with
    | Some main_address -> main_address
    | None -> raise (Undefined_sym "main")
  in

  let patch_imm (i: imm) : imm =
    match i with
    | Lit n -> Lit n
    | Lbl name ->
        match List.assoc_opt name full_symtab with
        | Some addr -> Lit addr
        | None -> raise (Undefined_sym name)
  in

  let patch_operand (op: operand) : operand =
    match op with
    | Imm i       -> Imm (patch_imm i)
    | Reg r       -> Reg r
    | Ind1 i      -> Ind1 (patch_imm i)
    | Ind2 r      -> Ind2 r
    | Ind3 (i, r) -> Ind3 (patch_imm i, r)
  in

  let patch_ins (op, args : ins) : ins =
    let patched_args = List.map patch_operand args in
    (op, patched_args)
  in

  let patch_data (d: data) : data =
    match d with
    | Asciz s -> Asciz s
    | Quad i  -> Quad (patch_imm i)
  in

  let process_one_text_elem (e: elem) : sbyte list =
    match e.asm with
    | Text instructions ->
        let patched_instructions = List.map patch_ins instructions in
        List.concat_map sbytes_of_ins patched_instructions
    | Data _ -> []
  in
  let text_seg = List.concat_map process_one_text_elem text_elems in

  let process_one_data_elem (e: elem) : sbyte list =
    match e.asm with
    | Data data_items ->
        let patched_items = List.map patch_data data_items in
        List.concat_map sbytes_of_data patched_items
    | Text _ -> []
  in
  let data_seg = List.concat_map process_one_data_elem data_elems in

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
  let m_mem = Array.make mem_size (Byte '\x00') in
  let text_offset = map_addr_segfault text_pos in
  List.iteri (fun i b -> m_mem.(text_offset + i) <- b) text_seg;
  let data_offset = map_addr_segfault data_pos in
  List.iteri (fun i b -> m_mem.(data_offset + i) <- b) data_seg;

  let m_regs = Array.make nregs 0L in
  m_regs.(rind Rip) <- entry;
  m_regs.(rind Rsp) <- mem_top -. 8L;

  let m = {
    flags = { fo = false; fs = false; fz = false };
    regs = m_regs;
    mem = m_mem;
  } in
  writequad m (mem_top -. 8L) exit_addr;
  m
