# HW3: LLVMlite

课程：CS131 2026  
原始页面：<https://faculty.sist.shanghaitech.edu.cn/cs131/hw3/doc/hw3-llvmlite.html>

## Overview

本项目要求实现一个不进行优化的编译器，将 LLVM IR 的一个简化子集（LLVMlite，源语言为 64 位 LLVMlite）编译为 x86lite。

## Getting Started

作业文件从 Blackboard 下载。主要文件如下；带 `*` 的文件是完成作业时通常需要修改的文件：

| 文件 | 说明 |
| --- | --- |
| `README` | 主测试框架说明 |
| `Makefile` | 构建 `oatc`，支持 `dev`、`test`、`zip` 目标 |
| `lib/util/assert.ml(i)` | 断言框架 |
| `lib/util/platform.ml` | 平台相关编译支持 |
| `lib/x86/x86.ml` | X86lite 指令表示 |
| `lib/ll/ll.ml` | LLVMlite 抽象语法 |
| `lib/ll/lllexer.mll` | LLVMlite 词法分析器 |
| `lib/ll/llparser.mly` | LLVMlite 语法分析器生成文件 |
| `lib/ll/llinterp.ml` | LLVMlite 语义参考解释器 |
| `llprograms/*.ll` | 测试用 LLVMlite 示例 |
| `test/gradedtests.ml` | 提供的评分测试 |
| `bin/main.ml` | 命令行接口 |
| `bin/driver.ml` | 编译器流水线调用 |
| `bin/cinterop.c` | 互操作测试用 C 代码 |
| `bin/backend.ml` | `*`：实现 LLVMlite 到 X86 的编译器 |
| `test/studenttests.ml` | `*`：添加自己的测试 |

需要安装 `menhir` 和 `clang`。提供的开发环境应已配置好这些工具。

## Preliminary Steps

1. 通读本页面，了解项目整体内容。
2. 阅读 `README`，熟悉编译器测试方式。
3. 阅读 `driver.ml`，尤其是 `process_ll_file`，理解 backend 在整个编译流水线中的位置。
4. 按后文说明开始实现 `backend.ml`。

该项目调试难度较高，应尽早开始。

## LLVMlite Specification

LLVMlite 是 LLVM IR 的一个子集。LLVM Language Reference 可作为参考；项目只涉及完整 LLVM 功能的一小部分。LLVMlite Documentation 以与目标平台无关的抽象语义描述 LLVM 程序行为，并以 LLVM Language Reference 为准。

## Implementing the Compiler

`backend.ml` 提供了基本编译器结构。抽象语法的各个部分（例如 `prog`、`fdecl`）通常对应一个编译函数（例如 `compile_prog`、`compile_fdecl`）。大多数函数尚未实现，需要完成翻译。参考实现少于 350 行带文档代码。

建议按以下顺序开发：

1. 先完成最小的 `compile_fdecl`，支持空函数体和不同数量的输入参数。理解 System V AMD64 ABI 调用约定、`layout`，并完成 `arg_loc`。此时生成的 X86 代码还不能正常运行，因为函数没有正确退出，但可以检查生成的汇编。
2. 实现 `compile_terminator` 中处理无返回值函数的部分，并让 `compile_block` 支持无指令的 block。此时应能生成类似下面函数的可运行代码：

   ```llvm
   define void @main(i64 %argc, i8** %argv) {
     ret void
   }
   ```

3. 理解 `ctxt` 类型，确定保存 `uid` 局部变量的策略，实现 `compile_operand`。
4. 实现 `compile_insn` 的 `Binop` 分支。
5. 回头调整 `compile_fdecl` 和 `compile_block`，正确处理上下文和非空控制流图/block。
6. 完成 `compile_terminator` 的其余分支，使编译器支持返回 `i64`、简单算术和直接跳转。
7. 实现 `compile_insn` 的 `Icmp`，然后实现 `Alloca`、`Load`、`Store`。
8. 实现 `Call`，正确处理 System V AMD64 ABI（只需关注 64 位值）。完成后应能处理递归阶乘函数。
9. 实现 `Bitcast`；由于目标语言无类型，实现应很简单。
10. 最后实现 `Gep`（`getelementptr`）指令。

## Testing and Debugging Strategies

`main.ml` 提供的测试框架有多种检查方式，完整参数说明见 `README`。LLVMlite 解析器足以解析 `llprograms` 中的示例，应自行添加测试。

- 使用 `--interpret-ll` 通过 LLVMlite 参考解释器运行程序。
- 使用 `--clang` 通过 clang 编译 LLVMlite 程序。
- 不要直接比较自己生成的 `.s` 文件和 clang 生成的文件；应比较相同输入下两个版本的行为。

## Graded Test Cases

需要提交一个有趣且与已有测试明显不同的编译器测试用例，可以是带预期输出的 `.ll` 文件，也可以从手写的 LLVMlite 抽象语法开始。特别鼓励覆盖现有测试较少涉及的语言部分。

测试用例必须：

- 使用结构化数据类型（数组或 struct），因此也使用 `getelementptr`；
- 在单个控制流图中包含非平凡控制流（循环和条件分支）；
- 至少包含一个辅助函数，因此使用 `call` 指令。

其他 LLVMlite 算术或位操作可自由选择。可先用 clang 检查 `.ll` 文件是否合法，因为 backend 假定输入代码合法。测试用例随作业提交到 Blackboard，并计入最终成绩。

## Grading

无法编译的项目不计分。评分构成：

- 90 分：提供的自动化测试；
- 5 分：提交一个有趣的测试用例（人工评分）；
- 5 分：其他小组创建的测试用例（人工评分）。

