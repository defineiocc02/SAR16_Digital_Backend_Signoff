# SAR16 片上数字核 · 最终 GDS 交付包

**交付日期**：2026-09-18
**取代**：本包取代 `delivery_v42/README_GDS交付说明.md`（v4.2/v4.3）与
`delivery_round3/README_round3交付说明.md`。**旧包保留不改**（历史不覆盖）。

> **2026-09-18 接手复测更正（不改写历史，只标定误数）**：正文 §5.2 的 LEF 计数
> `MACRO 115 / PIN 665` 是**误数**。以严格块嵌套口径重数**本包内**的
> `gds/sar_digi_paper_core.lef`（186 570 B，md5 `6a179419c96c27c72f7afaab27182258`）
> 实测为 **MACRO 112 / PIN 652**；口径 = 顶层 `MACRO <name>` 块数 + 宏内第一层
> `PIN <name>` 块数，结构自检 CLEAN（每个 `END` 正确闭合、EOF 深度归零）。
> §5.2 的**结论（没有 `MACRO sar_digi_paper_core`，本 LEF 不能当块 abstract）不受影响**，
> 只是数字要更正。接手后的最新状态、LVS 器件残差归因与完整时序/布线/功能报告见
> `04_工作记录/SAR16_接手报告_缺陷修复与签核_20260918.html`。

---

## 1. 主交付件

| 文件 | 字节 | 身份 |
|---|---|---|
| **`gds/sar_digi_paper_core_merged.gds`** | **4 331 596** | **md5 `a9474b6c478fe6fcf525c670fb00c886`** |
| `gds/sar_digi_paper_core.lef` | 186 570 | MD5 见 `reports/RESULT_CURRENT.env` |
| `reports/sar_digi_paper_core_pnr.v` | 381 121 | 布线后网表 |
| `reports/sar_digi_paper_core_pnr.sdc` | 109 465 | P&R 阶段约束 |
| `reports/sar_digi_paper_core_pnr.spef.smic18_par_125.spef` | 7 042 533 | 寄生参数 |
| `reports/RESULT_CURRENT.env` | 2 380 | 全部指标的机读汇总（59 键） |
| `reports/fc_pg.rpt` | 1 343 | 规划阶段 PG 连通报告 |
| `reports/lvs.rep` | 1 035 332 | Calibre LVS 报告 |
| `reports/drc_CAL.SUM` | 32 911 | Calibre DRC 汇总 |
| `reports/fc_pnr.log` | 951 805 | P&R 全量日志（含 `PG_STEP` 步骤账本） |
| `scripts_backup/` | — | 本轮改动的**全部**脚本备份与 diff |

**GDS 结构（独立解析器实测，非工具自报）**：
顶层 cell = **`sar_digi_paper_core`**；struct 数 **231**；层对 **19**；
**顶层 234 个 TEXT 标签 = 232 个信号引脚 + 1 个 VDD + 1 个 VSS**；
文件末 4 字节 = `00 04 04 00`（ENDLIB，无尾部填充）。


---

## 1b. **v5.1 现行交付身份**（2026-09-18 接手轮次；数字全部取自 `RESULT_CURRENT.env`）

| 项 | v5.1 现值 | 来源键 |
|---|---|---|
| 交付 GDS | **4,243,084 B**，md5 `e846246127c86f3a4256a34de2ff7344` | `delivered_gds_bytes` |
| GDS 顶层 / struct 数 / 层对 | `sar_digi_paper_core` / **225** / 19 | `delivered_gds_*` |
| 交付 LEF | **179,611 B**（MACRO 109 / PIN 630，见 §5.2 更正） | `pnr_bytes_lef` |
| 布线后网表 | **378,258 B** | `pnr_bytes_netlist` |
| 寄生参数 SPEF | **6,958,499 B** | `pnr_bytes_spef` |
| die | **430.520 × 429.340 µm = 184839.457 µm²** | `die_*` |
| 综合面积 typical | **97892.625106 µm²**（2918 cell / 1051 reg） | `dc_area_typical` |
| STA clk slack（typ / slow / fast） | **+0.9807 / +0.7947 / +1.0732 ns** | `sta_*_clk_slack` |
| STA clk Fmax（typ / slow / fast） | 110.9 / 108.6 / 112.0 MHz | `sta_*_clk_fmax` |
| slow derate 扫描 p0/p3/p5/p8 | +0.794725 / +0.759686 / +0.736327 / +0.701290 ns（**全线为正**） | `derate_slow_*` |
| DRC | 421 条规则 / **3402 条结果** | `drc_*` |
| LVS | **INCORRECT**（不是通过；残差归因见接手报告 §1.6–§1.10） | `lvs_verdict` |
| 功耗（**未标注活动率**，不可作签核值） | 2.546 mW | `power_total_mw` |

> **与 §1 表的关系**：§1 的哈希是 v4.3 时点的历史记录，**保留不改**；
> 本节的 v5.1 值是接手轮次后的现行交付身份。两版的接口收窄、引脚修复、
> LVS 短路清零与 hold 边界量化，详见
> `04_工作记录/SAR16_接手报告_缺陷修复与签核_20260918.html`。

**独立核查已复核的事实**（自写激励 + 自写判定，**无 force**；完整版见交接包 `docs/独立核查报告.md`）：

| 项 | 实测 | 口径 |
|---|---|---|
| RTL ↔ 交付网表等价 | **1157 passing / 0 failing** | Formality 独立 run（Port 146 + DFF 1011） |
| 交付网表端到端功能（SRM 全路径） | 顶层 `srm_total_count=22 / srm_ones_count=7 / srm_residue_o=966`，与 **RTL 相位 0** 结果**逐位相同**（即 **RTL@相位0 ≡ 网表@相位1**） | 自写 TB，无 force；端口须**按位宽**读 |
| 复位 | `rst_n → INVX8 → HFSNET_124 → 反相器 → HFSNET_119`；`rst_n` 0→1 后两子模块 20 ns 内跟随 | 反向追踪 + 仿真实测 |
| GDS 放置账 | 顶层 **115 种 master / 34 356 SREF** = 30 730 过孔 + **3 626 单元**，与网表/LVS 逐项闭合 | 自写解析器（被解析文件与交付 GDS 同 md5） |
| GDS 逐层几何 | **37 836 个图形 / 103 969 µm²**；M2 占 46 %，**M5+M6 合计仅 74 个** | 同上 |
| hold 违例 | PT `viol_hold` = 1 / 16 / 12 = **29** | 口径已写入 `RESULT_CURRENT.env` |

---

## 2. 本轮（最终轮）修好的四件事

| # | 缺陷 | 修法 | 验证 |
|---|---|---|---|
| 1 | **交付 GDS 顶层是 `LIBRARY` 包装 cell**（`layout filemerge` 的容器），导致 die 尺寸等一切按错误对象取数 | 合并后用 `layout gdsout <file> <cellName>` 以设计根为顶层重写 | `delivered_gds_top=sar_digi_paper_core`；`LOADCELLS=231` |
| 2 | **die 字段量错对象**（旧值 227.860 × 337.300 µm 是包装 cell） | `collect_result.sh` 拆成 `topcell` / `rootbbox`，die 用 `rootbbox`，读不到就报 NONE 而非编数 | **430.090 × 429.340 µm，184 654.841 µm²** |
| 3 | **LVS 全部器件报 `bad component subtype`**：kit CDL 用 `N`/`P`，deck 用 `n18`/`p18` | 在**消毒副本**上把 M 行第 6 列映射为 `n18`/`p18`（kit 母版不动），改完统计并强制残留 = 0 | **N→n18 5 145 行 / P→p18 5 191 行，残留 0；`bad component subtype` 51 条 → 0** |
| 4 | **VDD/VSS 在版图里无具名引脚**（ERC：`no data for layout net name VDD`），井/体端被并到 `RST_N`（**15 153** 个连接） | 条带加 `-extend_low/-extend_high design_boundary_and_generate_pin`，延伸到边界并生成供应引脚 | 交付 GDS 里 **VDD 1 / VSS 1** 标签；ERC 该告警**消失**；`RST_N` 异常**消失** |

**顺带修掉的两个"报告会说谎"问题**：
- **DRC 结果数被 1000 上限截断**。两次尝试提高上限的 SVRF 写法（`MAXIMUM RESULTS/RULECHECK` 与
  `MAXIMUM RESULTS`）都被本版本 Calibre 拒绝，命令行也无此选项 ⇒ **不改上限**，
  改为**优先读括号值**（`RULECHECK BD_1 ... = 1000 (1475)` 中 1475 才是真值），并显式标注 `[capped ... true ...]`。
- **GDS 尾部 1 972 字节零填充** ⇒ 按记录走查落在 ENDLIB 时裁掉，且只在**恰好落在 ENDLIB** 时才动文件。

---

## 3. 最终指标

### 3.1 PG（电源地）—— 已连通

| | 规划阶段（`fc_pg.rpt`，布局前） | **布线后（独立复测）** |
|---|---|---|
| VDD 线 / 过孔 | 60 / 731 | 60 / 731 |
| VSS 线 / 过孔 | 60 / 731 | 92 / 783 |
| **VDD 浮空单元** | 3517（**阶段产物，见下**） | **0** |
| **VSS 浮空单元** | 3517（**阶段产物**） | **0** |
| 浮空线（两网） | 0 | **0** |

> **口径说明（重要）**：`check_pg_connectivity` 在**布局前**报"浮空单元"是**必然的阶段产物**
> —— 那时单元 PG 引脚还没被布线打通。**这条命令的判据只能在布线后取。**
> 把规划阶段的 3517 当成缺陷是**口径错误**（本项目此前就这样错过一次）。

### 3.2 DRC（Calibre DRC，`SMIC_CalDRC_018LGMS_1833_V1.19_REV1_0`）

```
TOTAL RULECHECKS EXECUTED = 421
逐规则真值合计            = 3493
```

| 规则 | 真值 | 说明 |
|---|---|---|
| `BD_1` | **1475** | 芯片级 BORDER 规则（deck 自述不适用于 IP 级），**被 1000 上限截断写入** |
| `BD_2a` | **1002** | 同上 |
| `NW_2a` | **776** | N 井间距；单 `DFFSX1` 实验证明**不由单元内部产生** |
| `M1_2` | **205** | METAL1 间距 —— **本轮新增 PG 条带/过孔带来的新结果** |
| `M1_1` | 15 | |
| `V1_2` / `M2_2` | 各 6 | |
| `V1_1`, `GT_12`, `M1_7`…`MT_6` | 各 1 | 密度类为真实结果 |

**如实说明**：PG 连通带来的 METAL2 条带与过孔**新增了约 205 条 `M1_2` 间距结果**（总数 3284 → 3493）。
这是真实代价，不是测量噪声。`BD_*` 的 **2542+ 条**属芯片级规则不适用，但**豁免须由负责人批准，本包不宣告豁免**。

### 3.3 LVS（Calibre LVS）—— **仍 `INCORRECT`**

| | v4.3 | round-3 | **最终** |
|---|---|---|---|
| `Ports` | 204 vs 183 | 190 vs 190 | **183 vs 183（无 `*`）** |
| `Nets` | 27262 vs 27234 | 26861 vs 27041 | **26831 vs 27034** |
| `Instances` | MN +334 / MP +378 | MN +338 / MP +401 | MN **+406** / MP **+437** |
| `bad component subtype` | **51 条** | 51 条 | **0 条** ✅ |
| `RST_N` 连接数异常 | 15153 | 15153 | **已消失** ✅ |
| 错误类型 | 4 类 | 4 类 | **4 类**：不同 nets / 不同 instances / connectivity / property |
| 未匹配对象 | — | — | **30 个 "unmatched injected instance" + 1 个 unmatched port** |

**结论**：**LVS 未收敛。** 本轮消除了一个**真实的抽取配置错误**（器件子类型）与一个**真实的电源具名缺失**
（`RST_N` 异常），但**器件数量差（±0.8 %，约 410/437 个 MOS）依然存在**，
且**没有任何证据支持"它会在不改设计的前提下自行收敛"**。剩余差异是**源侧与版图侧的器件记账差**，
需要下一轮单独定位（方向：deck 的 injected instance 与 tie/去耦类单元），**不属于本轮交付的完成条件**。

### 3.4 时序（post-route STA，含寄生）

| 角 | `clk` slack | `clk` Fmax | `dec_clk` slack | `dec_clk` Fmax |
|---|---|---|---|---|
| typical | **+0.9138** | 110.1 MHz | 0.0000 † | 333.3 MHz |
| slow | **+0.6939** | 107.5 MHz | 0.0000 † | 333.3 MHz |
| fast | **+1.0211** | 111.4 MHz | **+0.0815** | 342.6 MHz |

slow derate 扫描：`p0 +0.6939` / `p3 +0.6622` / `p5 +0.6411` / **`p8 +0.3827`** —— **全线为正**。

> † 那两条 `0.000000` 是**门控锁存器 D 端的结构性零**（`data arrival = data required`），
> **不携带设计信息**。该域真实数据寄存器的最差余量（隔离实验实测）为 **setup +0.53 ns / hold +0.34 ns**。
> **这是报告口径问题**（sign-off 脚本对 `clk` 组有 `VACUOUS_NOMINAL` 守卫，对 `dec_clk` 没有）。

**注意一处真实退化**：`clk` 域 slow slack 由上一轮的 **+0.8082 → +0.6939 ns**（−0.114 ns），
**这是新增 METAL2 电源条带带来的布线负载**。余量仍为正，但**这是 PG 连通的代价**，如实记录。

### 3.5 综合与利用率（未受本轮影响）

`dc_area_typical = 98 378.279488 µm²`（与上一轮**逐位相同**，因本轮只动 P&R/DRC/LVS 脚本）；
`fc_util = 0.5604`；`fc_block_area = 184 066.3440 µm²`。

---

## 4. 脚本改动与回退

| 脚本 | 改动前 md5 | 改动后 md5 |
|---|---|---|
| `fc_pnr_paper_core.tcl` | `abd48397…`（本日更早）→ `98bc8d8f…` | **`44890f4d10e108bd8135421a314a8d4c`** |
| `run_lvs_paper_core.sh` | `bb632fd0…` | **`d21c81c9e344cc0fe331ccaaf9b64419`** |
| `run_calibre_drc_paper_core.sh` | `d598f3e5…` | **`76744ac17f3c08534a742a8990f6045f`**（后又加裁剪，见 `scripts_backup/`） |
| `collect_result.sh` | `60f9e65d…` | **`e2523167d5eeb32dda177e352769b109`** + 反引号修复 |

**全部备份与逐次 diff 在 `scripts_backup/`**（含 `patch_round3.diff`，以及
`.before_capfix` / `.before_tagfix` / `.before_trim` / `.before_backtick` 各阶段快照）。

**回退**：把 `scripts_backup/` 中对应脚本覆盖回 `$PC/scripts/` 即可；
上一版产物（v4.3 GDS `78ff73bc…`）完整保存在审计封存包
`_audit/TASK-000R_20260918/` 内。

**改过的**：`fc_pnr_paper_core.tcl`、`run_lvs_paper_core.sh`、`run_calibre_drc_paper_core.sh`、`collect_result.sh`。
**未改**：SDC、RTL、设计、PDK、DRC/LVS deck 的**规则本身**、除数、`LIBRARY` 名。

---

## 5. ⚠️ 交付前必读的未闭合项

1. **LVS `INCORRECT`**（§3.3）—— **这是本包最重要的未闭合项**，不得据本包宣称流片就绪。
2. **块自身 abstract 缺失**：`write_lef -design` 给出的是 **112 个标准单元**的帧视图
   （MACRO **112** / PIN **652** —— 2026-09-18 接手复测更正，原文 115/665 为误数），
   **没有 `MACRO sar_digi_paper_core`**。
   ⇒ **本 LEF 不能作为该块的集成 abstract 使用**；下一步候选是 `create_abstract`（未验证）。
   （接手轮已实测：FC W-2024.09-SP3 在「顶层块 + 无父层」前提下**不支持**产出块自身 abstract，
   `create_abstract` 报 `ABS-297 Could not find any instantiation for the given block(s)`，
   `write_lef` 的六个变体全部不含块自身 MACRO，库里也只有 `design.ndm` 一种 view。
   仍未试的候选是**造父层 wrapper 例化本块再从父层调 `create_abstract`**。）
3. **DRC 2542+ 条 `BD_*` 芯片级 BORDER 结果**：单 `DFFSX1` 实验证明它们在**库单元内部就会触发**，
   与 deck 自述一致；**但豁免须批准，本包不宣告豁免**。
4. **`M1_2` 205 条为 PG 新增**，需要下一轮检查是否可修。
5. **`dec_clk` 报"0.000000"是报告口径缺陷**（不影响硅，但会影响读数）。
6. **未做**：CDC lint（SDC 自己声明"not optional and not delivered by this file"）、
   带 SDF 的门级仿真、IR-drop、`dec_clk` derate 扫描。
7. **功耗数字是部分标注下的结果**（`PWR-414/415` 未标注主输入与时序单元输出），
   `power_total_mw=2.556` 不可直接引用为签核值。

---

## 6. 复现

```bash
cd /home/<user>/sar16_work/proj_paper_core && bash scripts/reproduce_all.sh
```
六个阶段（预检 → DC → P&R → STA → DRC → LVS → 汇总），本轮实测 **约 720 s**。
`reproduce_all.sh` 会把 `scripts/` 同步到 `/tmp`（缺失即硬失败），并在阶段前做输入锁比对；
本轮因改过脚本，`INPUT_LOCK` 会**如实报 DIFFERS**（这是锁在工作，不是故障）。
