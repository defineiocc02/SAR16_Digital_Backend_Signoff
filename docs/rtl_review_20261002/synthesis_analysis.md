# RTL 功能与映射电路复核（2026-10-02）

本报告复核 v5.1 的四份实际 RTL、DC 报告、交付 PNR 网表和 LEF。没有启动 DC/FC/PT，也没有修改 RTL。资源数字来自递归展开的历史 PNR 网表及 LEF `SIZE`，不是重新综合结果。论文系统原理、校准精度和 CDC 的独立复核需与本报告合并阅读。

可复现入口：[库存工具](../../tools/inventory_synthesis.py)。在仓库根目录执行 `python3 tools/inventory_synthesis.py`，汇总和逐 cell JSON 写入 `build/rtl_review/`；可显式指定 `--repo <repo> --output-dir <output>`。本目录冻结汇总 JSON，不提交约 1 MB 的逐 cell 清单。脚本只用 Python 标准库，输入 SHA-256 写入 JSON。行号均指 `evidence/rtl_baseline` 中的原始源码。

## 1. 资源账与分类边界

展开顶层 `sar_digi_paper_core` 的所有已定义子模块，剩下的每个实例都必须在交付 LEF 中有 `MACRO` 和 `SIZE`。总计 **3626 个 leaf cell、102300.1056 µm²**，与 `evidence/rpt_v51/pnr/fc_area.rpt` 的 3626 / 102300.11 精确对账（面积报告显示两位小数）。这同时验证了 1011 DFF + 40 latch = 1051 sequential，以及 195 BUF + 326 INV = 521 buf/inv。

| PNR 层级 | leaf cell | DFF | 门控 latch | 几何面积 µm² | 占全块面积 |
|---|---:|---:|---:|---:|---:|
| `u_calib_ctrl` | 3170 | 904 | 35 | 90777.4560 | 88.736% |
| `u_srm_residue`（含 LUT） | 283 | 86 | 5 | 8216.2080 | 8.031% |
| 顶层直接实例 | 173 | 21 | 0 | 3306.4416 | 3.232% |
| 合计 | 3626 | 1011 | 40 | 102300.1056 | 100% |

此前“校准约占 90%”来自 DC 层级面积（88106.3564 / 97892.625106），仍成立于该报告；PNR 层级值应单独列为 88.736%，不能混用两个阶段的分子分母。顶层直接实例含 I/O、reset 和时钟 buffer，不能都叫“顶层运算逻辑”。

| leaf cell 类别 | 数量 | 面积 µm² | 统计依据 |
|---|---:|---:|---|
| DFF | 1011 | 64019.8944 | `DFF*` 且实例有 `D/CK` |
| latch | 40 | 1463.6160 | `TLAT*` 且有 `D/GN/Q`；全部属于生成的门控模块 |
| buffer | 195 | 2967.1488 | `BUF*/CLKBUF*` 且有 `A/Y` |
| inverter | 326 | 2913.9264 | `INV*/CLKINV*` 且有 `A/Y` |
| adder primitive | 18 | 1274.0112 | `ADDF*/ADDH*` 且有 `A/B/CO/S` |
| mux primitive | 8 | 189.6048 | `MX2/MX4/MXI2/MXI4*` 且有 `S0` |
| 其他组合 cell | 2028 | 29471.9040 | NAND/NOR/AOI/OAI/XOR/AND/OR 等 |

这些类别是**库原语资源数**。18 个 adder primitive 不等于“仅 18 个加法位”；8 个 mux cell 不等于“8 个 RTL mux”。大部分算术、宽读 mux、比较器和 decoder 已分解为基本门，必须看 RTL 数据流或做 Boolean cone 分析才能细分。在已映射网表里没有单独的 `CMP` 宏；本报告不虚构精确 comparator/decoder 数量。LEF 面积不提供输入电容、传播延迟或动态功耗，因此 pin load 数不能直接换算为 mW。

## 2. 四个模块真正做了什么

### 顶层 `sar_digi_paper_core.sv`

- 198–222 行实例化校准器，229–251 行实例化独立 SRM；两者之间没有残差反馈连接。
- 279–287 行是 20 位 raw code + 1 位 valid 的每周期输出寄存器，PNR 为 21 DFF / 1327.2336 µm²。`raw_code_o` 每个 `clk` 都更新，不以 `data_valid_i` 为 enable；consumer 必须按延迟一周期的 valid 取样。这里没有 sample ID、FIFO 或 raw/residue 配对队列。
- 253 行导出 10 位 SRM 残差，155–157 行导出 `w_wr_*` 校准结果。
- 实际源码没有常规转换 SAR sequencer、20 路加权重构树、归一化除法器或乘法器。文件头 13–15 行描述的是另一个历史整合模块的代价，不能算到当前四文件核心。
- `WEIGHT_EXPORT_REG=0` 仅表示**没有额外的导出/readback 权重表**；它不表示“整个芯片没有权重存储”，因为校准器内部仍有 600 个 shadow DFF。
- 318–338 行 `WEIGHT_EXPORT_REG=1` 分支只有写入 `weight_tab`，没有读口、输出或其他观察者。正常优化应删除这张表。旧的“额外 39248 µm² / 24%”来自具有 readback 的历史版本，不能作为当前参数切换的新综合增量。

### 校准器 `sar_calib_ctrl_serial.sv`

其硬件是：13 状态控制器、20 位 SAR 试探码、索引/等待/平均计数器、比较器两级同步、权重 DFF 表和组合读选择、串行加法数据通路、两相 MSB 保护补偿、平均累加及三拍发布接口。

- 默认参数在 105–117 行：20 个物理权重、30 位 signed Q8、每个比较步等待 16 个 housekeeping clock、32 组 P/N 测量，目标位 6–19。
- 574–605 行先试探 `sar_code[sar_ptr]`，随后在等待结束采 `comp_out_rr`，P/N 采用相反保留极性。动态 bit-select 会综合成位置 decoder 和更新选择网络，并不是一个 20 路常规转换 SAR 引擎。
- 607–620 行逐地址扫描 20 个权重，若码位为 1 就执行 `temp_acc + shadow_weights[calc_cnt]`；一个宽读选择网络配合串行加法器，重复占用时钟。固定 20 次扫描没有按照当前目标减少扫描长度，功能安全，但低目标位的大部分周期在检查零码位。
- 400–408 行对最高两位恢复搜索时强制置位的 `W17/W18`，可推导为两级条件加法与选择；对应 protected SAR 搜索仅到 bit16。它是补偿电路，不是乘法。
- 623–625 行执行 `accumulator + meas_val_p + meas_val_n`，给综合器的是三操作数加法表达式。实际映射可以形成多个加法段和长进位链；仅“串行架构”这个名称不保证每拍数据路径很短。
- 214–216、569、735–744 行把平均的常量 round bias 预置为 `ROUND_K=8224`；末尾 `>>>6` 是恒定 wiring shift，不需要通用除法器。此重写已避免历史 finalize incrementer，当前 critical path 转移到累加及串行读取计算。
- 518–525 行异步 reset 所有 shadow 条目；650 行按动态 `wr_idx_r` 写表。注释称“RAM”，实际交付为 600 DFF，没有 SRAM macro/blackbox。全表异步 reset 和单拍组合读取都不适合直接推断传统 SRAM。
- 633–663 行三拍 snapshot/shift/write 保持旧协议；60 个实际映射的数据快照 DFF 仍占 3822.0336 µm²，不是“没有门所以没有面积”。

校准本身只读二值比较结果，没有读取 SRM fractional residue。是否达到论文校准精度必须由原理和数值模型另行证明；分组平均、二相 offset 消除和 round bias 的存在不能替代该证据。

### `srm_residue_estimator.sv`

- 307–324 行用 toggle + 三个 decision-domain DFF 传递启动；15 个 decision-domain DFF 是 `dec_ones` 5、`dec_total` 5、run/done toggle 各 1 和 go sync 3。
- 345–368 行用两个 5 位二进制 counter 统计有效比较，达到 22 后冻结并翻转完成 toggle。每个 decision_valid 周期做 5 位 increment、目标相等判断与控制更新。
- 376–395 行组合 binary-to-gray、20 个 gray word sync DFF 加 2 个 done sync DFF；230–252 行 gray-to-binary 为固定 XOR 网络。组合 Gray 跨域的安全性仍需 CDC 约束和注册/稳定窗口复核，源码注释“不会撕裂”不等于 CDC 签核。
- 401–455 行 6 状态 housekeeping FSM；421–427 行 7 位 watchdog（默认 64），不是历史 32 位计数器。
- 486–491 行捕获计数，536–554 行下一阶段查组合 LUT、发布状态和 10 位 residue。全部 housekeeping 资源共 71 DFF；加上 decision-domain 15，总计与网表 86 DFF 完全一致。
- 86 个 DFF 可分为：decision/start 16、gray/done sync 22、FSM 3、capture 11、watchdog/pending/ref 9、发布输出 25。此分组按语义归属，实际 start toggle 在 `clk` 域，不应把整个 “decision/start 16” 都算到 `dec_clk`。
- 64-cycle timeout 是 housekeeping 等待预算，不是“64 个比较周期”；默认时钟下异常完成时间超过 5 MS/s 的 200 ns 周期，系统必须定义异常样本丢弃/重同步方式。

### `srm_residue_lut.sv`

- 125–143 行 12 个常量 case，157–160 行 `k > 11`、`22-k`、符号恢复；这些综合为门网络，不是 12×16 存储位的 SRAM/ROM macro。
- 默认 `SIGMA_Q8=128 / FRAC_OUT=8 / OUT_WIDTH=10 / HALF_TABLE=1`，当前最大输出绝对值 258 Q8。旧注释 42 行仍写 “6-bit 默认”，其当前参数实际是 10 位；文件头/历史 sweep 数字需与具体 build 分开。
- DC LUT 面积 831.6 µm²；交付 PNR LUT 为 **64 cell / 848.232 µm²**，包含 10 inverter、4 mux primitive、50 其他组合 cell。占全块 PNR 0.829%。因此它不应排在大权重表之前作为面积优化重点。
- 160 行在恢复负号之后执行 arithmetic right shift。默认 SHIFT=0 没有问题；若降低 FRAC_OUT，向负无穷截断会破坏输出奇对称，例如 ±14 Q8 / 16 → +0 / -1。213–215 行对称 guard 只检查原始表，不检查缩位后的输出。旧注释把量化影响简单写成 `step/sqrt(12)` 不能证明无偏；任何缩位优化都需要成对舍入、偏置和 MSE 验证。

## 3. 实际寄存器与宽度优化已经做了多少

| 数据寄存器 | RTL 默认声明宽度 | PNR DFF | PNR 保留位 | 面积 µm² |
|---|---:|---:|---|---:|
| `shadow_weights` | 20×30 | 600 | 每地址 0–29 | 37920.9600 |
| `accumulator` | 37 | 36 | 0–35 | 2275.2576 |
| `temp_acc` | 36 | 30 | 0–29 | 1896.0480 |
| `meas_val_p/n` | 30 各 | 30 各 | 0–29 | 1896.0480 各 |
| `avg_rounded_r` | 37 | 30 | 6–35 | 1896.0480 |
| `calc_result_r` | 32 | 30 | 0–29 | 1925.9856 |
| `w_wr_data` | 30 | 30 | 0–29 | 1896.0480 |
| `raw_code_o` | 20 | 20 | 0–19 | 1264.0320 |

因此不能按所有声明位宽相加估算真实 DFF：综合已去除 snapshot 中被右移丢弃的 6 位、截断结果的上方位和部分符号冗余。`temp_acc` 高 6 位被删源于最终低 30 位观察链，不是已经证明了所有校准幅值都适合 30 位；实际数值范围仍需检查。

## 4. 固定参考段：180 DFF 的证据、实际信息量和收益边界

有效 reset 与正常 FSM 地址序列下，只对目标位 6–19 校准；`shadow_weights[0..5] = 256 << i` 永不变化。每个常量只有一个 1，六个条目总计 **6 个非零常量位 + 174 个零常量位，可变信息位为 0**。实际 PNR 仍保留 **每条 30 DFF，总计 180 DFF**。这是准确的实例数，不是 181，也不能把它重新解释成“只保留 6 个 DFF 就够”。结构写成常量后，六条完全不需要状态存储。

动态数组写 `shadow_weights[wr_idx_r]` 给出了 20 个地址的通用写结构；动态通用写口使常规综合难以利用合法 FSM 地址范围，这是保留资源的原因推断；交付映射实际保留所有 reference 状态及 clock enable。把 reference 段改为 localparam/常量生成，writable 段限定到 6–19，是可观察的结构优化候选；新实现必须先证明 reset 后全部合法启动、重启、状态和写序列与 baseline 等价，不能随意掩盖非法写或改变 debug/四状态语义。

明确的毛预算：

`A_reference_DFF = 180 × 63.2016 = 11376.288 µm²`

`A_reference_DFF / A_all_PNR = 11.1205%`

六个参考条目的独立 clock gate 共有 14 leaf cell / 332.6400 µm²；四个条目的 gate→DFF 时钟树另有 4 buffer / 119.7504 µm²。每个 gate 在追踪 BUF/INV 后恰好驱动 30 个该条目的 DFF。它们说明还有门控/时钟 load 的潜在增量，不能据此承诺重放后净面积。

还可能减少宽读 mux 的常量分支、6 个地址的写 decoder、reset 负载以及平均结果总线 fanout，但没有做 Boolean cone 等价提取，不能编造各自独立面积，也不能重复把已包含在 14 个 gate leaf 中的 buffer 再计一次。其他共享 reset/clock buffer 是否可删要重做物理实现。

三拍中两级数据 snapshot 的 60 个 DFF 毛面积是 3822.0336 µm² / 3.7361%。与固定 reference DFF 相加为 15198.3216 µm² / **14.8566%**。这只是所选寄存器的毛资源预算：对这些已定位实例，可去除的贡献最多等于它们原面积；对**整个优化后的电路**，14.8566% 既不是保证下界也不是严谨上界，因为 read mux 会变小，新时序修复、buffer、SRM-assisted calibration 与配对逻辑又会增加面积。删 snapshot 还会直接增加 accumulator→write decoder/reset gate 的 fanout/路径压力，不能只以“末尾是 wiring shift”为依据直接实施。

## 5. 可写段的范围候选（需形式验证后才改）

在默认参数、有效 reset、合法地址序列下，搜索只选择低于目标的非负权重；最高两位的保护补偿仍只把更低权重恢复一次。每个 P/N 测量上界为低位权重的总和，两相每次累加并做 64 个测量平均；半 LSB 项的贡献为 128 Q8；最大值预算为 `floor((64×M+8224)/64)=M+128`，普通输入还含 32/64 的平均舍入。因此有候选归纳式：

`Wmax(k) = Σ Wmax(j<k) + 128,  k=6..19`

参考段和为 `256×(2^6−1)=16128`，从而 `Wmax(k)=254×2^k`。最高位的数字算法上界是 133169152 Q8，低于 `2^27`。这个上界不假设 comparator 读数正确，只需要搜索/地址控制合法、保护项不重复和所有低位满足已归纳范围。

若保留 signed 类型，每个可写条目需要 `k+9` 位（15..28），14 个条目合计 **301 位**，而当前一律 30 位共有 420 DFF；另有 **119 DFF / 7520.9904 µm²** 的宽度毛预算。进一步证明非负并在读取时常量补零，理论变量位可降为 14..27 / 合计 287。它们是设计空间候选，不是新的综合结果，也不能未经证明加到已列 “14.86%” 毛预算里。

实施前需要检查：所有复位/重启、完整目标序列、P/N 补偿、平均累加与截断溢出、外部参数覆盖、非法状态/SEU 的契约、非默认参数及输出固定点接口。建议先对默认参数做顺序形式证明，再分别综合 180-DFF reference 常量化与可写宽度方案。当前 `WEIGHT_WIDTH>=30` guard 是模块固定协议约束；内部异宽存储方案不应直接通过把外部参数改为 28 来绕过它。

## 6. 长进位路径和时钟频率判断

`evidence/rpt_v51/dc/timing_setup.rpt` 使用 typical 库、wire-load model、ideal clock，是综合阶段时序，不能当成完整带寄生 signoff：

| DC 路径（报告起始行） | arrival ns | slack ns（报告精度） | 路径上的 ADDF CO 点 | 源码对应 |
|---|---:|---:|---:|---|
| `meas_val_p[1] → accumulator[35]`（16） | 9.63 | 0.00 | 28 | 624 行三操作数累加 |
| `calc_cnt[0] → temp_acc[29]`（90） | 9.65 | 0.00 | 27 | 609–611 行索引、read mux、加法 |
| `shadow_weights[17][0] → meas_val_p[29]`（164） | 9.62 | 0.00 | 2 | 403–406 行 MSB 保护补偿及捕获 |

第三条 ADDF 数少不表示逻辑短：综合器可分解成 AOI/OAI/XOR 长路径。DC 和 PNR 映射不同，DC 路径上的 28/27 个进位节点不能同 PNR 库原语统计 18 相矛盾地解释。

100 MHz 在此阶段已是约 0 slack；没有足够依据宣称整核可工作在 200/333 MHz。真正的 `dec_clk` 只管 SRM 快计数与握手，两个 domain 的要求不能互换。优先试验包括三操作数 carry-save/两拍累加、weight mux 输入或输出寄存，以及缩短可证明的内部位宽；这些会改变延迟、状态机、门控 enable 与 ADC 控制关系，必须保持模拟 settling 和协议约束。原 SDC 没有合法 multicycle 放宽，不能因为架构整体多周期就把这些每拍数据路径放宽。

## 7. 门控、复位和功耗估算

网表有 40 个 clock gate 实例：35 个校准、5 个 SRM，展开为 87 leaf / 2138.8752 µm²（40 个 TLAT latch、40 个主 AND、7 个 buffer）。这些 latch 是 clock gating 的组成部分，不是 RTL combinational always 的缺省赋值造成的意外锁存器。

沿真实 net connection 追踪 BUF/INV 和 clock gate：housekeeping `clk` 驱动 996 个 DFF，`dec_clk` 驱动 15 个 DFF。仅 root 时钟 BUF/INV 追踪面积分别为 535.5504 / 13.3056 µm²；521 个 buf/inv 中大多数属于数据、I/O、reset 等网络，不能把它们全部归为 clock tree。

1011 个 DFF 均有异步 `SN` pin。沿 `rst_n` 到 BUF/INV 的追踪树为 39 个 cell / 575.4672 µm²，最终驱动全部 1011 个 SN，分成 36 个 reset leaf net。这里的 SN cell 和 QN/反相映射可能保存逻辑补码；不能仅看 `DFFS*` 名称就推断 RTL 的 reset 值。没有 Liberty capacitance，只有 pin 数；强 fanout、reset 偏斜和 recovery/removal 需要新 physical/STA。

源码没有 ASYNC_REG 属性，reset 也没有各 domain 的同步释放；外部合同可规定同步释放，但本 RTL 不能自身保证。baseline SDC 的 `set_false_path -from rst_n` 与 asynchronous clock group 不验证 reset recovery/removal 和 CDC 正确性。clock gate 的 enable 稳定窗口也需要实测约束，不能只以 ideal clock 或现有正 slack 结束审查。

DC 的 2.546 mW 仍是默认活动/未标注输入与寄存器活动估算。现有 40 个细粒度 gate 已经在网表里；新增“停止校准时钟”不能把历史校准 1.760 mW 全部直接当作节省。需要校准、steady 5 MS/s、idle、异常四类独立 VCD/SAIF 窗口，检查 activity coverage，再用同一个 corner/library/physical scope 做 A/B。

## 8. 需要修订原分析的具体点

1. 保留 180 DFF 与 14.86% 的数量来源，但解释为所选映射寄存器毛预算，不保证优化后的净收益。
2. 把 DC 的 LUT 831.6 与 PNR 的 LUT 848.232、DC 校准 90% 与 PNR 校准 88.736% 明确分开。
3. “没有片上权重存储”改为“没有额外 export/readback 表，校准仍有 shadow 表”；`WEIGHT_EXPORT_REG=1` 的旧面积增量已不适用于当前无读口分支。
4. “末尾没有运算逻辑所以删流水无功能收益/无面积收益”要拆开：60 DFF 有面积，删后的时序/延迟风险需验收。
5. 全部所谓乘法器、除法器、重构加法树都属于其他历史模块，不属于当前四文件核心。
6. LUT 缩位后的 arithmetic shift 有负向截断偏置，旧 uniform quantization noise 注释不能充当无偏证明。
7. 可写条目异宽范围是新候选，必须证明后综合，不能承诺 119 DFF 已被删掉。
8. 当前芯片功耗和 ADC SNDR 没有形成可同比论文的测量链，原理缺口/新增闭合逻辑可能扩大数字面积与功耗，应保留该工程预算。

建议下一次商业工具恢复时，以固定输入 sha 和同一库/约束分别做 baseline、reference 常量化、内部位宽、累加/读 mux timing 四次小规模综合；每次先保证顺序等价和端口语义，再比较 DFF、总面积、关键路径、门控、activity power。routing 要另验 DRC/hold/PG/LVS，不能从本库存直接推出签核结论。
