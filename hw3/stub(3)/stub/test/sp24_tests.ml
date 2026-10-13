let dir = "llprograms/sp24_hw3/"

(* Test cases that don't use any IO.

   - These test cases consist of a single `.ll` file with the standard "main"
     entry point.

   ```
   define i64 @main(i64 %argc, i8** %arcv) {
    %res = ...
    ret i64 %res
   }
   ```
   - each test's name will be expanded to: "llprograms/sp24_hw3/<name>.ll"

   - each test should specify the expected result (which will be returned by
     executing the compiled ll program)

   To add a new test case in this style:

   - create the test program `llprograms/sp24_hw3/<name>.ll`
   - add "<name>", resL to the list of tests below

   - we have given you the `add.ll` test case as an example
*)
let tests =
  List.map (fun (name, output) -> (dir ^ name ^ ".ll", output)) [
    "add", 14L;
    "mariaagn_matrixsum", 126L;
    "gabsmi_hojack", 1L;
    "selection_sort", 1L;     (*neelesh-neelay-mia*)
    "majority_element", 1L; (*vikbala-joshuavalluru*)
    "binary_search", 8L;    (*joyliu_liuchris*)
    "quicksort", 1L;        (* hanxic *)
    "max_tree", 1L;         (* rywang, aarushis *)
    "insertion_sort", 1L; (* szhang25, hwisang *)
    "bubblesort", 5L;         (* eloicl, tomhol *)
    "fibonacci", 5L;          (* socoobo *)
    "vishnuv_shantz_kadane", 6L;    (* vishnuv, shantz : maximum contiguous subarray problem*)
    "find_power_of_two", 64L;      (* aanten*)
    "single_number", 4L; (*bashista, ruturajn*)
    "longest_incr_subseq", 4L; (* czw, jasonhl *)
    "longest_sub_array_having_sum_k", 6L; (* tindo, sumanthk *)
    "geometric_series", 1L; (*fdustin, geneliu*)
    "longest_incr_subseq", 4L; (* czw, jasonhl *)
    "heapsort", 1L; (*jayvish, leonjh*)
    "horner", 5L; (*ept, shypula*)
    "two_sum", 11L; (*judtin, jasyan*) 
    "knapsack", 1L; (*lohpaul9, bakj*)
    "binary_tree_map", 0L; (* qhy, liuyuhao *)
    "triangle_nums", 0L; (* bqle, huangl24 *)
    "find_duplicate", 3L; (* agorka, hrizwan3 *)
    "is_same_tree", 1L; (* ryu02, yiqingw *)
    "linkedlist_cycle", 0L; (* zhaoer, nlao *)
    "sum_array", 55L; (* liun0, zaksines *)
    "merge_sorted_arrs", 1L; (* alnasir7, jianga *)
    "zhijing_rodrigo", 70L;
    "xuselina_artemisl", 0L;
  ]

(* test cases that consume IO

   - These test cases consist of a single `.ll` file with the standard "main"
     entry point as above.
   - The test case takes in a list of strings that are interpreted as
     command line arguments
   - The expected result is a string containing the output expected by running
     the compiled ll program on the given inputs

   - We have given you the `helloworld.ll` test case (which takes no command
     line arguments) as an example.
   *)
let io_tests =
  List.map (fun (name, input, output) -> (dir ^ name ^ ".ll", input, output)) [
    "helloworld", [], "hello, world!";
    "nnair1_iter", [], "5\n1\n4\n2\n3\n6\n10\n9\n7\n8";
    "quick_sort_with_print", [],
    "2\n1\n3\n5\n4\n1\n2\n3\n4\n5\n2\n1\n3\n5\n4\n3\n1\n2\n5\n4\n2\n1\n3\n5\n4\n3\n2\n1\n3\n4\n5"; (* katltn, turey *)
  ]
