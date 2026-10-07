module Program = struct
  let v_X = ref 0
  let v_ANS = ref 0
  let run () = 
  v_X.contents <- 6;
  v_ANS.contents <- 1;
  while v_X.contents <> 0 do
    v_ANS.contents <- (v_ANS.contents * v_X.contents);
    v_X.contents <- (v_X.contents + -1) 
  done
end

let main() = 
  let _ = Program.run() in
  let ans = !Program.v_ANS in
  Printf.printf "ANS = %d\n" (ans)

;; main ()