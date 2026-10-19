# SAR16_Digital_Backend_Signoff

> 16 位 5 MS/s 分体采样 SAR ADC 数字核（SMIC 0.18 µm 1P6M）的后端交接复核与签核证据仓库。

## 这是什么

本仓库记录对一个已交付的 16 位 5 MS/s 分体采样 SAR ADC 数字核 `sar_digi_paper_core` 所做的接手复核、独立核查、缺陷修复与签核，时间集中在 2026-09-18 ~ 09-19。

面向两类读者：要复核这个数字核当前时序 / 物理验证状态的人，以及要复用其中 GDS 解析、DRC 归因、hold 裁定脚本的人。方法是「每条结论都必须落到仓库内的原始 EDA 报告或自写解析器输出上，对不上就撤回」——被撤回的 12 处判断逐条记在 `docs/_过程记录/`。

## 当前状态

| 项 | 值 |
|---|---|
| 阶段 | 流片前复核，**未完成流片签核** |
| 最近验证 | 2026-09-19：post-route STA（带 SPEF，三 corner + OCV derate 扫描）、Calibre DRC/LVS、Formality 等价、交付网表门级端到端功能 |
| 关键指标 | 综合面积 97 892.6 µm²（DC typical，SMIC 0.18 µm，其中校准 88 106 / SRM 8 306 / LUT 831.6）；die 430.520 × 429.340 µm，利用率 0.5558；`clk` @ 100 MHz（10 ns）WNS +0.9807 / +0.7947 / +1.0732 ns（typ / slow / fast，post-route）；`dec_clk` @ 333 MHz（3 ns）slack 0.0000 ns；功耗 2.546 mW（**未标注活动率，不可作签核值**） |
| 结论边界 | 有证据：SRM 估计器全路径功能、复位与状态机、setup 时序、RTL↔网表等价。无证据：LVS 收敛、hold 收敛、DRC 上界、校准链端到端 |

签核项现状（全部取自 `evidence/rpt_v51/RESULT_CURRENT.env` 与 `evidence/v51/`）：

| 项 | 结果 |
|---|---|
| 端口 | 178 个（176 信号 + VDD + VSS），端口数两侧一致 |
| 面积 / 单元 | die 184 839.5 µm²；布线后放置 3 626 个标准单元（109 种 master），综合 2 918 cell / 1 051 reg |
| setup | 全 corner 无违例；slow derate 扫到 p8 仍为 +0.7013 ns |
| hold | **29 条未修复**（summary 口径 typ / slow / fast = 1 / 16 / 12） |
| DRC | 421 条规则 / **3 402 条结果（下界）** |
| LVS | **INCORRECT**（0 条 SHORT，50 条错误网） |
| 形式等价 | 1 157 passing / 0 failing（Port 146 + DFF 1 011） |
| 门级功能 | 顶层 `total=22 / ones=7 / residue=966`，与 RTL 相位 0 逐位相同（全程无 force） |

结论速览见 [签核报告](report/SAR16_签核报告_GDS版图_布线_功能_时序_20260919.html)（单文件离线可开，10 张图内嵌，点图可开原分辨率）。其余：[接手报告](report/SAR16_接手报告_缺陷修复与签核_20260918.html)、[独立核查报告](report/SAR16_独立核查报告_20260919.md)、[接口契约补充](report/SAR16_接口契约补充_上电与驱动前提_20260919.md)、[交付说明](report/交付说明_README.md)。

## 快速开始

### 依赖

- Python 3.8+（脚本用到 `sys.stdout.reconfigure`）
- GDS 解析与几何查询：仅标准库（`struct`），无第三方依赖
- 出图与报告生成：`matplotlib`、`numpy`
- 综合 / P&R / STA / DRC / LVS 部分另需 DC、Fusion Compiler、PrimeTime、Calibre 与 SMIC 0.18 µm 库，本仓库不含 PDK

### 运行

```bash
python3 tools/gds_query.py evidence/rpt_v51/sar_digi_paper_core_merged.gds
python3 tools/make_figures.py evidence/rpt_v51/sar_digi_paper_core_merged.gds evidence/figures
python3 tools/chk_html.py report/SAR16_签核报告_GDS版图_布线_功能_时序_20260919.html
```

`make_figures.py` 的两个参数分别是 GDS 与输出目录，缺省值就对应当前目录布局（在 `tools/` 下执行时用 `../` 前缀）。

### 验证

`chk_html.py` 会对报告做标签配平与外部引用检查，期望输出：

```text
=== skeleton ===  全部 OK
RESULT: PASS
```

非 `PASS` 时退出码为 1，可直接用于脚本判断。至于数字本身，没有自动化回归——见「已知限制」。

## 目录结构

```text
report/      4 份报告（签核 / 接手 HTML，独立核查 / 接口契约 MD）与交付说明
docs/        49 篇过程记录（_过程记录/）、清理清单、2 份报告副本
evidence/    原始 EDA 报告与交付件副本（GDS / 网表 / LEF / SPEF / CDL / RTL / SDC）+ 工具输出 + figures/
figures/     4 张 GDS 渲染图，与 evidence/figures/ 逐字节相同（待清理）
tools/       120 个 Python 脚本：GDS 解析与渲染、DRC / STA / hold 归因、报告生成
probes/      114 个一次性探针脚本（bash），需在 EDA 机器上执行，路径为占位符
organize_scratch.py  交接目录整理脚本，一次性动作，与仓库其余内容无调用关系
```

## 设计

### 模块划分

| 模块 | 行数 | 职责 |
|---|---|---|
| `sar_digi_paper_core` | 371 | 顶层：端口、跨域连接、可选权重寄存器堆、raw code 打拍 |
| `sar_calib_ctrl_serial`（`u_calib_ctrl`） | 774 | 前台一次性校准：20 次 DAC 试位，每次 32 轮平均，结果经 `w_wr_*` 以发布流方式送出 |
| `srm_residue_estimator`（`u_srm_residue`） | 599 | SRM 残差估计：22 次额外判决计数，输出 10 bit 残差与 5+5 bit 计数 |
| `srm_residue_lut` | 222 | 估计器内的组合 LUT（5 in / 5 out），面积 831.6 µm² |

- 面积分解（DC typical）：校准 88 106 µm²、SRM 8 306 µm²、LUT 831.6 µm²，顶层合计 97 892.6 µm²。
- 按论文口径，加权求和与重构在**片外**，本核不含 SAR 时序逻辑（`raw_bits_i` 是输入），也不含 weight RAM / 乘法器 / 加法树。
- 可选重量寄存器堆（`WEIGHT_EXPORT_REG=1`）实测 39 248 µm²、占核 24 %，因此默认关闭，权重只经 `w_wr_*` 发布。

### 时钟域

| 时钟 | 约束 | 用途 | post-route slack（typ / slow / fast） |
|---|---|---|---|
| `clk` | 10.0 ns（100 MHz） | 校准控制、raw code 打拍、SRM 读回与握手 | +0.9807 / +0.7947 / +1.0732 ns |
| `dec_clk` | 3.0 ns（333 MHz） | 逐次判决计数（每次判决都要计数） | 0.0000 / 0.0000 / 0.0000 ns |

- 两域以 `set_clock_groups -asynchronous` 声明为异步，跨域不靠 STA 保证。
- `clk → dec_clk`：单比特 `go_tgl` 翻转 → 3 级同步 → 边沿检测产生一个 `dec_clk` 脉冲。
- `dec_clk → clk`：单比特 `dec_done_tgl` 2 级同步；计数读回 `ones_g` / `tot_g` 为 2 × 5 bit 格雷码 → 2 级同步。
- `calib_comp_out` 是异步比较器输出，RTL 内 2 级同步；STA 无法证明其采样正确，需另行做 CDC lint（本仓库未提供）。
- 时钟不确定度 setup 2 % / hold 0.5 %；时钟转换时间为绝对值（0.15 / 0.10 ns），不随周期缩放。

### 接口

178 个端口，按功能四组：

| 组 | 端口 | 所属域 |
|---|---|---|
| 校准控制 | `start_calib` `calib_comp_out` → `calib_done` `calib_done_pulse` `calib_mode_en` `dac_p_force[19:0]` `dac_n_force[19:0]` `calib_overrange` `calib_overrange_bits[19:0]` | `clk` |
| 原始码 | `data_valid_i` `raw_bits_i[19:0]` → `raw_code_o[19:0]` `raw_code_valid_o` | `clk`（输出打拍） |
| 权重发布 | `w_wr_en` `w_wr_addr[4:0]` `w_wr_data[29:0]`（有符号 Q8，LSB_0 = 256） | `clk` |
| SRM 残差 | `srm_start` `srm_decision_valid` `srm_decision_bit` `residue_consume_i` → `srm_busy` `srm_done` `srm_residue_valid` `srm_ones_count[4:0]` `srm_total_count[4:0]` `srm_count_shortfall` `srm_stalled` `srm_residue_o[9:0]` | 判决侧在 `dec_clk`，读回侧在 `clk` |

- 端口排布：M2 只在上下边（46 + 44），M3 只在左右边（44 + 44），零交叉；引脚 0.28 × 0.715 µm；VDD / VSS 为两条贯穿全高的 M2 条带（0.600 × 428.400 µm）。
- `residue_consume_i` 是「残差已被取走」的握手，片外消费者应接到 `raw_code_valid_o` 或显式 ack。
- 端口位宽必须按声明读取：测试台曾因丢位宽只读到 5 bit 总线的 LSB（见 `docs/_过程记录/修复15_顶层计数读数结案.md`）。

## 已知限制

- **LVS 未收敛**：端口 178 = 178、0 条 SHORT，但仍有 50 条错误网，残差归因到上下文生成器件与单元边界端口，未消到 0。
- **hold 29 条只裁定未修复**：根因是输入端口直进触发器、`min` 输入延迟只给 0.50 ns 而时钟树是 0.75 ns，不是布线绕远；修复需改 P&R 脚本并整轮重跑。
- **DRC 3 402 条是下界**：BD_1、BD_2a 两条封环检查被 1 000 条上限截断。
- **`dec_clk` slack 恰为 0.0000**：卡在 333 MHz 目标上，没有余量，换库或换温度即可能转负。
- **校准链未做端到端判定**：只证明了 SRM 估计器全路径与复位 / 状态机。
- **无 CI**：仓库没有 `.github/workflows`，上述数字没有任何自动回归保护。
- **重复文件未清完**：`figures/` 下 4 张 `gds_*.png` 与 `evidence/figures/` 逐字节相同；`docs/` 与 `report/` 各存一份独立核查报告与接口契约（两侧均被脚本或报告引用，暂不合并）。

## 许可

未指定许可证，保留所有权利。

本仓库不含 PDK：标准单元库、tech file 等厂商数据一律未入库；`evidence/**/*.lef` 的两个 LEF 是本设计自己的抽象 LEF，不是工艺库 LEF。文件中的主机名、账号、库路径已替换为 `<vm-host>` / `<user>` 一类占位符，脚本里保留的只是路径字符串。
