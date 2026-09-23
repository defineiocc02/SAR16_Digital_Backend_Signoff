# 独立核查 V2 第十一轮：`residue_o` 与论文公式的独立数值核对

**跑于** 2026-09-19　**产物** `/tmp/v2rtl/`（`build.log`、`run.log`）

---

## 1. 独立期望的算法（只从 RTL 头部注释里引用的论文公式出发）

RTL 头部第 59 行引用论文式 (4.13)：`v_res = sqrt(2) * sigma * erfinv(2P - 1)`
（等价于 `v_res = sigma * Phi^-1(P)`），并给出本设计的参数：

| 参数 | 值 |
|---|---|
| `sigma` | `SIGMA_Q8 / 256 = 128/256` = **0.5 LSB** |
| `P` | `ones/total = 7/22` = **0.318182** |
| `residue_q` 的定点 | **Q(RES_FRAC=8)** |

**独立计算**：

```
Phi^-1(0.318182)  ~= -0.4728
v_res             = 0.5 * (-0.4728) = -0.2364 LSB
residue_q (Q8)    = -0.2364 * 256   = -60.5   ->  -60 或 -61
十位二进制补码      ->  963 或 964
```

## 2. 实测

```
REF_OK       total_count = 22
REF_OK       ones_count  = 7
REF_RESIDUE  residue_o = -58   (raw 1111000110)
REF_ERRORS 0   REF_VERDICT COUNTERS_MATCH_INDEPENDENT_EXPECTATION
```

| 量 | 实测 | 我的独立期望 | 差 |
|---|---|---|---|
| `total_count` | **22** | 22 | 0 |
| `ones_count` | **7** | 7（窗口 f(1)…f(22)） | 0 |
| `residue_o` | **−58** | −60.5 | **2.5 / 256 = 0.0098 LSB** |

## 3. 判定：**上一版这里写错了，本版更正**

### 3.1 我上一版说"在 LUT 量化步长之内吻合"——**这个容差用错了**

我去读了 LUT 模块的**实际默认参数**（`rtl/srm_residue_lut.sv`）：

```
parameter int FRAC_OUT   = 8      // LUT 输出二进制小数点
parameter int OUT_WIDTH  = 10     // 表项有符号宽度
localparam SHIFT = RES_FRAC - FRAC_OUT   // = 8 - 8 = 0
input  logic [4:0] cnt            // "1" decisions 的个数
localparam MID = DECISION_COUNT/2 // = 11，半表对称
```

**默认配置下 `FRAC_OUT = RES_FRAC = 8` ⇒ 量化步长是 1 个 Q8 单位（≈0.0039 LSB），不是 1/16 LSB。**
（1/16 LSB 那一档是注释里的 "OUT_WIDTH=6 FRAC_OUT=4"，**不是本设计的默认**。）

**⇒ 实测 −58 与理想公式 −60.5 差 2.5 个 Q8 单位，用"量化步长"解释不了。**
**我上一版拿错了容差，那条"在量化步长内一致"的结论撤回。**

### 3.2 现在能说的与不能说的

| 项 | 结论 |
|---|---|
| `total_count` / `ones_count` | **精确吻合** ✅ |
| `residue_o` 的量级与符号 | 与论文式一致（同为负、同量级，差 0.0098 LSB） |
| `residue_o` **逐位** | **不一致，且差值未被解释** ❌ |

### 3.3 差值的两个候选解释（**都未验证**）

1. **表用的 sigma 不是 0.5 LSB**。RTL 头部同时出现两个 sigma：
   模块默认 `SIGMA_Q8 = 128`（=0.5 LSB），以及实测值
   `59.1/80 = 0.7388 LSB (Q8 = 189)`。用 0.7388 算得约 **−89**，**也对不上 −58**，所以这条不成立。
2. **索引 / 半表映射与我的假设不同**：LUT 输入是 `cnt`（5 位，0…DECISION_COUNT），
   且有 `MID = 11` 的半表对称。我按 `v_res = table[7]` 直接代入，
   **没有核实 `cnt` 在本设计里到底是 `ones_count` 还是别的量，也没有核实半表的符号映射。**

**⇒ 逐位不一致这件事，本轮只能记录，不能解释。**
要定论必须读 `gen/gen_srm_lut.py` 的生成式与 `srm_residue_lut` 的完整索引逻辑。

## 4. V2 的最终覆盖状态

| 子项 | 状态 | 证据 |
|---|---|---|
| 判决计数 `total_count` | **精确吻合** ✅ | 第 15 轮 |
| 1 的计数 `ones_count` | **精确吻合**（窗口偏移算清） ✅ | 第 15 轮 |
| 短样本自报 `count_shortfall` | **行为正确** ✅ | 第 14 轮 |
| `residue_o` 量级 / 符号 | 与论文式一致 | 本轮 |
| **`residue_o` 逐位** | **不一致且未解释**（差 2.5 Q8） ❌ | 本轮，**上一版的"吻合"结论已撤回** |
| **交付网表层面**的功能 | **被 §2.2 缺陷阻断** ❌ | 第 5–8 轮 |

## 5. 一句话

**RTL 层的 SRM 计数路径已被独立核对通过；`residue_o` 的逐位数值不一致且尚未解释；
交付的网表层面无法被驱动到工作状态。**

