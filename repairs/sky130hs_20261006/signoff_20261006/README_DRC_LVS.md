# SAR16 SKY130HS：真实 GDS DRC / 提取 LVS 及修复结果

## 最终结论

选定 **candidate_v2_diodefree**：

- Magic 8.3.684，GDS `drc(full)`：**0 违规矩形**
- KLayout 0.30.0，真实 GDS BEOL/off-grid：**0 标记**
- Netgen 1.5.324，Magic 晶体管级提取对官方几何匹配 SPICE：**电路唯一匹配、器件属性错误 0**
- 双方均为 4,335 网、4,301 功能单元实例；提取层次展开含 28,244 PFET、27,929 NFET 和 4 个电阻原语（Netgen 合并器件前）
- 原有全部物理门禁 PASS；数字等价 9 项含负对照重新运行两遍均 PASS
- **无规则豁免，无金参考改值，无检查属性删除**

这是公开 SKY130HS 1.8V 数字核心的实际开源验证，不等于专有 foundry 签核或完整模拟 ADC 验证。密度等边界见末节。

## 为什么需要这次补充

旧版 run_v6 完整保留。之前跑的是 router DRC、布线/电源连接与数字等价，不能代替合并标准单元真实 GDS 后的 DRC 和器件级提取 LVS。本次补齐了工艺规则、器件参考、Magic / Netgen / KLayout，并先检查冻结原版，再建立独立修复候选。

原版真实检查结果：

- Magic full：2,838 个原始违规矩形，不代表 2,838 个独立根因
- nwell 间距 1,689；nwell 宽度 115；无接金属的 N+ tap 480；P-diff 到 tap 距离 516；LI 间距 23；core LI 间距 15
- KLayout BEOL：6 个 LI 间距标记，集中在 3 个时钟接入点
- LVS：布局 4,577 网对参考 4,335 网，多出的 242 个均为未接回 VDD 的 VPB/well 岛

根因一是未插标准单元 filler，well 不连续。根因二是 dfrtp_1 的 CLK LEF 矩形覆盖了实际 GDS 的缺口，3 个 mcon 接入 via 落在缺口附近。

## 最终物理修复

1. 插入官方 HS fill_1/2/4/8，最终 filler 共 8,900 个，使 well 连续
2. 3 个 dfrtp CLK 接入 via 从 local y=1.665 移到 1.480 µm，各补 0.185 µm metal1 小折线
3. 移除 8 个有官方参考周长问题的 antenna diode，并补回曾由其内部 LI 连接的真实布线分支
4. 用实际跨层布线消除天线：clk 的 1.44 µm met4 跨接、clknet_4_8_0_clk 的 0.72 µm末端分支从 met3 升到 met4，以及 _0827_ 的 met2 桥接；另补齐合法 landing 面积

RTL 和功能逻辑不变；剩余原有 5,757 个实例（4,301 功能/缓冲 + 1,456 tap）、全部 178 个物理端口、4,200 个数据库网名/类型、原实例位置/方向均保持。最终总实例 14,657、98 种 master，空 cell 为 0。

移除 diode 不是跳过天线检查：从最终冻结 ODB 在新进程重读，确认 diode 实例和 DIODE 端子均为 0，同时天线违规 0/0。全部 3,230 个 master-pin 的 gate/diffusion antenna 数据以及工艺天线规则与原版一致。

## 最终复检

| 项目 | 结果 |
|---|---|
| Magic 完整公开几何规则 | 0 |
| KLayout BEOL/off-grid | 0 |
| 提取 LVS 拓扑及器件属性 | 唯一匹配，属性错误 0 |
| Router DRC、placement、信号/电源连接 | PASS |
| 全部已连接网 SPEF 覆盖 | PASS |
| 电气、13 项 CDC bounds、reset、Gray span | PASS |
| Fresh-process antenna | net 0 / pin 0 |
| Nominal setup / hold WNS | 1.062018 / 0.153111 ns |
| Scalar-stress setup / hold WNS | 0.947274 / 0.050880 ns |
| RTL→mapped→最终 routed 数字等价 | 9 项两次全部 PASS，含 5 个应产生反例的负对照 |

数字证明覆盖全部 20 个功能输出端口 / 146 bit、846 个 mapped/routed 状态 bit，2,689 + 2,684 项归纳义务及 849 + 848 项复位检查。Filler 仅在逐项验证为 LEF CORE SPACER 且只有电源/地引脚后以无逻辑输出处理，没有 blackbox 功能单元。

## 面积

外框仍为 392.98 × 392.98 µm（154,433.2804 µm²），core 为 135,032.832 µm²。

- 逻辑含 buffers：64,567.368 µm²
- Tap：2,327.2704 µm²
- Antenna diode：0
- Filler：68,138.1936 µm²

Filler 是填补现有空位，不能把其面积当作新增逻辑或芯片面积翻倍。

## 库兼容问题与处理

官方 HS diode_2 的 GDS 扩散区为 0.69×0.93 µm：面积 0.6417 µm²、周长 3.24 µm；Magic 与独立 KLayout 均确认，官方 SPICE 却为 7.32 µm。单独提取该官方单元也复现属性错误。新旧官方版本和导入设置被核对，不能靠修改金参考强行通过。

HD 库存在已由官方修正且可通过 LVS 的 diode，但其行高/电源轨与 HS 不匹配，因此最终没有混用不兼容库。最终选用不需要 diode 的真实布线修复，完整保留官方参考与属性检查。库问题证据保存在 `pdk/PDK_AUDIT.md` 和 `pdk/diode_recovery/RECOVERY_REPORT.md`，作为过程记录，已不阻塞最终无 diode 候选。

同时避开了新版 conb_1 的布局/电阻长度变化：所选参考版本与冻结 ORFS GDS 逐 master 几何一致，不是把不匹配的最新版强套到旧布局。

## 证据入口与身份绑定

- `signoff_summary.json`：机器可读总状态及最终 hash
- `candidate_v2_diodefree/`：最终 ODB/DEF/Verilog/SPEF/SDC/SDF、全部旧门禁、真实路线图、修改及模型不变性审计
- `verification/candidate_v2_diodefree/`：独立合并 GDS、提取 SPICE、原始 DRC/LVS 报告
- `verification/candidate_v2_diodefree/reports/final_gds_binding.json`：独立验证 GDS 与候选 GDS 除 GDS 创建/修改时间字段外，所有记录逐字节一致
- `equivalence_candidate_v2_diodefree_compact_evidence.tar.gz`：最终候选数字证明、原始日志、反例、来源及复现脚本
- `reports/`、`logs/`：冻结原版的失败证据；run_v6 本身未修改
- `pdk/`：未改工艺规则、几何匹配官方 SPICE、源码版本/校验和、库问题复现
- `tools/`：工具来源/版本/校验和与安装脚本；不含编译后二进制
- `scripts/verify_variant.sh`：stream-out、提取、Netgen、Magic、KLayout 验证入口

最终 routed.v SHA256：`b6b2f6ab56f5d565d26b2ccacfcb1af9e751b0bf1100595bb16942449e35cce5`
最终 routed.odb SHA256：`e7fcd87e358a1848c7e1d2fdde08280773994c176907caecc541867e81e09792`

本补充包配合此前的 SAR16 core 与 environment 使用，保留执行时的路径和 hash 便于审计。恢复到其他目录须调整安装/运行路径；不是包含所有工具二进制的容器镜像。

## 覆盖边界

Magic `drc(full)` 覆盖本次公开 FEOL/BEOL 几何，包括 router 曾忽略的 mcon/via 各层 enclosure 对应规则，但不是完整 foundry rule deck。标准 DRC 不包含 density 和完整 antenna signoff。

官方密度工具要求至少 700×700 µm 检查窗口，本 392.98×392.98 µm standalone block 更小，必须在顶层集成后进行窗口密度验证；简单面积比不能替代该检查。这里的 antenna 0/0 是原始工艺/单元模型下的实际 fresh-process 结果，不宣称专有 foundry 天线认证。本任务不证明完整模拟 ADC 的 SNDR/ENOB，也不是 SMIC180 工艺签核。
