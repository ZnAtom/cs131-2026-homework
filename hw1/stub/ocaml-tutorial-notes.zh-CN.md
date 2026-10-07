# OCaml 入门笔记：从函数式编程到小型编译器

这份笔记整理自 HW1 `hellocaml.ml` 中的教程部分。示例全部换成了与作业题目不同的内容，目的是帮助你理解概念并独立完成作业，而不是提供作业答案。

建议学习时同时打开：

- 本笔记：理解概念和运行独立示例。
- `bin/hellocaml.ml`：阅读题目规格并填写自己的实现。
- `test/studenttests.ml`：为自己的实现补充测试。
- `test/gradedtests.ml`：只阅读公开测试以理解规格，不要修改。

## 阅读导航

- 基础工具与语言观念：第 1-2 节
- 类型、绑定和函数：第 3-8 节
- 元组、模式、列表与递归：第 9-15 节
- 自定义类型、模块、异常与环境：第 16-19 节
- AST、解释器、优化器与栈式编译：第 20-25 节
- 测试、调试和解题流程：第 26-28 节
- 自学路线、速查表和自检：第 29-31 节

## 1. 学习和运行方式

### 1.1 在项目中持续检查编译

可以开两个终端。第一个终端持续编译：

```bash
make dev
```

第二个终端随时运行测试：

```bash
make test
```

推荐节奏是：只完成一个很小的函数，保存，确认编译通过，再运行测试。一次修改太多内容后再测试，会让错误难以定位。

### 1.2 使用 `utop` 做小实验

启动交互环境：

```bash
make utop
```

在 `utop` 中，每段输入用 `;;` 结束：

```ocaml
# 10 + 20;;
- : int = 30
```

退出：

```ocaml
# #quit;;
```

注意：`;;` 主要用于交互环境。普通 `.ml` 源文件通常不需要它。

项目由 Dune 加载后，可以通过模块名访问源文件中的定义：

```ocaml
# Hellocaml.double 6;;
```

如果刚修改了源代码，通常要先让项目重新编译；必要时退出并重新启动 `utop`。

## 2. OCaml 的核心思维

OCaml 是强类型、表达式导向的函数式语言。初学时先记住四件事：

1. 名字通常绑定到不可变的值。
2. 函数也是值，可以传给其他函数，也可以由函数返回。
3. `if`、`match`、`let ... in` 都会计算出值。
4. 递归数据通常通过模式匹配和递归函数处理。

函数式程序经常不是“依次修改一堆变量”，而是“把输入转换成新的输出”。例如，对任务名称做标准化时，可以写一个返回新字符串的函数，而不修改原字符串。

这种风格的优势是：相同输入通常产生相同输出，局部函数更容易理解、测试和组合。

## 3. 基本类型与类型检查

常见基本类型：

| 类型 | 示例 | 含义 |
|---|---|---|
| `int` | `0`, `17`, `-4` | 与机器字长相关的整数 |
| `int64` | `0L`, `17L`, `-4L` | 明确的 64 位整数 |
| `bool` | `true`, `false` | 布尔值 |
| `string` | `"compiler"` | 字符串 |
| `char` | `'x'` | 单个字符 |
| `float` | `3.14` | 浮点数 |
| `unit` | `()` | 只有一个值的类型，常用于表示“没有有意义的返回值” |

OCaml 不会隐式混合不同的数值类型：

```ocaml
let item_count : int = 12
let average : float = 12.5
let large_id : int64 = 12L
```

下面这种混合运算不会通过类型检查：

```ocaml
(* 错误示例：int 与 float 不能直接相加 *)
(* let bad = 3 + 1.5 *)
```

常用运算也按类型区分：

```ocaml
let integer_sum = 3 + 4
let float_sum = 3.0 +. 4.0
let wide_sum = Int64.add 3L 4L
```

其中 `+.` 是浮点加法；`Int64.add` 是 `Int64` 模块中的函数。

### 3.1 类型标注与类型推断

显式标注类型：

```ocaml
let course_name : string = "Compilers"
```

让编译器推断：

```ocaml
let course_name = "Compilers"
```

两者类型相同。作业中的顶层函数建议保留参数类型和返回类型，因为类型错误会更容易读懂：

```ocaml
let next_page (page : int) : int = page + 1
```

## 4. `let`、作用域与遮蔽

### 4.1 顶层绑定

```ocaml
let base_price : int = 80
let final_price : int = base_price + 15
```

这里不是先创建一个空盒子再向里面赋值，而是把名字绑定到一个值。

### 4.2 局部绑定

局部 `let` 必须配合 `in`：

```ocaml
let rectangle_area : int =
  let width = 7 in
  let height = 4 in
  width * height
```

`width` 和 `height` 只在后续表达式中可见。

### 4.3 遮蔽不是修改

```ocaml
let label = "draft"
let label = "final"
```

第二个绑定遮蔽了第一个绑定；它并没有修改第一个字符串。阅读较长程序时，频繁遮蔽可能造成困惑，所以应谨慎使用。

### 4.4 `begin ... end` 与括号

在表达式分组方面：

```ocaml
begin expression end
```

基本等价于：

```ocaml
(expression)
```

它不会自动补充 `let ... in`，也不会创建可变代码块。初学阶段优先使用清晰的缩进和必要的括号。

## 5. 函数

### 5.1 匿名函数

```ocaml
let increment : int -> int =
  fun (x : int) -> x + 1
```

```
let funcName : inputType -> outputType =
  fun (inputName : inputType) -> xxx
```

`int -> int` 表示函数接收一个 `int`，返回一个 `int`。

### 5.2 常用函数定义语法

上面的函数通常简写为：

```ocaml
let increment (x : int) : int = x + 1
```

```
let funcName : inputType -> outputType =
  fun (inputName : inputType) -> xxx

let funcName (inputName : inputType) : outputType = xxx
```

两个版本含义相同。

### 5.3 函数调用

OCaml 通过空格调用函数：

```ocaml
let page = increment 8
```

不是：

```ocaml
(* 这不是推荐的 OCaml 调用写法 *)
(* increment(8) *)
```

括号用于控制组合顺序：

```ocaml
let page_after_two_steps = increment (increment 8)
```

**函数调用的结合优先级很高**。下面两者不同：

```ocaml
f x + y       (* 先计算 f x，再与 y 相加 *)
f (x + y)     (* 先计算 x + y，再交给 f *)
```

## 6. 多参数函数、柯里化和部分应用

```ocaml
let add_tax (rate : int) (price : int) : int =
  price + (price * rate / 100)
```

类型为：

```text
int -> int -> int
```

箭头向右结合，因此它等价于：

```text
int -> (int -> int)
```

可以理解为：先接收税率，再返回一个等待价格的函数。

```ocaml
let add_standard_tax : int -> int = add_tax 10
let total : int = add_standard_tax 200
```
```
let total : (int -> int) -> int = add_standard_tax 200 = (add_tax 10) 200
```
`add_tax 10` 只提供了第一个参数，这叫部分应用。它产生了一个新函数，而不是错误。

### 6.1 用类型追踪函数

面对高阶函数时，可以从左到右追踪类型：

```text
输入值 --f--> 中间值 --g--> 输出值
```

如果：

```text
f : 'a -> 'b
g : 'b -> 'c
```

那么先执行 `f` 再执行 `g`，整体类型就是：

```text
'a -> 'c
```

先把箭头画出来，再写代码，通常比盲目尝试更可靠。

## 7. 函数是一等值

函数可以作为参数传入：

```ocaml
let apply_twice (f : int -> int) (x : int) : int =
  f (f x)

let add_two (x : int) : int = x + 2
let result = apply_twice add_two 10
```

也可以直接传匿名函数：

```ocaml
let result = apply_twice (fun x -> x * 2) 3
```

这类接收函数或返回函数的函数叫高阶函数。

## 8. 条件表达式与比较

`if` 是表达式，会产生结果：

```ocaml
let access_level (score : int) : string =
  if score >= 90 then "advanced"
  else if score >= 60 then "standard"
  else "review"
```

所有分支必须返回相同类型。下面是错误的：

```ocaml
(* 一个分支是 int，另一个分支是 string *)
(* if ready then 1 else "waiting" *)
```

常用比较和逻辑运算：

```text
=     结构相等
<>    不相等
< <=  小于、小于等于
> >=  大于、大于等于
&&    逻辑与
||    逻辑或
not   逻辑非
```

普通内容比较一般使用 `=`，不要把其他语言中的习惯带过来使用 `==`。OCaml 的 `==` 检查的是物理身份，通常不是作业想要的含义。

## 9. 元组

元组用于组合固定数量、类型可以不同的值：

```ocaml
let record : string * int * bool =
  ("chapter-1", 24, true)
```

列表使用分号，元组使用逗号：

```ocaml
[1; 2; 3]   (* int list *)
(1, 2, 3)   (* int * int * int *)
```

元组也可以嵌套：

```ocaml
let range = ((1, 5), (10, 20))
```

## 10. 模式匹配

模式匹配是 OCaml 中最重要的工具之一。它既判断数据的形状，也从数据中取出组成部分。

### 10.1 拆解元组

```ocaml
let record_title (r : string * int * bool) : string =
  match r with
  | (title, _, _) -> title
```

`_` 是通配符，表示这个位置存在一个值，但我们不需要给它命名。

也可以在 `let` 中直接用模式：

```ocaml
let swap_pair (left, right) = (right, left)
```

编译器会推断：

```text
swap_pair : 'a * 'b -> 'b * 'a
```

### 10.2 分支顺序

`match` 从上到下寻找第一个匹配的分支：

```ocaml
let describe_number (n : int) : string =
  match n with
  | 0 -> "zero"
  | 1 -> "one"
  | _ -> "another number"
```

更具体的模式应放在通用模式之前，否则后面的分支永远不会到达。

### 10.3 穷尽性

模式应该覆盖输入类型的所有可能形状。OCaml 会对遗漏分支发出警告。不要随便忽略这种警告：编译器往往是在告诉你，某个输入会导致运行时的 `Match_failure`。

## 11. 多态类型

类型变量写成 `'a`、`'b`、`'c`，表示这里可以是任意类型。

```ocaml
let keep_left (left : 'a) (_right : 'b) : 'a = left
```

它可以处理不同类型：

```ocaml
keep_left 10 "unused"
keep_left true 3.14
```

类型变量之间是否相同很重要：

```text
'a * 'a       两个位置必须是同一种类型
'a * 'b       两个位置可以是不同类型
'a -> 'a      输出类型与输入类型相同
'a -> 'b      输入与输出类型不一定相同
```

多态不是“关闭类型检查”，而是让一个函数在保持一致类型关系的前提下服务于多种具体类型。

## 12. 列表

OCaml 列表具有相同元素类型：

```ocaml
let pages : int list = [3; 8; 13]
let titles : string list = ["intro"; "types"; "functions"]
```

空列表是：

```ocaml
[]
```

使用 `::` 在列表头部构造新元素：

```ocaml
let more_pages = 1 :: pages
```

列表 `[1; 3; 8; 13]` 本质上是：

```ocaml
1 :: (3 :: (8 :: (13 :: [])))
```

`::` 只创建一个新列表节点，不会修改原列表。

### 12.1 用模式匹配观察列表

列表只有两种基本形状：

```text
[]             空列表
head :: tail   非空列表
```

例如，判断列表是否至少有一个元素：

```ocaml
let has_item (xs : 'a list) : bool =
  match xs with
  | [] -> false
  | _ :: _ -> true
```

匹配固定长度：

```ocaml
let describe_size xs =
  match xs with
  | [] -> "empty"
  | [_] -> "one"
  | [_; _] -> "two"
  | _ -> "many"
```

## 13. 递归

递归函数必须使用 `rec`：

```ocaml
let rec count_items (xs : 'a list) : int =
  match xs with
  | [] -> 0
  | _ :: rest -> 1 + count_items rest
```

设计一个递归列表函数时，先回答四个问题：

1. 空列表的结果是什么？
2. 非空列表中，当前 `head` 应该如何处理？
3. 递归调用处理哪个更小的问题？
4. 如何把当前元素与递归结果组合起来？

递归调用必须朝终止条件前进。对列表来说，通常递归处理 `tail`，因为它严格短于原列表。

### 13.1 手工展开递归

理解递归最有效的方法是手工展开少量步骤。以上面的 `count_items` 为例：

```text
count_items ["a"; "b"]
= 1 + count_items ["b"]
= 1 + (1 + count_items [])
= 1 + (1 + 0)
= 2
```

在写作业函数前，用两个或三个元素的输入画出这种展开过程。

## 14. 尾递归与累加器

下面的调用不是尾递归：

```ocaml
let rec total xs =
  match xs with
  | [] -> 0
  | x :: rest -> x + total rest
```

原因是 `total rest` 返回以后，还需要执行加法。

使用累加器可以让递归调用成为当前分支的最后一步：

```ocaml
let total_tail (xs : int list) : int =
  let rec loop (acc : int) (remaining : int list) : int =
    match remaining with
    | [] -> acc
    | x :: rest -> loop (acc + x) rest
  in
  loop 0 xs
```

这里的不变量是：

```text
acc 保存已经处理的元素之和；
remaining 保存尚未处理的元素。
```

OCaml 可以把尾调用优化成类似循环的执行方式，因此它不会为每个列表元素一直保留新的调用栈帧。

设计带累加器的函数时，不要先想语法。先用一句准确的话定义累加器在任意时刻表示什么。

## 15. 高阶列表函数

`map` 把一个函数应用到每个元素，保持列表结构：

```ocaml
let rec map (f : 'a -> 'b) (xs : 'a list) : 'b list =
  match xs with
  | [] -> []
  | x :: rest -> f x :: map f rest
```

使用示例：

```ocaml
let lengths = map String.length ["OCaml"; "Dune"; "LLVM"]
```

输入是 `string list`，函数是 `string -> int`，所以输出是 `int list`。

可以用类型关系理解 `map`：

```text
f   : 'a -> 'b
xs  : 'a list
结果: 'b list
```

以后还会经常见到：

- `List.map`：逐项转换。
- `List.filter`：保留满足条件的元素。
- `List.fold_left`：从左到右维护累积状态。
- `List.fold_right`：从右侧结构化组合结果。

在题目明确要求自己实现某个列表函数时，不要用标准库中同名函数绕过练习。

## 16. 自定义代数数据类型

使用 `type` 定义一组可能的数据形状：

```ocaml
type status =
  | Waiting
  | Running of int
  | Finished of string
```

构造值：

```ocaml
let s1 = Waiting
let s2 = Running 35
let s3 = Finished "ok"
```

读取这种值要模式匹配所有构造器：

```ocaml
let status_text (s : status) : string =
  match s with
  | Waiting -> "not started"
  | Running percent -> "progress: " ^ string_of_int percent
  | Finished message -> "done: " ^ message
```

`Running` 和 `Finished` 不只是标签，它们还携带数据。

### 16.1 递归数据类型

数据类型也可以引用自己。下面表示由数字和加法组成的小型树：

```ocaml
type score_tree =
  | Leaf of int
  | Combine of score_tree * score_tree
```

对应的递归处理函数：

```ocaml
let rec evaluate_score (tree : score_tree) : int =
  match tree with
  | Leaf n -> n
  | Combine (left, right) ->
      evaluate_score left + evaluate_score right
```

这里有一个普遍规律：类型定义中的每个构造器，通常对应递归函数中的一个模式分支。

## 17. 模块

OCaml 使用模块组织名称。点号表示访问模块成员：

```ocaml
String.length "compiler"
Int64.add 20L 22L
List.map String.length ["a"; "abcd"]
```

本课程项目中，每个 `.ml` 文件通常会形成一个首字母大写的模块：

```text
hellocaml.ml  -> Hellocaml
studenttests.ml -> Studenttests
```

`open ModuleName` 会把模块中的名字带入当前作用域：

```ocaml
open Hellocaml
```

初学时，显式写 `List.map`、`Int64.add` 往往更清楚，也不容易发生同名冲突。

## 18. 异常

异常用于表示无法正常返回结果的情况：

```ocaml
let require_positive (n : int) : int =
  if n > 0 then n else raise Not_found
```

捕获异常：

```ocaml
let safe_check n =
  try
    string_of_int (require_positive n)
  with
  | Not_found -> "invalid"
```

`failwith "message"` 会抛出 `Failure "message"`。作业中的 `failwith "... unimplemented"` 是占位符，表示该函数尚未实现。

不要用异常代替正常的模式分支。例如，列表为空本来就是列表的一种合法形状，通常应该写 `[]` 分支，而不是让模式匹配意外失败。

## 19. 关联列表与查找思维

键值映射可以简单表示为二元组列表：

```ocaml
let settings : (string * string) list =
  [("theme", "dark"); ("font", "mono")]
```

查找这类结构时，要逐项观察：

```text
空列表：没有找到；
(key, value) :: rest：
  如果 key 是目标，返回当前 value；
  否则继续检查 rest。
```

顺序很重要。如果同一个键出现多次，从列表头开始查找意味着最前面的绑定优先。这种语义和许多语言中的局部作用域遮蔽很相似。

## 20. 对象语言与元语言

编译器会用一种语言实现另一种语言：

- 对象语言：被实现、被分析或被编译的语言。
- 元语言：用来编写编译器的语言。

本课程中，OCaml 是元语言。课程定义的小型表达式语言、LLVMlite 和 Oat 是对象语言。

例如，对象语言文本：

```text
budget + 10
```

在 OCaml 中不会直接保存为一段字符串，而通常表示成抽象语法树（AST）。AST 忽略括号、空格等具体书写细节，只保留程序结构。

## 21. 抽象语法树

用一个与作业不同的布尔查询语言举例：

```ocaml
type query =
  | Enabled
  | Tag of string
  | Both of query * query
  | Either of query * query
  | Invert of query
```

文本概念：

```text
enabled AND NOT tag("archived")
```

可以表示为：

```ocaml
Both (Enabled, Invert (Tag "archived"))
```

树的叶子是简单值或变量，内部节点是运算。遍历 AST 时，通常按构造器递归：

```text
叶子节点：直接处理；
一元节点：递归处理唯一子树；
二元节点：分别递归处理左右子树，再组合结果。
```

这种“结果由子树结果组合而来”的设计叫组合式设计，是解释器和编译器的核心思维。

## 22. 解释器

解释器把语法结构直接映射到含义：

```text
AST + 运行环境 -> 值
```

若表达式中包含变量，解释器就需要环境来回答“这个名字当前代表什么”。环境可以先用关联列表表示。

设计解释器时，先不要写代码。给每个 AST 构造器写一条语义规则：

```text
字面量节点：结果就是它携带的值；
变量节点：在环境中查找名字；
一元运算节点：解释子表达式，再执行一元操作；
二元运算节点：解释两个子表达式，再组合两个值。
```

然后检查：

1. 是否覆盖了所有构造器？
2. 每次递归是否处理更小的子树？
3. 找不到变量时，是否保留题目规定的错误行为？
4. 使用的是正确数值类型和模块函数吗？

## 23. 优化器与语义保持

优化器不是计算最终结果，而是输入一棵 AST，输出另一棵更简单的 AST：

```text
AST -> AST
```

最重要的性质是语义保持：对任何满足条件的运行环境，优化前后的程序应该产生相同结果。

```text
evaluate env tree = evaluate env (optimize tree)
```

典型设计顺序：

1. 先递归优化子树。
2. 查看优化后的子树是否满足某条简化规则。
3. 能简化就构造更小的节点，不能简化就重新构造原运算节点。

不要只测试优化器输出“长得像不像预期”，还应该测试优化前后的解释结果是否相同。后者直接检验语义保持。

优化规则必须对所有合法值成立。凭几个例子感觉正确并不足够；应先用代数或语义解释为什么规则总是正确。

## 24. 栈式机器

栈式语言把嵌套表达式变成线性指令序列。栈可以用列表表示，列表头是栈顶：

```text
[]          空栈
[7]         栈顶是 7
[3; 7]      栈顶是 3，下面是 7
```

以一套独立的文本处理指令为例：

```ocaml
type text_insn =
  | PushText of string
  | Join
  | Uppercase
```

程序：

```ocaml
[PushText "oc"; PushText "aml"; Join; Uppercase]
```

可以手工模拟：

```text
[]
["oc"]
["aml"; "oc"]
["ocaml"]
["OCAML"]
```

手工模拟栈时，每执行一条指令都写出完整栈。尤其要确认二元操作弹出值的顺序，以及约定中哪一端是栈顶。

## 25. 从 AST 编译到栈指令

编译器在这里是一种结构转换：

```text
源 AST -> 目标指令列表
```

组合式编译的一般思路是：

- 叶子节点生成一条“压栈”指令。
- 一元节点先生成子树代码，再生成一元操作指令。
- 二元节点生成左右子树代码，再生成二元操作指令。

但具体的左右顺序必须根据目标栈机的 `step` 语义推导，不能凭感觉决定。

验证编译器时，不应只比较某个例子的指令列表。更重要的正确性关系是：

```text
直接解释源程序得到的值
=
运行编译后目标程序得到的值
```

这种跨两种执行方式比较行为的测试，是编译器课程中反复出现的核心方法。

## 26. 测试

课程测试框架中常见形式：

```ocaml
assert_eq actual expected
```

以及延迟计算的形式：

```ocaml
assert_eqf (fun () -> computation) expected
```

`fun () -> computation` 的类型是：

```text
unit -> 'a
```

测试框架决定何时调用它。这样可以统一捕获计算产生的错误和异常。

### 26.1 每个函数至少考虑哪些测试

- 最小输入，例如空结构。
- 单元素输入。
- 普通的多元素输入。
- 输入开头、中间、结尾发生关键情况。
- 重复值或重复绑定。
- 不同具体类型，以检查多态性。
- 题目规定的异常情况。
- 深层嵌套结构。

测试的价值不是证明代码一定正确，而是帮助你明确规格，并快速找到反例。

## 27. 常见错误与阅读方法

### 27.1 `Unbound value x`

名字不在当前作用域，常见原因：

- 拼写错误。
- 局部 `let` 的作用域已经结束。
- 忘记模块名前缀。
- 前面的代码没有成功编译，因此定义没有生成。

### 27.2 `This expression has type ... but ... was expected`

先不要盯着整段错误。找到两个类型：

```text
实际类型
期望类型
```

再沿数据流检查哪一步改变了类型。对高阶函数，可以写出每个函数的输入和输出箭头。

### 27.3 模式匹配不完整

检查该类型定义的所有构造器，或列表的 `[]` 与 `head :: tail` 两种形状。不要用最后一个 `_` 分支仓促吞掉本来应该认真处理的情况。

### 27.4 忘记 `rec`

函数体中需要调用函数自身时，定义必须使用：

```ocaml
let rec function_name ... = ...
```

### 27.5 `int` 与 `int64` 混淆

```text
5       int
5L      int64
+       int 加法
Int64.add  int64 加法
```

看到类型错误时，先检查字面量是否带 `L`，以及是否调用了正确模块。

### 27.6 `;` 与 `,` 混淆

```ocaml
[1; 2; 3]   (* 列表 *)
(1, 2, 3)   (* 元组 *)
```

分号在 OCaml 中还可表示顺序执行两个具有副作用的表达式，因此不要随意把它当逗号使用。

### 27.7 把函数调用写成其他语言的样子

```ocaml
f x y       (* 两个柯里化参数 *)
f (x, y)    (* 一个二元组参数 *)
```

这两者类型和含义不同。

## 28. 一个推荐的解题流程

面对每道作业题，按以下顺序工作：

1. 用中文写出输入、输出和特殊情况。
2. 从类型签名判断函数接收什么、必须返回什么。
3. 找出输入数据的所有结构情况。
4. 为每个情况写出自然语言规则。
5. 若需要递归，说明递归调用处理的更小输入是什么。
6. 手工计算两个很小的例子。
7. 再把自然语言翻译成 OCaml。
8. 保存并查看 `make dev` 的第一个错误。
9. 编译成功后运行 `make test`。
10. 为公开测试没有覆盖的边界增加学生测试。

一次只处理第一个编译错误，因为后面的错误常常是第一个语法或类型错误连带造成的。

## 29. 分阶段自学路线

### 阶段一：值、类型和函数

掌握：

- `let` 与 `let ... in`
- 类型标注
- 匿名函数和普通函数定义
- 函数调用、柯里化、部分应用
- `if ... then ... else ...`

自练题：

1. 写一个函数，把分钟数转换成秒数。
2. 写一个接收固定前缀并返回字符串处理函数的函数。
3. 用部分应用得到一个已经固定前缀的新函数。

### 阶段二：元组、模式和多态

掌握：

- 元组的构造与拆解
- `_` 通配符
- `'a` 类型变量
- 函数作为参数和返回值

自练题：

1. 从四元组中取出第二项。
2. 交换二元组两项，并观察推断出的多态类型。
3. 写一个函数，将同一个转换函数分别应用到二元组两边。

### 阶段三：列表与递归

掌握：

- `[]` 与 `::`
- 结构递归
- 局部递归辅助函数
- 累加器和尾递归
- `map` 的类型关系

自练题：

1. 计算字符串列表中所有字符串的总长度。
2. 判断列表中是否存在空字符串。
3. 用尾递归计算整数列表中正数的数量。

### 阶段四：自定义类型与树

掌握：

- variant 构造器
- 递归数据类型
- 每个构造器对应一个处理分支
- 从子树结果组合父节点结果

自练题：

1. 定义表示文档标题、段落和组合节点的树。
2. 计算文档树中的段落数量。
3. 收集文档树中的所有标题。

### 阶段五：解释、优化与编译

掌握：

- AST 与具体语法的区别
- 环境和变量查找
- 组合式解释
- 语义保持
- 栈状态的逐步执行
- 从树到线性指令的结构化翻译

自练题：

1. 为布尔查询 AST 写自然语言语义，不急着写代码。
2. 提出两条总是保持语义的布尔简化规则并说明理由。
3. 手工模拟一段文本栈指令的每一步栈状态。

## 30. 语法速查表

```ocaml
(* 注释，可以嵌套 *)

let value : int = 10

let local_example =
  let x = 3 in
  x + 1

let function_name (x : int) : int =
  x + 1

let anonymous = fun x -> x + 1

let conditional x =
  if x > 0 then "positive" else "not positive"

let tuple_value = ("page", 3)

let tuple_match pair =
  match pair with
  | (name, number) -> name ^ string_of_int number

let list_value = [1; 2; 3]

let rec list_match xs =
  match xs with
  | [] -> 0
  | _ :: rest -> 1 + list_match rest

type result_state =
  | Pending
  | Complete of string

let state_match state =
  match state with
  | Pending -> "pending"
  | Complete message -> message

let throw_example () = raise Not_found

let catch_example () =
  try throw_example () with
  | Not_found -> ()
```

## 31. 学完后的自检问题

如果能不看答案解释下面的问题，就可以开始独立推进作业：

1. `let x = ... in ...` 中，`x` 的作用域在哪里？
2. 为什么 `int -> int -> int` 可以部分应用？
3. `f x y` 与 `f (x, y)` 有什么区别？
4. `'a list` 中的 `'a` 表示什么？
5. 为什么列表递归一般需要 `[]` 和 `head :: tail` 两个分支？
6. 如何判断一个递归调用是不是尾调用？
7. 自定义 variant 的构造器如何指导模式匹配？
8. AST 为什么比直接保存源代码字符串更适合解释和编译？
9. 优化器最重要的正确性条件是什么？
10. 如何用“直接解释结果等于编译后执行结果”测试一个小编译器？

遇到不会的题时，先回到对应章节，用不同于作业输入的两三个小例子手算。能清楚说出每一步为什么成立，再把思路翻译成 OCaml。
