# 后端恢复验收与后续发展

日期 2026-09-30。先恢复可复现基线，再关闭正确性/签核问题，最后优化 PPA。当前没有新的 DC/FC/PT/Calibre 成果。

## 里程碑与完成标准

| 阶段 | 工作 | 通过标准 |
|---|---|---|
| M0：公开静态基线 | 文档、161 份 evidence hash、LUT/语法/SDC 错误传播、独立 RTL smoke | `make check`、`make smoke` 有成功标记，范围明确，历史 evidence 不变 |
| M1：工具与复现恢复 | 找回私有环境和版本化主脚本，创建独立 run 目录 | 固定输入/工具/库/RC/deck/命令与 hash；小设计完成工具/许可证/库检查，失败可定位 |
| M2：功能/约束闭合 | 独立校准数值、SRM 时钟/相位/异常回归、CDC/RDC、reset release、GLS/LEC | 参数/接口契约通过，CDC/RDC 未解释问题清零，所有例外有原因与证据 |
| M3：物理签核闭合 | PG、LVS、DRC、hold、电气规则、天线/密度、MMMC/RC | 结果清零或有正式批准且适用的 waiver，未覆盖检查逐项解释，最终产物身份一致 |
| M4：PPA 和产品接口 | 利用率扫点、校准存储/算术优化、功耗、模拟/片外接口 | 相同边界/库/约束/活动下比较，满足 M2/M3 后保留 Pareto 候选 |

## M1：私有环境需要找回的材料

1. DC/FC/PT/Formality/Calibre 的可执行文件、版本和有效许可证；SSH 连通不作为工具可用的证据。
2. 标准单元 `.db/.lib`、NDM/LEF、tech/层映射、GDS/CDL/仿真模型、RC 文件和 Calibre deck；公开库只记录版本与 hash，不提交厂商数据或私有路径。
3. `dc_synth_paper_core.tcl`、`fc_pnr_paper_core.tcl`、`sta_pt_paper_core.tcl`、GDS merge、DRC/LVS 和结果收集驱动。历史 env 中三个 Tcl MD5 可帮助核对原脚本。
4. 原 post-route SPEF、SDF 和完整 Formality/GLS 输入，确认同一 netlist/GDS/SDC/RC corner 的关联，不能将任意同名文件拼成一个 run。

新 run 使用 `runs/<run_id>/`，保存输入 manifest、命令、日志、结果与退出码。修改清理器/探针之前先读具体目标，重跑脚本只删除自己创建的 run 目录。

[`constraints/sar_digi_paper_core_pnr.sdc`](../constraints/sar_digi_paper_core_pnr.sdc) 是保留 10/3 ns 和原 IO 假设的严格候选：端口不存在或命令失败即报错。已测的是 Tcl mock，需在 FC 中检查真实 collection、命令支持和时序语义后再接入主流程。主驱动必须以报告数值判定通过，不能只看 source 返回或 STAGE OK。

## M2：优先关闭的接口与 CDC 问题

Gray 编码目前由二进制计数器组合生成，需评价跃迁毛刺、数据/完成 toggle 的相对到达、正常冻结窗口和超时窗口。比较源端注册 Gray、冻结数据握手/ack、接收端等待稳定及对应 max-delay/bus-skew 约束，不凭注释选结论。同步链布局/标记、时钟停止和两域复位顺序也要纳入 CDC/RDC。

采用各域异步断言/同步释放等可验证复位策略后，审查 reset 网络路径和 recovery/removal 例外范围。不能仅移除 false path 后把异步输入当同步数据，也不能永久跳过释放验收。

回归覆盖：全部 ones count、重复启动、busy 中请求、start/consume 冲突、held start、时钟比/相位、decision gap、部分计数超时、结果覆盖、暂停时钟、忙时复位、raw/residue 配对；校准覆盖两方向、两次完整 sweep、LSB 参考段、保护 MSB、失配/offset/noise/overrange 和权重数值参考。

增加四状态 RTL/GLS、SDF min/typ/max、自判定 checker、门控/脉宽检查及完整 Formality。two-state smoke 和历史相位对齐读数不能代替这些验收。5 MS/s 要按 200 ns 连续样本间隔测整条请求/采集/发布/消费链，而不是仅比较 `22 × 3 ns`。

## M3：综合、布局布线和签核门槛

| 项 | 必须留下的证据 |
|---|---|
| 综合 | link/check_design/check_timing、参数/源清单、综合网表/SDC、ICG/同步链状态、面积和电气违例；所有未驱动/未读节点归因 |
| PG | 有效 PG pin/library view、PG 连接及几何 DRC；最终 route 后的 VDD/VSS 检查，不只保留优化前报告；后续活动相关 IR/EM |
| 放置/CTS | 利用率、拥塞、端口/analog 边界、同步链邻近及路径预算；两时钟 skew/latency、门控与脉宽 |
| route | opens/shorts/internal DRC、天线规则/修复、tie-cell/tie-to-rail、via/金属层资源，缺规则必须显示未检查 |
| LVS | 同一批 cell GDS/CDL/Verilog、PG/全局网/端口/提取设置；定位上下文/单元边界残差，不能用 boxing 或忽略器件替代全电路匹配 |
| DRC | 无结果截断，区分单元内部、布线、密度和 seal-ring/顶层规则；block 不适用项需说明集成责任及正式 waiver，chip top 补齐 |
| STA | PVT × RC 场景、SPEF 覆盖率、OCV 方法、setup/hold、slew/cap/fanout、clock gating、pulse width、recovery/removal 与 untested reason |
| hold | 同步输入、异步比较器同步器第一级、输出分别处理；用真实 min arrival/负 output delay/CTS 边界决定缓冲和例外，不能统一松约束擦除违例 |
| 交付 | GDS/LEF/网表/SPEF/SDF/SDC/报告 hash 对齐，机器可读 PASS/FAIL/UNKNOWN，waiver 带范围、原因和批准来源 |

scalar derate 扫点可作敏感度分析，不能自动证明完整 MMMC、foundry OCV 或不同 RC corner 已覆盖。功耗分运行/校准/空闲窗口，给出活动覆盖率、时间/频率、PVT 和时钟树/IO 是否计入。

## M4：可能的发展方向

**面积/布线**：以 55/60/65/70% 为候选扫点，比较 cell/buffer/CTS area、overflow、线长、拥塞、hold、DRC 和功耗。M5/M6 使用少可作为层资源实验入口，但用途要由 tech/RC、模拟噪声和布线约束决定。约 20.6% 面积下降目前只是理想比例计算。

**校准逻辑**：历史校准面积 88,106.356 µm²，明显大于 SRM 的 8,306.021 µm²。优先分析内部 `shadow_weights`、加法路径、门控/复位与串行访问，而不是继续削减 LUT。RAM/shared arithmetic 或缩位宽会改变时序/初始化行为，先做独立数值与等价性验收。

**接口/整机**：明确 raw/residue sample ID、错误状态和 ready/consume，评估权重发布/重构/外部 IO 的系统成本，再决定是否片上重构或串行化。如果改变边界，原核心面积不能与新整机面积直接比较。

**模拟联合验证**：接入真实 comparator 决策速率、noise/offset、CDAC settling 和采样时序，验证 SRM 统计、校准误差及整机 ENOB/SNDR。噪声 sigma 与端点 clamp 需测量/规格支撑，生成器重现旧表只证明数值来源可追溯。

**维护**：常用解析器逐步改为显式输入/输出，补坏输入/截断文件对照；保留过程记录但将当前规范集中到 README/接口/问题台账。许可证、release 版本与交付责任后续明确。
