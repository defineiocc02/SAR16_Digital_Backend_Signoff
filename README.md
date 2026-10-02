# SAR16 数字后端：静态接手、复现与签核整改

本仓库保存 `sar_digi_paper_core` 的 v5.1 RTL、布线后网表、GDS 和历史复核记录，目标工艺为 SMIC 0.18 µm 1P6M，历史流程为 **DC → Fusion Compiler → PrimeTime → Calibre**。

**当前状态：可以审计和运行独立 RTL 冒烟测试，物理签核尚未闭合。** LVS、hold、DRC、最终 PG 连通性证据和 CDC/RDC 仍需整改；仓库名中的 Signoff 表示工作范围，不表示已经具备流片条件。

2026-09-30 的静态接手结论见 [静态审计报告](docs/static_audit_20260930.md)；2026-10-01 的 [RTL PPA 与 JSSC 2025 对标分析](docs/ppa_paper_comparison_20261001.md) 包含面积对账和 SRM 持续请求实验。2026-10-02 再次完整复核四份 RTL 和论文原理，新增 [原理、功能与综合电路详解](docs/rtl_principle_review_20261002.md)：确认了默认 SRM 超时后旧完成事件错配、校准量化偏差以及非默认 LUT 格式问题。集成与整改要求见 [当前接口契约](docs/interface_contract.md)、[恢复流程与发展路线](docs/backend_recovery_plan.md)。原始 `evidence/` 保持不变，历史报告用于追溯。

## 设计边界

本块用于 16 位、5 MS/s 分体采样 SAR ADC 的数字接口与辅助处理，包含串行前台校准、SRM 双时钟域计数/LUT 和 raw code 寄存输出。

| 包含 | 外部提供或执行 |
|---|---|
| 校准控制、CDAC 强制码、权重发布流 | CDAC、比较器及模拟 settling |
| `dec_clk` 域 SRM 计数，`clk` 域结果发布 | 比较器决策时钟和与其同步的决策流 |
| 20 位 raw code、10 位 signed Q8 residue 输出 | SAR 转换时序、片外权重存储和重构 |

**当前实现覆盖数字辅助处理，完整 SAR 转换时序和 ADC 验证平台仍需集成。** “片外重构”是当前实现的设计划分。2026-10-01 已核对指定 JSSC 论文原文并验证孤立 SRM 的 200 ns 请求节拍；整机 16 位精度、ENOB/SNDR 和连续 5 MS/s 尚无完整转换链证据。

默认配置为 `CAP_NUM=20`、`WEIGHT_WIDTH=30`、`COMP_WAIT_CYC=16`、`AVG_LOOPS=32`、`MAX_CALIB_BIT=5`、`SRM_DECISIONS=22`、`SRM_SIGMA_Q8=128`、`SRM_RES_FRAC=8`。LUT 固定于该设计点，改参数不能代替重生成和重新验证。`WEIGHT_EXPORT_REG=1` 的表没有可观察读口，当前会被综合删除，不能沿用旧版本“增加 24% 面积”的说法。

## 快速检查：不需要 PDK 或商业 EDA

需要 Python 3.9+、Bash、Tcl；冒烟测试还需要 Verilator 5、make 和支持 C++20 的编译器。

```bash
git clone https://github.com/defineiocc02/SAR16_Digital_Backend_Signoff.git
cd SAR16_Digital_Backend_Signoff
make check
make smoke
make ppa
make review
```

指定已有 Verilator 时：

```bash
make smoke VERILATOR=/path/to/verilator
make ppa VERILATOR=/path/to/verilator
```

| 入口 | 实际检查 | 输出 |
|---|---|---|
| `make check` | 161 份历史证据 SHA-256、Python/Bash 语法（文件数随新增工具更新）、LUT 半表 12 项和全表 23 项、历史 STA/DRC/LVS 摘要一致性；SDC 11 个正常/故障场景 | `build/repository_check.json` |
| `make smoke` | 全部 LUT 地址、raw 输出、SRM 正常/重启/超时/复位，校准两轮各 14 次权重发布；当前 166 项检查 | `build/smoke/{build.log,run.log,result.json}` |
| `make ppa` | 原始网表/LEF 的 3626 个叶单元及面积对账；SRM 12 相位 × 100 样本、200 ns 请求间隔和过早驱动反例；论文条件计算 | `build/ppa/` |
| `make review` | 7 个首目标校准、3 个 SRM 协议边界、2 个 LUT 格式实验；实际 LUT 精确 Binomial 统计；层级/门控/clock/reset 库存 | `build/rtl_review/` |
| GitHub Actions | 同样的公开检查、RTL 冒烟、PPA 复现和已知局限表征 | PR / Actions 检查结果 |

**检查通过只表示这些检查通过。** Verilator 测试使用两状态、零延迟 RTL；SDC 用 Tcl mock 检查错误传播，尚未在 FC 验证。它们不证明亚稳态安全、四状态 X 行为、门级 SDF 时序、模拟校准精度或物理签核通过。Lint 警告保留在日志中，未静默屏蔽。

可单独还原 LUT：

```bash
python3 tools/gen_srm_lut.py --n 22 --sigma-q8 128 --frac-out 8 --clamp -258
```

此脚本是根据交付表还原的生成器，默认输出与历史半表完全一致。原 RTL 注释里的 `gen/gen_srm_lut.py --sigma-uv ...` 不是本仓库可执行命令。默认 −258 由有限概率修正后自然舍入得到，当前 clamp 不额外改变它；端点数值不能作为模拟噪声/冗余范围已经验证的证据。

## PPA 与 JSSC 2025 对标结论

对标 Huang et al. 的 [5 MS/s、16 位 Split-Sampling + SRM 论文](https://doi.org/10.1109/JSSC.2025.3526595)。**当前可以确认 SRM 的数字请求节拍和结构优化机会，整机性能能否达到或超过论文仍需模拟联合验证与物理签核。** 完整分析、口径与复现证据见 [PPA 对标报告](docs/ppa_paper_comparison_20261001.md) 和 [冻结结果](docs/ppa_20261001/)。

| 发现 | 证据与影响 |
|---|---|
| 面积集中在校准逻辑 | 历史 DC 校准控制器占约 90%；PNR 网表保留 600 个 shadow-weight DFF，其中参考位 0..5 占 180 个。将参考段明确常量化的 DFF 毛面积机会约占全块 11.12% |
| 两级结果快照需要复核 | `avg_rounded_r` / `calc_result_r` 各有 30 个 DFF；与参考段合计约 14.86% 毛单元面积。候选尚未实现，需要等价、定点范围、时序与重新综合验收 |
| 孤立 SRM 支持 200 ns 请求间隔 | 1200 个正常样本全部通过；接受 start 到 done 为 120 ns，最后比较到 done 为 40.5–43.25 ns。两状态、零延迟结果不证明完整 ADC 5 MS/s、CDC 或 SDF 时序 |
| start 与决策域 ready 的边界 | phase=0、启动后立即驱动时只收集 20/22 次比较，随后 shortfall/stalled；需明确 prearm/ready 和 raw/residue 样本配对 |
| 校准算法尚未闭合 | 论文校准启用 SS 和 SRM；当前校准控制器没有 SRM 残差输入，不能把默认 P/N averaging 当作论文的 SRM-assisted 校准 |
| 异常恢复存在确定性错配 | 超时未取消决策域测量；晚到旧 done 能把旧 22/22 全 1 计数发布给新全 0 请求，且不置错误标记。`make review` 已复现；修复前超时需受控复位/重同步 |
| 数值保证需收紧 | 半 LSB 是限定模型下的中心估计；无噪声重复平均不消除固定量化偏差。LUT 应冻结 Q8，非默认 Q9/降精度右移存在尺度/偏置问题 |
| 功耗需要真实工作模式 | 2.546 mW 是未活动标注的 DC 值；论文 Logic + SRM counter 预算约 1.922 mW。边界和活动不同，二者差值不能作为实测性能差距 |

本次增加文档、解析工具和实验入口，**原 RTL 未改**，上述面积百分比均为候选结构的毛收益；没有新增综合、布线或活动标注功耗结果。论文整机 0.57 mm² / 5.31 mW / 93.7 dB SNDR 与当前部分数字块的 cell/die area、默认活动功耗不能直接排名。

## 历史结果与未闭合项

以下是 **2026-09-18/19 历史报告的重新解析**，不是本轮重新综合或布线。

| 项目 | 已核对的历史值 | 判断边界 |
|---|---|---|
| DC cell area | 97,892.625 µm²；2918 cells、1051 sequential cells | 不是 die 面积 |
| P&R cell area / 利用率 | 102,300.106 µm² / 0.5558；3626 cells | site-row capacity 184,066.344 µm² |
| GDS die | 430.520 × 429.340 µm，184,839.457 µm² | 与 row capacity 是不同面积口径 |
| 顶层端口 | 31 个名字、176 信号位，GDS 另有 VDD/VSS，共 178 个标签 | 不等同封装 IO 数 |
| `clk` setup slack，typ/slow/fast | +0.980740 / +0.794725 / +1.073170 ns | 仅已覆盖路径；`dec_clk` 摘要为 0.000000，不宣称正裕量或实测 Fmax |
| hold，typ/slow/fast | 1 / 16 / 12；最差 −0.0320 / −0.2020 / −0.0538 ns | 合计 29 是跨 corner 求和，不是 29 个唯一端点 |
| STA 覆盖率 | 每 corner 有 12 项 setup/hold 未测；recovery/removal 各 1011 项全部未测 | reset false path 后不能宣称复位签核完成 |
| PT 电气规则 | fanout 每 corner 65 项；slow 另有 transition 3 项违例 | setup 无负 slack 不代表所有电气规则通过 |
| FC route | 0 opens；440 项 DRC；未定义天线规则、未检查 tie-to-rail | 命令成功不等于结果清零 |
| Calibre DRC | 421 rules；第一列 **2956**、括号列 **3402** | `BD_1` / `BD_2a` 被每规则 1000 上限截断，两列均非完整统计 |
| LVS | **INCORRECT**；178/178 ports，存在网络/器件/属性差异 | 端口相等和旧复核“0 SHORT”不能代替 LVS 通过 |
| PG 证据 | 优化前检查 VDD/VSS 各报 3513 floating std cells | 非最终 GDS 断电的直接证明，但未提供最终 PG 闭合报告 |
| 功耗 | DC 总值 2.546 mW | 活动未标注，不能作为运行/校准功耗签核值 |
| 历史逻辑等价 | 报告记载 1157 passing / 0 failing | 原 Formality 完整 run 未入库，本轮未重跑 |

原始报告位于 [`evidence/rpt_v51/`](evidence/rpt_v51/)，历史摘要见 [`RESULT_CURRENT.env`](evidence/rpt_v51/RESULT_CURRENT.env)，本轮新解析和测试证据见 [`docs/audit_20260930/`](docs/audit_20260930/)。

GDS 的顶层布线普查复核为 37,836 个金属图形、30,730 个过孔实例；M5/M6 分别 72/3 个图形。此处是顶层几何统计，不是全层次金属密度、有效线长或 DRC 连通性证明。

## 仓库组织与可复现程度

| 位置 | 用途 |
|---|---|
| `evidence/rtl_baseline/` | 四份 v5.1 设计 RTL，当前冒烟测试直接编译它们 |
| `evidence/sdc_baseline/` | 两份历史 DC / P&R SDC，作为历史基线 |
| `evidence/tb_baseline/` | 历史 A/B 与 SAIF 测试台，保留原文；A/B DUT 不完整 |
| `evidence/rpt_v51/` | 原始 EDA 报告及 GDS、PNR 网表/SDC、LEF、CDL/SPICE |
| `constraints/` | 会传播约束错误的维护候选 SDC，待 FC 实测 |
| `tests/`、`Makefile`、`.github/workflows/` | 当前公开检查和独立测试入口 |
| `docs/static_audit_20260930.md`、`docs/backend_recovery_plan.md` | 当前问题台账、恢复门槛和发展方向 |
| `docs/ppa_paper_comparison_20261001.md`、`docs/ppa_20261001/` | JSSC 对标、候选收益与冻结的独立 SRM/面积解析结果 |
| `docs/rtl_principle_review_20261002.md`、`docs/rtl_review_20261002/` | 四模块深度复核、原理修正、风险复现和综合资源详账 |
| `docs/baseline_manifest.json` | 161 份原始交付/报告的 SHA-256 锁定清单 |
| `report/`、`docs/_过程记录/` | 历史报告和过程，包括已撤回的判断 |
| `tools/`、`probes/` | 分析工具与历史一次性脚本，不是统一生产后端流程 |
| `figures/`、`evidence/figures/` | 历史版图图像，两处有重复副本 |

**缺少完整商业工具复现闭环。** `dc_synth_paper_core.tcl`、`fc_pnr_paper_core.tcl`、`sta_pt_paper_core.tcl`、主驱动/结果收集/GDS merge 脚本、SPEF、SDF、标准单元仿真模型和完整 Formality run 均未入库。日志能辅助找回设置，不能代替版本化脚本或寄生参数文件。

工艺库和厂商 PDK 不在公开仓库，设计自己的 LEF 已保留。远程主机、许可证和私有 PDK 路径只在恢复后的私有环境配置中维护。本轮确认 SSH 连通，但未验证 DC/FC/PT 的可执行环境和许可证，也未启动商业 EDA。

历史探针包含清理、覆盖和重跑操作，脱敏路径也不能直接执行。`make check` 只检查它们的语法；新实验采用独立 run 目录。新的 RTL 改动先建维护版本并重跑等价/回归，原始 evidence 不覆盖。

## 后续推进顺序

1. **恢复复现链**：找回版本化 DC/FC/PT/LVS/DRC 脚本、私有库/RC/deck 配置、SPEF/SDF 和 GLS/Formality 输入，固定 run 身份。
2. **收紧功能与约束契约**：CDC/RDC、复位释放、SRM arm/consume/shortfall、raw/residue 对齐；接入校准 SRM 残差，补独立校准数值与完整转换链持续 5 MS/s 验证。
3. **关闭物理阻断项**：最终 PG、LVS、DRC、hold、电气规则、天线、覆盖率；每步保留报告及明确的 block/chip waiver 边界。
4. **再做 PPA 与集成**：固定参考权重常量化、数据快照复核、利用率/层资源扫点、活动标注功耗、片外发布接口与模拟边界集成；按同库、同约束、同工作模式衡量实际收益。

55% 提至 70% 利用率在“cell area 不变”假设下只给出容量面积约下降 20.6% 的算术估算。当前已有 2.52% GRC overflow，必须用完整 P&R/STA/DRC/LVS 实验决定，不能作为优化成果。

项目尚未声明开源许可证，后续维护需明确代码与设计产物的授权方式。
