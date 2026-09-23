# 独立核查 V2 第二轮：tie 对照实验（**结论：不成立，工具与激励都有问题**）

**跑于** 2026-09-19　**产物** `/tmp/v2b/`（`tb_tie.sv`、`build_0/1.log`、`run_0/1.log`）

---

## 1. 做了什么

同一个自检测试台，编译两次（`+define+TIEVAL=0` / `=1`），并对 8 个无驱动 tie 端口
加 `force … = TIEVAL` ——**把常量值变成受控变量**，而不是听凭单元模型解析 `z`。
激励：复位 → `srm_start` 脉冲 → 逐个送 22 个 decision（`bit = (i mod 3 == 0)`）→ 等 `srm_done`。

## 2. 结果

```
TIEVAL=0  done=0 total=0 ones=0 residue=0 busy=0 shortfall=0 stalled=0
TIEVAL=1  done=0 total=0 ones=0 residue=0 busy=0 shortfall=0 stalled=0
```

| 项 | 结论 |
|---|---|
| 两个 tie 值的行为差异 | **无可观测差异** |
| 这个"无差异"能不能当结论？ | **不能** —— 见 §3 |
| 独立期望 `ones = 8 of 22` | **未能核对**（计数器始终为 0） |

## 3. 为什么这次对照**不成立**（三条，全部是我这边的问题）

### 3.1 被核查的块**根本没有被激活**

`total=0 / ones=0 / busy=0` —— `srm_start` 之后 `busy` 都没起来。
原因在网表里一眼可见：

```verilog
srm_residue_estimator_… u_srm_residue (
    .dec_clk ( dec_clk ) , .decision_valid ( srm_decision_valid ) ,
    .decision_bit ( srm_decision_bit ) , .clk ( ctosc_gls_0 ) , …
```

**`u_srm_residue` 的功能时钟是 `ctosc_gls_0`，一个片上生成的内部时钟**（不是端口）。
我的测试台只驱动了 `clk` 与 `dec_clk`，**内部振荡器没跑，所以这个块一次都没被时钟沿打到。**
⇒ **沿一条从未被走通的路径做对照，等于没做。**

### 3.2 我的"差异检测器"是坏的

脚本用 `diff` 比较两行 `TIE_RESULT`，但这两行**本身包含 `TIEVAL=` 的取值**，
于是它必然报 `DIFFERENT`——**这是假阳性**，实际数值部分完全相同。

### 3.3 结论：本轮**没有**证明 tie 值无关

只能说：**在一条未被激活的路径上，tie 值不影响可观测行为。** 这没有信息量。

## 4. 本轮真正的收获：一个独立核查才会撞到的仿真前提

**顶层端口不足以驱动这个设计。** `srm_residue_estimator` 由片上生成的 `ctosc_gls_0` 驱动，
要做门级功能核查，必须先让内部振荡器工作——**而怎么让它工作，是一个设计细节，不是端口契约。**
这与被核查方那次 GLS"只产 SAIF、不做功能判定"是相容的：那种用法本来就不需要块真的跑起来。

## 5. 下一轮（明确动作）

1. 从网表/RTL 找出 `ctosc_gls_0` 的**来源与使能条件**（谁驱动它、由哪个信号开启）。
2. 让它在测试台里跑起来，再重做 §1 的激励；**只有当 `busy`/`done` 真的动了，那次的
   tie 对照才算数。**
3. 修掉 §3.2 的差异检测器（比较时剔除参数本身）。
4. 之后再谈 `ones=8 of 22` 这个独立期望的核对。
