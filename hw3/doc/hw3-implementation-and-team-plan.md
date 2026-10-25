# HW3：LLVMlite 后端实现说明与双人分工

## 作业目标

HW3 要实现一个**不进行优化的编译器后端**：将 64 位 LLVMlite 程序编译为 x86lite 汇编。最终生成的汇编会由 `clang` 汇编和链接，得到可执行程序。

整体流程如下：

```text
.ll LLVMlite 源程序
  → parser 解析为 Ll.prog AST
  → bin/backend.ml 编译为 X86.prog
  → 输出 .s 汇编文件
  → clang 汇编、链接
  → 可执行文件
```

主要实现文件是 `stub(4)/stub/bin/backend.ml`；自己的测试应写在 `stub(4)/stub/test/studenttests.ml`。提交时应包含这两个文件。

## 核心实现思路

本作业不需要寄存器分配。每个 LLVMlite 局部变量（`%uid`）都映射到当前函数栈帧中的一个 8 字节栈槽。`ctxt.layout` 保存 `uid → 栈位置` 的映射。编译单条指令时可以临时使用寄存器（如 `rax`、`r10`、`r11`），但结果必须存回该指令对应的栈槽。

所有 LLVMlite 值，包括 `i1` 布尔值，都按 8 字节保存。

函数调用需遵守 x86-64 System V AMD64 ABI：

| 参数/结果 | 位置 |
| --- | --- |
| 第 0 至 5 个参数 | `rdi`、`rsi`、`rdx`、`rcx`、`r8`、`r9` |
| 第 6 个及之后的参数 | 调用者栈上传递 |
| 返回值 | `rax` |
| 调用 `callq` 时 | `rsp` 必须 16 字节对齐 |

## 待实现函数

| 函数 | 作用 |
| --- | --- |
| `compile_operand` | 将 LLVMlite 操作数移动到指定 x86 操作数位置。处理局部变量 `Id`、全局变量 `Gid`、常量 `Const` 和空指针 `Null`。全局变量地址需使用 RIP-relative `leaq`。 |
| `size_ty` | 计算 LLVMlite 类型的字节大小，供 GEP 使用。`I1`、`I64`、指针均为 8 字节；数组为长度乘元素大小；结构体为成员大小之和；具名类型需查找 `tdecls`；`Void`、`I8`、函数类型返回 0。 |
| `compile_gep` | 编译 `getelementptr`，沿类型和索引路径计算目标元素地址。第一个索引按基础类型数组处理；之后按数组索引或 struct 字段偏移计算。 |
| `compile_insn` | 编译普通 LLVM 指令，并将结果写到该指令 `uid` 对应的栈槽。 |
| `compile_terminator` | 编译 block 末尾控制流：`Ret`、`Br`、`Cbr`。返回时恢复栈帧，返回值放入 `rax`。 |
| `compile_block` | 顺序编译一个 basic block 的所有普通指令，最后编译 terminator。 |
| `arg_loc` | 返回第 `n` 个传入参数的位置：前六个为参数寄存器，其余为相对 `rbp` 的调用者栈位置。 |
| `stack_layout` | 为参数和每条有结果的 LLVM 指令分配 8 字节栈槽，生成 `uid → rbp` 负偏移的映射。 |
| `compile_fdecl` | 编译一个函数：构造函数序言、分配局部栈空间、将参数复制到栈槽，并编译入口 block 和有标签 block。 |

`compile_ginit`、`compile_gdecl`、`compile_prog` 已提供实现，通常不需要修改。

## `compile_insn` 必须支持的指令

| LLVMlite 指令 | 编译要求 |
| --- | --- |
| `Binop` | 实现 `add`、`sub`、`mul`、`shl`、`lshr`、`ashr`、`and`、`or`、`xor`。动态移位量需要放在 `rcx`，由 `cl` 使用。 |
| `Icmp` | 比较两个值并生成严格的 `0` 或 `1`。通常使用 `cmpq`、`set<cond>`，并清零结果高位。 |
| `Alloca` | 在当前运行时栈上分配空间，结果为指向该空间的指针。 |
| `Load` | 读取指针指向的 8 字节值。 |
| `Store` | 将操作数写到目标指针指向的位置。 |
| `Call` | 按 ABI 设置参数、处理第七个及以后的栈参数、调用函数并清理调用者参数区；还要保证调用点 16 字节对齐。 |
| `Bitcast` | x86lite 中不需要真实转换，只需复制同一位模式的值。 |
| `Gep` | 调用 `compile_gep` 计算地址，并保存结果。 |

## 推荐开发与测试顺序

1. 先实现 `arg_loc`、`stack_layout` 和最小版 `compile_fdecl`。
2. 实现空 block 与 `ret void`，先确保空函数可以正常退出。
3. 实现 `compile_operand` 与算术 `Binop`。
4. 完成 block、`Ret`、`Br`、`Cbr`，支持多 block 控制流。
5. 实现 `Icmp`、`Alloca`、`Load`、`Store`。
6. 实现 `Call` 及栈对齐。
7. 实现 `Bitcast`、`size_ty` 与 `Gep`。
8. 增加综合测试并执行完整测试。

在 `stub(4)/stub` 下使用：

```bash
make test
```

也可使用下列命令将后端结果与 LLVMlite 参考解释器和 clang 结果交叉验证：

```bash
./oatc --interpret-ll llprograms/factorial.ll
./oatc --clang --execute-x86 llprograms/factorial.ll
./oatc --execute-x86 llprograms/factorial.ll
```

## 双人分工

下面以“我”和“队友”为代号。两人的代码量和调试难度接近：我负责局部值、控制流和栈帧；队友负责内存、类型地址计算和调用约定。两部分通过 `compile_insn`、`ctxt`、`layout` 和统一的临时寄存器约定集成。

| 负责人 | 主要任务 | 具体交付 |
| --- | --- | --- |
| 我 | 栈布局、函数/控制流、基础运算 | 实现 `arg_loc`、`stack_layout`、`compile_fdecl`、`compile_block`、`compile_terminator`、`compile_operand`；在 `compile_insn` 中实现 `Binop`、`Icmp`、`Bitcast`。补充算术、返回、跳转和条件分支测试。 |
| 队友 | 内存、类型尺寸、地址计算、函数调用 | 实现 `size_ty`、`compile_gep`；在 `compile_insn` 中实现 `Alloca`、`Load`、`Store`、`Call`、`Gep`。补充内存、全局变量、递归/多参数调用、GEP、字符串和对齐测试。 |

### 建议的协作边界

- 共同先确定 `stack_layout` 的偏移格式、`arg_loc` 对第 7 个及以后参数的偏移，以及临时寄存器用途。例如可统一采用 `rax` 存主计算值，`r10`/`r11` 存辅助操作数，动态 shift 使用 `rcx`。
- 为避免同时修改同一段代码，前期由我完成 `compile_fdecl`、`compile_block`、`compile_terminator` 和 `compile_operand`；队友先完成独立的 `size_ty`、`compile_gep`，并在本地准备 `compile_insn` 的内存与调用分支设计。随后合并到同一个 `compile_insn` 中。
- `compile_insn` 是唯一明显的重叠点：建议先由我提交 `Binop`、`Icmp`、`Bitcast` 分支，队友在这些分支之后加入其余构造器分支；或者由一人统一合并另一人的经测试代码。
- `studenttests.ml` 可按测试类别分开添加；合并前运行一次 `make test`，避免二人同时改同一文件。

### 里程碑

| 阶段 | 我 | 队友 | 共同验收 |
| --- | --- | --- | --- |
| 阶段 1：基础骨架 | 栈布局、函数序言/结语、返回与跳转 | `size_ty`、GEP 偏移算法设计和单元测试 | `return*.ll`、`br*.ll`、`cbr*.ll` 可运行。 |
| 阶段 2：指令与内存 | 操作数、算术、比较、bitcast | alloca/load/store/GEP | 算术、memory、GEP 测试通过。 |
| 阶段 3：调用与集成 | 协助检查参数接收和栈帧恢复 | call 参数传递、清理与对齐 | `call*.ll`、`factorial.ll`、`printf*.ll` 可运行。 |
| 阶段 4：提交准备 | 控制流和综合测试 | 结构化数据、循环、辅助函数测试 | `make test` 通过；完成自定义 `.ll` 测试。 |

## 自定义测试要求

除自动测试外，需要提交一个自己的有意义测试。该测试必须同时具备：

1. 数组或结构体，因此会使用 `getelementptr`；
2. 单一 CFG 内的非平凡控制流，即循环和条件分支；
3. 至少一个辅助函数，因此会使用 `call`。

建议由队友主写结构化数据和辅助函数主体，我补充循环、条件分支及预期结果检查，最后共同运行 `make test` 和手动端到端验证。
