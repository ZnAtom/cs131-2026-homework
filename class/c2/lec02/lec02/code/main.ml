;; open Simple

(* We can write a program that runs the SIMPLE factorial program like this: *)
let main () =
  let prog = (optimize_cmd factorial, init_state) in
  let s_ans = interpret_prog prog in
  Printf.printf "ANS = %d\n" (lookup s_ans "ANS")

;; main ()