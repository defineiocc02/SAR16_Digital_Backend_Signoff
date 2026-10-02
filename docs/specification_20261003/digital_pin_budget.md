# 数字规格与封装引脚预算（2026-10-03）

用户选择**少引脚串行数据输出 + 独立 SPI 配置**。首版建议按 **32 个逻辑封装引脚**准备：9 模拟信号、10 电源/地、13 数字信号；保留前放所需的两个外调偏置 `VB/VBC` 和三个不同共模输入。48 pin 并行方案仅作测量/调试对照。两种方案都需要新增最终 16 位片上重构；当前 RTL core 没有 SPI、serializer 或完整 ADC 输出路径。

当前 core 的 **31 组/176 位**是片内模拟—数字边界，不能换算成 176 个封装引脚。20 路非二进制冗余物理权重最终重构为 16 位输出，正是目标架构；不是截取 raw 的低 16 位。源 CDL 的176 formal和提取 SP 的178 formal差别来自显式电源端口，也不是封装数目。

本文件是静态核对与工程预算，未运行 SSH/商业 EDA。机器可读清单见 [digital_pin_budget.json](digital_pin_budget.json)，规格分级见 [digital_specs.csv](digital_specs.csv)。历史证据均记录 repo-relative 来源及 SHA256。以下编号用于完整性计数，**不是已批准的 pad/bondwire/package 排列**；若选 exposed pad，它是另一个需要明确电气连接的端子，不隐含包含在32/48计数中。

## 已核事实与目标

| 项目 | 当前证据 | 目标/缺口 |
| --- | --- | --- |
| core/工艺 | 历史数字库为 SMIC18，DC nominal operating voltage1.8V | 真实IO/ESD电压、速度、负载尚未成为保证；模拟设计须在统一工艺中重新实现 |
| `clk` | 历史10ns/100MHz约束和STA | 加入重构和接口后重新验证；历史hold/CDC/物理签核尚未闭合 |
| `dec_clk` | 历史3ns条件，SRM零延迟实验用333.3MHz | `CLK_DEC`保留bringup/test输入；不能据此承诺333MHz封装pad链。正常运行可研究内部qualified比较ready事件，但必须重新定义CDC，不能直接绑READYN |
| 完整ADC | 目标5MS/s，即每200ns一个样本 | 尚无模拟→SAR→22次SRM→重构→输出完整验证；持续吞吐不要求sample latency≤200ns |
| SRM | 默认22次；signed10 Q8；sigma参数128即0.5LSB LUT | 需固定残差、可靠prearm、qualified valid、P/N符号和最终LSB尺度；保持内部异常恢复修复 |
| SRM正常协议 | 1200样本，accepted start→done120ns；最后决策→done40.5–43.25ns | 孤立两状态/零延迟结果；未验证亚稳态、SDF、PVT、模拟保持或整机吞吐 |
| 校准 | 默认207352 clk，100MHz时2.07352ms；发布权重6..19 | 前台操作；重构消费侧必须seed低六权重。现校准无SRM残差反馈，也未证明噪声/失配条件下精度 |
| 历史数字面积 | cell0.1023001056mm²；430.520×429.340µm历史占地0.184839457mm² | 是当前部分数字块，非完整ADC/带pad die；新增重构/协议面积需另计 |
| 历史数字功耗 | DC默认活动估算2.546mW | 没有真实转换SAIF/VCD，也不含新重构/高速输出与IO；不能视为实测功耗或论文差距 |

## 32 pin 主方案：两lane源同步输出，SPI仅配置

| 逻辑编号 | 名称 | 方向 | 域 | 用途与状态 |
| ---: | --- | --- | --- | --- |
| 1 | `VIP` | 输入 | analog | 差分输入正端；输入范围和驱动阻抗待模拟验证 |
| 2 | `VIN` | 输入 | analog | 差分输入负端；不得当单端地 |
| 3 | `VREFP` | 输入 | reference | 高参考输入；名义3.3V；外部去耦与参考动态电流待定 |
| 4 | `VREFN` | 输入 | reference | 低参考输入；名义0V；独立回流/参考pin，不能仅靠数字地代替 |
| 5 | `VCM_SAMP` | 输入 | common_mode | 采样共模；名义1.65V；对应VCM_165 |
| 6 | `VCM_AZ` | 输入 | common_mode | 比较器AZ共模；名义0.9V；不与采样共模合并 |
| 7 | `VCM_AMP` | 输入 | common_mode | 放大器共模；名义1.65V；独立可测，不预设可以与VCM_SAMP短接 |
| 8 | `VB` | 输入 | bias | 既有PA/COMP_AZ偏置电压输入；外部可调；需要核定器件工作点和pad保护 |
| 9 | `VBC` | 输入 | bias | 既有PA/COMP_AZ第二偏置电压输入；外部可调；不能隐含与VB或VCM合并 |
| 10 | `AVDD18_A` | 电源/地 | analog_1v8 | 模拟1.8V供电；SMIC18具体器件/IO耐压待核 |
| 11 | `AGND_A` | 电源/地 | analog_ground | 模拟回流 |
| 12 | `AVDD33_SW` | 电源/地 | switch_3v3 | 采样/CDAC switch 3.3V供电；只能接核定厚氧/高压器件 |
| 13 | `AGND_SW` | 电源/地 | switch_ground | 开关/参考瞬态回流；片内星点/隔离待版图定义 |
| 14 | `DVDD18_CORE` | 电源/地 | digital_1v8 | 数字core1.8V供电；历史DC名义工作电压 |
| 15 | `DGND_CORE` | 电源/地 | digital_ground | 数字core回流 |
| 16 | `IOVDD` | 电源/地 | io_supply | 真实SMIC18 pad/ESD库待选；IO电压与接收端共同定义，当前不承诺1.8V/3.3V兼容或速度 |
| 17 | `IOVSS` | 电源/地 | io_ground | I/O驱动和ESD回流 |
| 18 | `AGND_AUX` | 电源/地 | analog_ground | 与AGND_A同域的辅助bond |
| 19 | `DGND_AUX` | 电源/地 | digital_ground | 与DGND_CORE同域的辅助bond |
| 20 | `CLK_SYS` | 输入 | digital_io | 100MHz housekeeping/输出控制目标；历史core约束10ns；pad速度未知 |
| 21 | `CLK_DEC` | 输入 | digital_io | bringup/test决策域clock输入；3ns为历史core/test条件，333.3MHz pad链/板级能力未核；正常运行的内部ready事件方案需重新定义CDC，不能直接绑READYN |
| 22 | `CNV` | 输入 | digital_io | 5MS/s转换请求/采样触发目标；新相位控制和请求接受协议必须实现 |
| 23 | `RST_N` | 输入 | digital_io | 低有效系统复位；需各域同步释放；不能直接别名模拟RST/RSTT相位 |
| 24 | `SPI_CS_N` | 输入 | digital_io | 仅配置/校准命令/测试选择；低有效片选 |
| 25 | `SPI_SCLK` | 输入 | digital_io | 初期调试建议<=10MHz；SPI mode/CDC待实现 |
| 26 | `SPI_MOSI` | 输入 | digital_io | 仅配置与控制写入；不承担每秒5M样本 |
| 27 | `SPI_MISO` | 输出 | digital_io | 读status/weight/debug；CS_N无效时高阻需IO pad支持 |
| 28 | `SDOUT0` | 输出 | digital_io | 24bit frame偶数位lane：0,2,...22；MSB/LSB顺序按帧协议固定 |
| 29 | `SDOUT1` | 输出 | digital_io | 24bit frame奇数位lane：1,3,...23 |
| 30 | `DCO` | 输出 | digital_io | 源同步SDR burst时钟；建议复用100MHz CLK_SYS，24bit frame需12个沿 |
| 31 | `DVALID` | 输出 | digital_io | 一拍frame-start；从该DCO沿起收12个双lane位对；不等同ADC精度valid |
| 32 | `TEST_MODE` | 输入 | digital_io | 板上默认拉低；高电平仅受控测试，结合SPI实现scan/debug访问 |

`SPI`用来写配置、启动校准、读状态/权重和选择测试，初期调试可从≤10MHz目标开始；SPI mode、CS无效时MISO高阻、寄存器映射和跨域仍要实现。它不承担全速ADC样本数据。状态经SPI/TEST读出，本方案没有独立 `STATUS_N`。

`VB/VBC`均来自当前前放/COMP_AZ实际OA pin。偏置发生器片上集成、将两个共模合并或由数字寄存器设定模拟偏置，均可作为以后省pin方向；首版没有假设这些功能已经存在。外部电源/偏置/参考端子均需要合适的模拟pad及ESD，不能把逻辑端口直接当封装pad。

参考/开关回流、模拟地、数字地和IO地的pin分开预算，并不预先决定片内或封装的最终连接拓扑；应由噪声、IR/EM、ESD和回流设计决定。32 pin减少了辅助VDD bond，仍保留辅助模拟/数字地，但该数量本身不证明供电完整性。IOVDD及CLK_DEC速度均待真实pad选择与电气核查。

### 数据带宽和帧格式

裸16bit×5MS/s已是 **80Mbps**。推荐24bit frame为16bit signed输出+4状态位+4bit序号，需 **120Mbps**；状态位可定义为sample_valid/cal_mode/overrange/srm_error。4bit序号是丢帧诊断，内部raw/residue必须另有真实持有与标签归属，不能只靠短序号证明配对正确。

两lane最低平均各60Mbps会耗尽带宽。建议复用100MHz `CLK_SYS`生成源同步SDR burst：每个DCO沿发一对位，24bit需12沿/120ns，每200ns留80ns调度余量，gross200Mbps、使用率60%。lane0顺序发送frame bit0、2…22，lane1发送bit1、3…23；DVALID标记frame start，接收端随后采集12个位对。输出数据launch与DCO capture应分相位，例如相反沿得到名义5ns半周期；pad/板级skew、setup/hold、负载和时钟门控仍需验证，100MHz输出并非现有保证。

如加CRC8形成32bit frame，需求160Mbps，两lane100MHz需16沿/160ns，仅剩40ns余量。单lane24bit至少需要120Mbps，还需要额外空闲/物理裕量；当前不建议把SPI低速读样本当等价方案。串行虽减少引脚，但DCO及数据端口开关率更高，不能据此推导输出功耗一定降低。

### 原始样本、残差与输出的分开缓冲

建议配对缓冲2 entries，每entry保留raw20+residue10+内部sample_tag8+flags4，共84bits；输出另有2×24bit frame buffer，共48bits。合计 **132 FF-equivalent bits**，以当前DFF63.2016µm²折算约 **0.008343mm² cell**；这是未映射的存储下限，未含SPI状态/配置和控制门。该费用已计入协议/输出预算，不能再次加到数字macro。serializer可使用输出buffer bank，避免无条件增加另一个24bit重复寄存器。

2entry并不证明任意异常下不溢出。现有SRM超时后旧done可被新请求错误归属的问题，必须在RTL内部修正arm/abort/epoch并验证；封装握手不能遮盖该缺陷。缺pair、stale done、SRM超时或queue overflow必须生成明确invalid/error记录，并释放/清空归属，不能静默吞样本或无限等待。

候选两路时分重构每clk读两个权重：10拍处理20项，约3拍合并/残差处理/舍入饱和，共130ns；使用新600bit weight memory与banked读口，不假设可复用当前无读口shadow。原理上35bit signed累加足以容纳20个任意signed30bit权重的±求和，但具体符号、量化与溢出界须形式/功能验证。

| 示例时间（从coherent pair ready起） | sample0 | sample1 |
| --- | --- | --- |
| pair ready | 0ns | 200ns |
| 重构 | 0–130ns | 200–330ns |
| 两lane输出 | 130–250ns | 330–450ns |

sample0的输出可与sample1重构重叠，因此该示例每200ns交付一帧，而第一帧完整交付需250ns；模拟CNV到pair ready的延迟还应另加。这只是资源/调度预算，尚未证明控制逻辑、CDC、pad时序或5MS/s整机运行。

“第13拍归一化”也不能假定任意可编程乘法都能在一拍完成。需先确定可在校准阶段建立的预归一化权重与残差坐标，或新增单独流水gain单元并更新面积/延迟；旧代码的固定÷2/右移不等同于已经实现校准权重和归一化。

## 数字面积：主候选与保守复用基线分别列出

当前cell0.1023001056mm²仍作为已核起点。推荐折叠重构新增cell **0.065–0.100mm²**，SPI/协议/双缓冲/serializer预算 **0.010–0.020mm²**；主方案合计新增 **0.075–0.120mm²，nominal0.095mm²**（0.0825重构＋0.0125协议/输出；旧展开对照沿用0.010接口典型分配）。按55%利用率和7%数字局部余量：

`digital_macro = (existing_cell + new_cell) / 0.55 × 1.07`

推荐32pin数字macro预算 **0.344929–0.432475mm²，nominal0.383838mm²**。这是未实现架构的floorplan占位，不是新综合/P&R成绩；不含pad/ESD、模拟宏、整芯片隔离及整die余量。较少pin可能减轻pad-ring压力，但不保证die变小。具体die边长由整芯片预算与真实pad/bondpitch决定，本数字预算不固定die尺寸。

旧 `sar_reconstruction.sv`展开路径的明确存储为：

| 存储项 | 位数 | 当前DFF面积折算mm² |
| --- | ---: | ---: |
| 20×30bit权重 | 600 | 0.0379209600 |
| 4×40bit partial +40bit sum +16bit output | 216 | 0.0136515456 |
| 3个valid标志 | 3 | 0.0001896048 |
| 合计 | **819** | **0.0517621104** |

三个40bit blocking temporary用于同拍缩放表达式，算法不需要另一个120bit持久bank；真实elaboration/综合才决定删减结果。819为架构存储位数，不是映射FF count；weight_ram在旧代码仅initial清零，硬件初始化/低六项seed必须补。

组合路径约有16个组内累加级+3个组间求和级，原声明宽40bit；粗参考19×40=760个full-adder-bit，以ADDFX1=69.8544µm²计约0.053089mm²，未含20项±选择、4个首项取负、写使能mux/门控、常数rounder、saturation、SRM/subtract和修复协议。高位符号延伸会优化部分逻辑，DC也可能用不同门型，故它是资源参照而非精确映射。五项组合累加链是否满足100MHz还需STA。

原展开重构新增cell预算 **0.100–0.150mm²**；加同类协议/输出0.010–0.020，保守复用基线nominal新增0.135，数字macro约 **0.461657mm²**（范围0.413020–0.529747mm²）。该基线用于比较折叠候选，不能把其未实现功能当现有完整输出，也不能把两套重构预算相加。

当前core已有600bit shadow，但它没有供重构读取的现成接口；共享必须更改读口、时序和权重发布架构，经过formal/功能/综合后才可计面积收益。本方案默认新增权重存储，且协议中的132bit buffer已经计入0.010–0.020预算。大规模FIFO、额外gain multiplier、timing-driven pipeline、level shifter和真实IO/ESD可能使范围改变，须在功能定义后替换预算。

## 48 pin 仅作并行测量对照

9模拟信号+12电源地+4 clock/CNV/reset+4SPI+16data+DCO/DVALID/TEST_MODE=48。相比32 pin，增加14个data引脚及2个辅助VDD bond；共模与外调bias、复位/时钟、SPI和测试角色不删减。

| 逻辑编号 | 名称 | 方向 | 域 | 用途与状态 |
| ---: | --- | --- | --- | --- |
| 1 | `VIP` | 输入 | analog | 差分输入正端；输入范围和驱动阻抗待模拟验证 |
| 2 | `VIN` | 输入 | analog | 差分输入负端；不得当单端地 |
| 3 | `VREFP` | 输入 | reference | 高参考输入；名义3.3V；外部去耦与参考动态电流待定 |
| 4 | `VREFN` | 输入 | reference | 低参考输入；名义0V；独立回流/参考pin，不能仅靠数字地代替 |
| 5 | `VCM_SAMP` | 输入 | common_mode | 采样共模；名义1.65V；对应VCM_165 |
| 6 | `VCM_AZ` | 输入 | common_mode | 比较器AZ共模；名义0.9V；不与采样共模合并 |
| 7 | `VCM_AMP` | 输入 | common_mode | 放大器共模；名义1.65V；独立可测，不预设可以与VCM_SAMP短接 |
| 8 | `VB` | 输入 | bias | 既有PA/COMP_AZ偏置电压输入；外部可调；需要核定器件工作点和pad保护 |
| 9 | `VBC` | 输入 | bias | 既有PA/COMP_AZ第二偏置电压输入；外部可调；不能隐含与VB或VCM合并 |
| 10 | `AVDD18_A` | 电源/地 | analog_1v8 | 模拟1.8V供电；SMIC18具体器件/IO耐压待核 |
| 11 | `AGND_A` | 电源/地 | analog_ground | 模拟回流 |
| 12 | `AVDD33_SW` | 电源/地 | switch_3v3 | 采样/CDAC switch 3.3V供电；只能接核定厚氧/高压器件 |
| 13 | `AGND_SW` | 电源/地 | switch_ground | 开关/参考瞬态回流；片内星点/隔离待版图定义 |
| 14 | `DVDD18_CORE` | 电源/地 | digital_1v8 | 数字core1.8V供电；历史DC名义工作电压 |
| 15 | `DGND_CORE` | 电源/地 | digital_ground | 数字core回流 |
| 16 | `IOVDD` | 电源/地 | io_supply | 真实SMIC18 pad/ESD库待选；IO电压与接收端共同定义，当前不承诺1.8V/3.3V兼容或速度 |
| 17 | `IOVSS` | 电源/地 | io_ground | I/O驱动和ESD回流 |
| 18 | `AVDD18_AUX` | 电源/地 | analog_1v8 | 与AVDD18_A同电源的辅助bond；位置按IR/EM/噪声确定 |
| 19 | `AGND_AUX` | 电源/地 | analog_ground | 与AGND_A同域的辅助bond |
| 20 | `DVDD18_AUX` | 电源/地 | digital_1v8 | 与DVDD18_CORE同电源的辅助bond |
| 21 | `DGND_AUX` | 电源/地 | digital_ground | 与DGND_CORE同域的辅助bond |
| 22 | `CLK_SYS` | 输入 | digital_io | 100MHz housekeeping/输出控制目标；历史core约束10ns；pad速度未知 |
| 23 | `CLK_DEC` | 输入 | digital_io | bringup/test决策域clock输入；3ns为历史core/test条件，333.3MHz pad链/板级能力未核；正常运行的内部ready事件方案需重新定义CDC，不能直接绑READYN |
| 24 | `CNV` | 输入 | digital_io | 5MS/s转换请求/采样触发目标；新相位控制和请求接受协议必须实现 |
| 25 | `RST_N` | 输入 | digital_io | 低有效系统复位；需各域同步释放；不能直接别名模拟RST/RSTT相位 |
| 26 | `SPI_CS_N` | 输入 | digital_io | 仅配置/校准命令/测试选择；低有效片选 |
| 27 | `SPI_SCLK` | 输入 | digital_io | 初期调试建议<=10MHz；SPI mode/CDC待实现 |
| 28 | `SPI_MOSI` | 输入 | digital_io | 仅配置与控制写入；不承担每秒5M样本 |
| 29 | `SPI_MISO` | 输出 | digital_io | 读status/weight/debug；CS_N无效时高阻需IO pad支持 |
| 30 | `DOUT[0]` | 输出 | digital_io | 校准重构signed16输出bit0；不是raw_bits截断 |
| 31 | `DOUT[1]` | 输出 | digital_io | 校准重构signed16输出bit1；不是raw_bits截断 |
| 32 | `DOUT[2]` | 输出 | digital_io | 校准重构signed16输出bit2；不是raw_bits截断 |
| 33 | `DOUT[3]` | 输出 | digital_io | 校准重构signed16输出bit3；不是raw_bits截断 |
| 34 | `DOUT[4]` | 输出 | digital_io | 校准重构signed16输出bit4；不是raw_bits截断 |
| 35 | `DOUT[5]` | 输出 | digital_io | 校准重构signed16输出bit5；不是raw_bits截断 |
| 36 | `DOUT[6]` | 输出 | digital_io | 校准重构signed16输出bit6；不是raw_bits截断 |
| 37 | `DOUT[7]` | 输出 | digital_io | 校准重构signed16输出bit7；不是raw_bits截断 |
| 38 | `DOUT[8]` | 输出 | digital_io | 校准重构signed16输出bit8；不是raw_bits截断 |
| 39 | `DOUT[9]` | 输出 | digital_io | 校准重构signed16输出bit9；不是raw_bits截断 |
| 40 | `DOUT[10]` | 输出 | digital_io | 校准重构signed16输出bit10；不是raw_bits截断 |
| 41 | `DOUT[11]` | 输出 | digital_io | 校准重构signed16输出bit11；不是raw_bits截断 |
| 42 | `DOUT[12]` | 输出 | digital_io | 校准重构signed16输出bit12；不是raw_bits截断 |
| 43 | `DOUT[13]` | 输出 | digital_io | 校准重构signed16输出bit13；不是raw_bits截断 |
| 44 | `DOUT[14]` | 输出 | digital_io | 校准重构signed16输出bit14；不是raw_bits截断 |
| 45 | `DOUT[15]` | 输出 | digital_io | 校准重构signed16输出bit15；不是raw_bits截断 |
| 46 | `DCO` | 输出 | digital_io | 源同步输出参考沿；目标每有效16bit样本一沿/5MHz frame |
| 47 | `DVALID` | 输出 | digital_io | 在DCO参考沿标记16bit样本有效；校准/错误帧的规则待实现 |
| 48 | `TEST_MODE` | 输入 | digital_io | 板上默认拉低；高电平仅受控测试，结合SPI实现scan/debug访问 |

并行DOUT是最终重构signed16 code，DCO目标每个有效sample提供参考沿，DVALID指示是否可接收；不是将core的raw20输出拆到封装。它同样需要重构、pairing、异常修复、IO/ESD、受控TEST_MODE以及板级setup/hold验证。测试/debug借用SPI与TEST_MODE，不假定完整scan/BIST已经存在。

## 交付检查

机器清单已核32/48编号连续、名称唯一、分类总数一致、VB/VBC分别保留、16bit与两lane分别逐pin列出；核120Mbps帧带宽、12个DCO周期、132bit缓冲和819bit资源账，及macro公式一致。源码/历史证据保持不变。后续验收重点为内部SRM归属修复、完整样本数据链、已定义归一化、真实pad/clock电气约束与新P&R/STA/CDC/RDC/DRC/LVS，而非仅pin名称对应。
