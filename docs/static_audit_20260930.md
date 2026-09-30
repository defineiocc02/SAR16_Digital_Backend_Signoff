# SAR16 仓库静态接手审计

**结论：v5.1 已有可核对的实现资料和有限功能证据，但物理签核未闭合，商业工具复现链不完整。** 本轮补齐当前文档、公开检查和独立协议测试，不将历史“逻辑可运行”升级为“可流片”结论。

日期：2026-09-30。审计基线为 `537cd6d32949789fc129b5e1d6f00d77864b53ec`。覆盖根 README、四份 RTL、两份输入 SDC、两个历史 TB、原始综合/P&R/PT/Calibre 报告、分析脚本和探针。保留原始 evidence、历史撤回记录和交付 GDS。

## 本轮实测与范围

| 检查 | 结果 | 能说明什么 |
|---|---|---|
| 来源与输入身份 | 原始仓库 666 个文件经 Git blob/tree/commit hash 核对；六份 RTL/SDC MD5 与历史 env 全匹配 | 确认审计对象，没有将别的版本拼入基线 |
| 证据锁定 | [161 份文件 SHA-256 清单](baseline_manifest.json) | 防止后续覆盖历史数据；hash 不证明签核通过 |
| Python / Bash | 126 / 118 份语法检查通过 | 不执行探针或清理器，也不证明脚本运行结果正确 |
| 默认顶层 elaboration/lint | 成功，27 warnings：12 WIDTHTRUNC、13 WIDTHEXPAND、1 UNUSEDSIGNAL、1 SYNCASYNCNET | 当前语法/类型可展开；不是 27 个已证明的功能 bug |
| LUT 独立数值检查 | 12 半表 + 23 全表全部一致 | 标准库 inverse CDF 与还原生成器、硬编码表的默认设计点吻合 |
| 独立 RTL smoke | **166 检查通过**，正常/重复 SRM、超时恢复、忙时复位、raw 输出；两轮校准各 14 次发布 | 固定 10/3 ns、两状态、零延迟 RTL；校准只验协议，不验模拟数值精度 |
| 严格 SDC 候选 | **11 场景通过**，包括所需命令失败及缺端口 | Tcl mock 错误传播通过；FC 命令/collection/时序语义待实测 |
| GDS 重解析 | 37,836 顶层金属图形、30,730 过孔实例、178 顶层标签 | 顶层几何/端口账可核对，不证明电气连通和全层次密度 |
| 商业 EDA | SSH 连通；当前 shell PATH 未定位 DC/FC/PT，未验证许可证或启动 EDA | 没有本轮新综合、CTS、route、STA、DRC/LVS 结果；不据此推断整台机器无工具 |

本轮输出在 [audit_20260930](audit_20260930/)。原始报告与摘要解析结果一致，新增 checker 会明确输出 `HISTORICAL_SIGNOFF_NOT_CLOSED`，CI 绿色仅代表公开检查通过。

## 优先级台账

P0 表示交付签核的阻断项；P1 表示下一轮实现/验证必须处理；P2 为代码与维护改进。静态风险与已观察的失败分开列出。

| ID | 级别 | 发现 | 当前性质 |
|---|---|---|---|
| F01 | P0 | LVS `INCORRECT`，存在 nets/instances/connectivity/property 差异 | 原始报告已证实 |
| F02 | P0 | PG 前序报告 VDD/VSS 各 3513 floating cells，没有最终闭合证据 | 已证实报告缺口，非已证明最终 GDS 全断电 |
| F03 | P0 | Calibre DRC 非零且截断；FC route DRC 440，天线/tie 检查不完整 | 原始报告已证实 |
| F04 | P1 | hold 29 个 corner 记录，fanout/transition 未关闭 | 原始报告已证实 |
| F05 | P1 | CDC/RDC、Gray 毛刺/到达关系及 reset release 未独立验收 | 代码与覆盖率显示风险，尚未证明硅上失败 |
| F06 | P1 | 主 Tcl、SPEF/SDF、完整 LEC/GLS 输入缺失 | 仓库清单已证实 |
| F07 | P1 | 原 P&R SDC 吞约束错误，阶段 OK 与报告失败并存 | 代码/log 已证实，严格候选已补但待 FC |
| F08 | P1 | 历史 A/B TB 依赖缺失模块，FAIL/timeout 仍 `$finish` | 代码已证实，独立自判定 smoke 已补 |
| F09 | P1 | SRM arm/consume/shortfall、raw/residue 配对和 5 MS/s 契约未闭合 | 集成假设/测试覆盖缺口 |
| F10 | P1 | 功耗缺活动覆盖，Fmax 仅由 period−slack 估算 | 原报告限定，不能作为实测性能签核 |
| F11 | P2 | 参数化与位宽警告、过期接口/面积注释 | 静态质量问题，不直接认定默认功能错误 |
| F12 | P2 | 工具依赖 cwd/私有路径，历史破坏性探针与过期报告易被误用 | 维护/复现风险，文档与入口已收紧 |

## F01：LVS 仍然失败

[lvs.rep](../evidence/rpt_v51/lvs.rep) 最终状态为 `INCORRECT`，最终统计 ports 178/178、nets 12146/12255、instances 19375/19325，并列出 connectivity/property errors。历史结论中“0 SHORT”和端口数量相等不能替代全电路匹配。

上下文生成器件/单元边界归因可用于定位，但不构成验收豁免。下一步要固定同批库 GDS/CDL、全局 PG、提取与注入设置，再逐项定位剩余差异；boxing/忽略器件的对照只用于诊断。

## F02：PG 证据缺口必须单独关闭

[fc_pg.rpt](../evidence/rpt_v51/pnr/fc_pg.rpt) 报 VDD/VSS 各 3513 floating std cells，线和 via floating 数为 0；[FC log](../evidence/rpt_v51/fc_pnr.log) 同时有 `PG_BLOCKER`，流程仍继续。

检查发生在后续优化前，最终 cell 数为 3626；不能将 3513 直接解释为最终版图全部断电。抽象库 PG pin/view 是否缺失也待确认。缺少的是最终 post-route PG 闭合证据，而“没有 UPF”本身并非单电源设计错误。恢复后应先验证 PG library/model，再做最终 VDD/VSS 连通、PG DRC 和后续 IR/EM。

## F03：DRC/布线结果非零，检查范围不完整

[Calibre summary](../evidence/rpt_v51/drc_CAL.SUM) 有 421 个 RULECHECK、16 个非零项，第一列之和 **2956**、括号列之和 **3402**。两列分开保存，不推测未给出的完整数量；`BD_1/BD_2a` 各在 1000 处截断。除了边界规则，`NW_2a`、`M1_2` 等也非零，不能统称为“只缺封环”。

[FC route report](../evidence/rpt_v51/pnr/fc_check_routes.rpt) 为 0 opens、440 DRC，明确没有天线规则，tie-to-rail 两种检查均未做。FC 内部 DRC 与 Calibre 的规则/口径不同，不能求和或互相抵消。恢复时补规则和未截断报告；block/chip 不适用项用正式 waiver 和集成责任解释。

## F04：hold 与电气规则未闭合

[STA summary](../evidence/rpt_v51/sta/sta_pc_summary.txt) typical/slow/fast hold 为 **1/16/12**，WNS **−0.0320/−0.2020/−0.0538 ns**。29 是跨 corner 记录和，不是唯一端点数。异步比较器第一采样级、同步 raw 输入及输出路径需要不同的集成边界分析，不能统一套一个 hold 根因或统一松约束。

PT `*_pc_drc.rpt` typical/fast 各 65 个 max_fanout 违例，slow 为 65 fanout + 3 max_transition，transition 实际约 0.81 ns 超过 0.80 ns 预算。setup 无负 slack 仍不足以宣布时序/电气签核通过。按真实 IO min/max、CTS 和同步器策略修复，保留 OCV/RC 场景结果。

## F05：CDC/RDC 与复位覆盖不足

[SRM RTL](../evidence/rtl_baseline/srm_residue_estimator.sv) 的 Gray 来自二进制计数器的组合编码；没有源端 Gray 寄存。同步器有合理的 toggle/Gray 结构，但未见同步链属性或对应物理 max-delay/bus-skew 约束。多位二进制跃迁经组合 XOR 可能产生毛刺，需要独立 CDC 与物理约束审查，不能仅由“Gray 每次一位”注释推导安全。

正常完成与 watchdog 路径也不同：正常计数冻结，超时时 `dec_run` 不会由 housekeeping 直接停止，采样仍可能遇到变化。`cap_*` 在 WAIT→SETTLE 边沿采样，之后的 SETTLE 不会重新采样；完成 toggle 与数据同级同步不自动证明任何相位下的相对到达。

两域共用异步 `rst_n`，无各域同步释放；[输入 SDC](../evidence/sdc_baseline/sar_digi_paper_core.sdc) blanket false-path reset。[coverage](../evidence/rpt_v51/sta/sta_pc_typical_pc_coverage.rpt) 每 corner 的 recovery/removal 各 1011 项全未测、setup/hold 各 12 项未测、min pulse width 另有 1011 项未测。它们是覆盖缺口，不是 3057 个已证实违例；需要具体 untested reason 和复位/CDC 方案。

## F06/F07：复现缺件与失败判定

输入 SDC 和 PNR 导出的 SDC 在库，三个主 Tcl 只在 env 中保留 MD5；完整 DC/FC/PT 主流程、GDS merge/结果收集、SPEF、SDF、标准单元仿真模型和 Formality run 不在库。历史日志保留很多脚本内容，可以帮助还原，但不能代替工具实测过的版本化输入。六份 RTL/SDC 与锁定 MD5 匹配是一项正面证据，不能延伸为整条 flow 可复现。

[原 P&R SDC](../evidence/sdc_baseline/sar_digi_paper_core_pnr.sdc) 的 `proc try` 只打印 warning，末尾仅验证两个 clock。I/O delay、clock groups、false path、load/DRC 命令失败仍可能留下一个“有 clock 但缺其他约束”的 block。FC log 的 `PG_BLOCKER`、440 route DRC 与 `STAGE OK` 并存，同样说明命令成功没有等价于验收通过。

本轮补 [严格 SDC 候选](../constraints/sar_digi_paper_core_pnr.sdc)，不改历史基线或数值边界；所需端口缺失、命令错误即传播失败，且不覆盖 Tcl 内置 `try`。11 个 Tcl mock 场景通过，真实 FC 支持和语义仍待 M1 验证。

## F08/F09：测试与系统契约不足

[历史 A/B TB](../evidence/tb_baseline/tb_sar16_paper_core.sv) 实例化不在库的 `sar_adc_digital_top`，当前不能完整展开。其 FAIL 与 watchdog 用 `$finish`，进程退出码可能仍为成功。[功耗 TB](../evidence/tb_baseline/tb_sar16_core_pwr.sv) 用零延迟和厂商 toggle tasks 生成 SAIF，没有端到端功能验收。

旧 A/B TB 的可选 `WATCHDOG` 预算为 2 ms，而当前默认校准协议实测约 2.07 ms；恢复旧 bench 时还需核对完整测试的超时预算，不能直接用该默认值解释 DUT 超时。

新增 [standalone smoke](../tests/tb_sar16_smoke.sv) 不依赖缺失 DUT/库，不 force 内部节点，失败 `$fatal(1)`；runner 同时要求成功标记，重跑先移除自己的旧 PASS 产物。166 项通过的范围为 LUT、raw、SRM 和校准发布协议，**不是校准链数值/模拟正确性结案**。

默认固定时钟下六组正常 SRM 从任务请求至观察 done 各约 160 ns；请求过程含测试等待，不是最小延迟测量，且没有按 200 ns 连续驱动全样本链。当前也无对外 arm/ready 或 raw/residue sample ID。start/consume 同拍、held start、部分计数超时、不同相位/停钟等需补回归。shortfall 时 valid 仍为 1、LUT 仍以 N=22 查表，消费者必须识别错误。

历史 `966/981` 是 10 位 raw word，signed Q8 实际为 **−58/−43**。已在 [当前契约](interface_contract.md) 明确，不能当作正 966/981 Q8 residue。地址 0..5 的参考权重也不通过发布流发送，片外消费者需初始化。

## F10/F11：功耗、Fmax 和参数化

[DC power report](../evidence/rpt_v51/dc/power.rpt) 有未标注 primary inputs/sequential outputs，2.546 mW 基于默认活动，不作为 5 MS/s 运行或前台校准功耗签核值。需确认 SAIF/VCD 来自代表性窗口及标注覆盖率。

STA 中 `dec_clk` 的 worst setup 摘要为 0.000000，端点为 clock-gating latch；setup 详细文件仅列 slack<0 的路径。`period−slack` 的 Fmax 估算未经过时钟扫点，不作为已实测最大频率；仍需单独报告决策域 reg-to-reg、门控和脉宽裕量。

27 条默认 RTL lint 警告多为参数到窄 localparam、符号扩展/截断和验证代码的 reset 用法；默认 elaboration 成功，无新增实际算术错误结论。后续以显式 cast/独立边界向量审查清理，不能直接改变历史 RTL 再套用旧 Formality 成绩。

`CAP_NUM` 虽是 parameter，校准模块 guard 实际只接受 20；N/sigma 也锁定于硬编码 LUT。若综合定义 `SYNTHESIS`，多个 guard 会被移除，必须由配置/回归保证参数合法。顶层 guard 只在 `SIMULATION` 开启，新 runner 已显式定义该宏。`WEIGHT_EXPORT_REG` 表没有读路径会被删除，旧 readback/面积注释仅是历史版本信息。

## F12：分析工具、文档与仓库维护

很多工具依赖 cwd、硬编码相对文件或脱敏私有路径。`gds_routing.py` 找不到 UNITS 时假定 10000 DBU/µm，`v5_recheck.py` 使用过期 STA 格式及过宽 DRC 正则，不能作为当前权威 checker。新 [check_repo.py](../tools/check_repo.py) 使用明确的实际字段，缺记录报错，并分别输出 DRC 两列。

118 份 shell 中不少有清理/覆盖/重跑操作。仅修复 `v2lut_gen2.sh` 的脱敏路径引号，使 Bash 语法可解析；其余脚本仍是历史模板，语法通过不意味着可安全直接运行。Python 两份 UTF-8 BOM 是合法编码，使用 `tokenize.open` 检查，未误报成源代码损坏。

旧报告保留自我撤回，但当前摘要仍混有“重导出 tie 根”“hold 尚未写 env”等过期整改项；新 README 和契约作为当前入口，旧文档不再作为集成指导。重构设计划分也不等于本轮已证明论文原文要求片外重构。项目无 LICENSE，后续维护明确授权边界。

## 本轮交付与下一阶段

已补 README、接口契约、审计台账、恢复路线、161 文件 hash manifest、公开 checker、独立 smoke、严格 SDC 候选和 CI；LUT CLI 增加合法范围/字面量溢出检查；一份历史 probe 修复引号。原始 RTL/SDC/GDS/网表/报告字节未改。

下一阶段按 [恢复计划](backend_recovery_plan.md) 执行：M1 找回可运行主流程，M2 收紧功能与 CDC/RDC，M3 关闭 PG/LVS/DRC/hold/电气/覆盖率，M4 再做 PPA 和整机集成。不在证据尚未闭合时承诺面积下降、噪声改善或流片就绪。

工具选项/警告解释参考 [Verilator 官方手册](https://verilator.org/guide/latest/exe_verilator.html) 与 [warnings 文档](https://verilator.org/guide/latest/warnings.html)，CI 语法参考 [GitHub Actions 官方文档](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)。这些参考不替代本仓库的实测证据。
