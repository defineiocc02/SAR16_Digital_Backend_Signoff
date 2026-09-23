# SAR16 后端 · 接手第 8 轮：hold 从「未闭合」变成「可交付的边界要求」

**时间**：2026-09-18 21:05–21:15　**性质**：诊断 + **用工具自带的 overlay 机制**做受控实验（base SDC 一字未改）

---

## 1. 先说结论

**这个块内部没有 hold 问题。** 三个角的 **flop→flop hold 违例数都是 0**；
全部 39 条违例（slow 16 / fast 12 / typical 1）都发生在**边界路径**上。

它们**完全由签核 SDC 里三个自述为「假定值」的边界约束决定**。把这三个假想值表述到位之后：

| 角 | 基线违例 / WNS | **overlay 到位后** |
|---|---|---|
| typical | 1 / −0.0320 ns | **0 / 最差 +0.0080 ns** |
| slow | **16 / −0.2020 ns** | **0 / 最差 +0.0180 ns** |
| fast | 12 / −0.0538 ns | **0 / 最差 +0.0062 ns** |
| setup | 三角全 0 | **三角仍全 0（未被影响）** |

**⇒ 该块对外的 hold 接口要求（可直接写进集成文档）：**

| 项 | 要求 | 占 10 ns 周期的比例 |
|---|---|---|
| 同步输入口（`raw_bits_i[*]`、`data_valid_i`、`start_calib`、`srm_start`、`residue_consume_i`） | 外部 **hold ≥ 0.72 ns** | 7.2 % |
| `calib_comp_out`（异步比较器输入） | 外部 **hold ≥ 0.04 ns** | 0.4 % |
| 输出口（`calib_done*`、`raw_code_o[*]`、`w_wr_*`、`srm_*`） | 外部接收端 **hold 要求 ≤ 0.44 ns** | 4.4 % |

---

## 2. 违例的构成（逐条分类，不是抽样）

用 `tools/hold_classify.py` 解析 PT 的 hold 报告，把每条违例按起止点分类：

| 角 | 违例数 | 分类 |
|---|---|---|
| typical | 1 | `calib_comp_out`(输入口) → `u_calib_ctrl/comp_out_r_reg/D` |
| **slow** | **16** | **100 % 输入端口 → 首级 flop**（`raw_bits_i[*]` → `raw_code_o_reg[*]`） |
| fast | 12 | flop → 输出端口 / 端口 → 端口 |

**最差路径的算术（slow，直接取自 PT 报告）：**

```
input external delay      0.50     ← SDC 的 set_input_delay -min（IO_MIN_FRAC 0.05）
U18/Y (INVXL)             0.05
data arrival              0.55
clock network (propagated) 0.75    ← CLKBUFX4 0.34 + BUFX2 0.41
clock uncertainty         0.05 ; library hold −0.05
data required             0.75
slack                    −0.20  VIOLATED
```

**机制**：数据路径（0.55）**短于**时钟树插入延迟（0.75）——边界 hold 的典型形态。
输入口几乎直接进触发器（中间只有一个反相器），而时钟要穿过 0.75 ns 的树。

**这不是实现缺陷**：`clock_opt` / `route_opt` 都跑过；块内没有任何 flop→flop 违例；
端口路径上没有可优化对象（数据路径是外部延迟 + 一个缓冲器）。

---

## 3. 实验怎么做的（**关键：base SDC 一字未改**）

`sta_pt_paper_core.tcl` 第 41 / 111–113 行本来就有 **`SDC_EXTRA` overlay 钩子**
（"base 签核 SDC 逐字节不变，delta 单独写后 `source`" —— 正是这个项目自己的纪律）。
包装器 `run_sta_paper_core.sh` 用 `pt_shell -f … -x "set …"` 传变量，所以：

```bash
pt_shell -f scripts/sta_pt_paper_core.tcl \
  -x "set CORNER $C ; set TAG hf2 ; set PNR_TAG {} ; set DER_LATE 1.0 ; set DER_EARLY 1.0 ; \
      set SDC_EXTRA /tmp/holdexp/ovl2.sdc" ...
```

`ovl2.sdc` 只重述三个边界值（0.72 / 0.04 / −0.44），**不碰 base SDC**。
报告按 `TAG` 命名（`*_hf2_hold.rpt`），**不覆盖基线报告** —— 已用 md5 前后比对证明（3/3 未变）。

**验证矩阵**

| 检查 | 结果 |
|---|---|
| 三个角 PT_RC | 0 / 0 / 0 |
| 三档 overlay（0.70/0.03/−0.45 → 0.72/0.04/−0.44 → 0.80/0.10/−0.40） | 单调收敛，末两档全 0 |
| setup 是否被连带影响 | **三角仍全 0**（hold-only 变更不影响 setup） |
| 基线 hold 报告 md5 | **3/3 未变** |
| 基线 SDC md5 | 未改（走 overlay） |
| 实验产物 | **全部移出项目树**（202 → 112 文件，残留 0） |

---

## 4. 这对交付意味着什么（措辞边界）

- **可以说**：本块内部时序（含 hold）无违例；hold 的全部要求是**边界接口要求**，已量化。
- **不能说**："hold 已签核通过"。签核通过需要集成方确认它确实提供上述边界条件。
- **不推荐**：在输入口加 hold 缓冲器来"消掉违例" —— 那是在块的内部消化集成侧的
  不确定性，会白加面积/功耗，且换一个外部环境又要重来。
- 原 SDC 注释只把这件事写成"**output ports 的唯一违例来源**"，**漏了输入侧**；
  本轮实测 **16/39（41 %）的违例在输入侧**，而且幅度更大（−0.202 vs −0.054）。

---

## 5. 顺带纠正一处口径

`sta_pc_*_pc_hold.rpt` 里的 **path 块数 ≠ 违例数**：
报告用 `-max_paths 25 -nworst 2`，同一端点会列 2 条，所以 slow 报告里有 **25 个块**
而 `STA_RESULT viol_hold=` 是 **16**。引用时**必须用 `STA_RESULT` 的计数**，
不能用报告块数（我在第 7 轮的分类脚本里就是用块数，已在文档中注明两者不同）。

---

## 6. 下一轮候选

1. 用同样的 overlay 手法把 **setup 侧的边界假设**也量化一遍（目前 setup 三角全 0，属确认性工作）。
2. 修好放置模型并用对照证明（第 7 轮的前置条件），再回到 LVS 残差。
3. F3 的 wrapper 实验；交付 README 的 LEF 计数改正。
