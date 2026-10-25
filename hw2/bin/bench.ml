(* Temporary benchmark: measure simulator throughput (steps/sec).
   main:
     movq $1000000, %rcx
     leaq buf, %rbx
   loop:
     movq (%rbx), %rax
     incq %rax
     movq %rax, (%rbx)
     addq $3, %rax
     xorq $1, %rax
     cmpq $100, %rax
     jle skip
     movq $0, %rax
   skip:
     decq %rcx
     cmpq $0, %rcx
     jne loop
     retq
   buf: .quad 0
   10 instructions per iteration (jle always taken, movq $0 skipped). *)
open X86

let prog : prog =
  [ { lbl = "main"; global = true; asm = Text
        [ Movq, [Imm (Lit 1_000_000L); Reg Rcx]
        ; Leaq, [Ind1 (Lbl "buf"); Reg Rbx] ] }
  ; { lbl = "loop"; global = false; asm = Text
        [ Movq, [Ind2 Rbx; Reg Rax]
        ; Incq, [Reg Rax]
        ; Movq, [Reg Rax; Ind2 Rbx]
        ; Addq, [Imm (Lit 3L); Reg Rax]
        ; Xorq, [Imm (Lit 1L); Reg Rax]
        ; Cmpq, [Imm (Lit 100L); Reg Rax]
        ; J Le, [Imm (Lbl "skip")]
        ; Movq, [Imm (Lit 0L); Reg Rax] ] }
  ; { lbl = "skip"; global = false; asm = Text
        [ Decq, [Reg Rcx]
        ; Cmpq, [Imm (Lit 0L); Reg Rcx]
        ; J Neq, [Imm (Lbl "loop")]
        ; Retq, [] ] }
  ; { lbl = "buf"; global = false; asm = Data [ Quad (Lit 0L) ] } ]

let prog2 : prog =
  [ { lbl = "main"; global = true; asm = Text
        [ Incq, [Reg Rax]; Jmp, [Imm (Lbl "main")] ] } ]

let () =
  let module S = Sim.Simulator in
  (* minimal 2-ins loop: measures per-step fixed cost *)
  let m2 = S.load (S.assemble prog2) in
  let t = Unix.gettimeofday () in
  for _ = 1 to 3_000_000 do S.step m2 done;
  let st2 = Gc.quick_stat () in
  Printf.printf "minimal: 3M steps in %.3f s  minor_words=%.0fM\n"
    (Unix.gettimeofday () -. t) (st2.Gc.minor_words /. 1e6);
  let t0 = Unix.gettimeofday () in
  let exec = S.assemble prog in
  let m = S.load exec in
  let result = S.run m in
  let t1 = Unix.gettimeofday () in
  let elapsed = t1 -. t0 in
  (* 2 setup + 10 per iteration * 1e6 + 1 retq *)
  let steps = 10_000_003.0 in
  let st = Gc.quick_stat () in
  Printf.printf "minor=%.0fM major=%.0fM minor_gc=%d major_gc=%d compactions=%d\n"
    (st.Gc.minor_words /. 1e6) (st.Gc.major_words /. 1e6)
    st.Gc.minor_collections st.Gc.major_collections st.Gc.compactions;
  Printf.printf "rax=%Ld  elapsed: %.3f s  steps: %.0f  throughput: %.2fM steps/s\n"
    result elapsed steps (steps /. elapsed /. 1e6)
