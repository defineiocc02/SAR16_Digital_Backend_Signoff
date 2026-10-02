# SAR16 模拟规格与首版预算

2026-10-03。基准为Huang等JSSC2025，DOI10.1109/JSSC.2025.3526595，刊页813–825。交付analog_specs.csv逐项列值、单位、证据类型、来源页、条件、现状和验证。此处只做离线规格与预算，未新增商用EDA性能仿真。当前实现状态取自2026-10-02只读OA与历史RTL，不是10月3日实时ADE检查。

## 基准及原型边界

建议首版以SMIC18、16bit、5MS/s、差分6.6Vpp、低频93.7dBFS及校准后INL±.9LSB为对照目标。论文0.57mm²是active area；它不能直接用作SMIC18 die/pad或保证布局面积。论文DNL没有在正文/TableII给精确界限；本次暂建议−1<DNL<+1且无missing codes，明确属于建议而非实测论文数字。

原型先使用外部输入buffer、reference generator/driver、bias generator与clock generator。片上保留所需偏置分配、开关、level shifter、clockbuffer及模拟/数字逻辑。reference/bias外供不意味着DAC消耗的参考能量或tail的VDD电流不计：应记录进入ADC各供能端口的功率，并把外部发生器/driver额外耗电另列。只有边界匹配后，才能准确对比论文5.31mW；论文测试APx/33500和LTC6237/AD4899不应混入片上功耗。

当前OA逐bit复制40份Cs20p，而论文是差分两侧各共享一个Cs20p。800p是库存求和，不是已验输入cap。当前部分MOM同几何且由PDK网列，GUI c字段不能当实际电容量；历史cf40f的isolatedCDACtop约5.12–5.60p/侧，亦未符合论文名义1p。下面预算假定以后采用已验证的共享Cs和小CDAC，不能当作当前分布网络的通过证明。

## 输入LSB、SNDR和ENOB

若最终均匀16bit输出覆盖6.6Vpp，则outputLSB=6.6/65536=100.7080078µV。论文DACLSB约80µV是非二进制网络最小权重尺度，不能直接等同outputLSB。当前LUT的SIGMA_Q8=128即0.5 DAC LSB；若确认1DACLSB=80µV，则LUT假定sigma=40µVrms，约0.39719 outputLSB。这是假定sigma_LUT，不是测得sigma_actual。论文TableI59.1µV preampIRN在同坐标时约.73875DACLSB，但AZ静态噪声、有限BW和判决相关性存在，不能盲目用它代替decisionσ并只改一个参数。

Fig19(a)条件为5MS/s、2.136kHz、−1.45dBFS、256k点。93.7在图/正文具有full-scale归一口径，必须同时保存输入幅度和归一方法：

- FS正弦RMS=6.6/(2√2)=2.333452V。假定输入校准增益与full-scale归一成立，93.7dBFS折算总等效误差为48.1947µVrms。它包含SNDR分母中的noise/distortion等，不是论文Table I晶体管仿真IRN38µV的另一次测量。
- (93.7−1.76)/6.02=15.2724bit只能称FS等效换算。若93.7为FS归一、实际输入−1.45dBFS，则signal-relativeSNDR=92.25dB，条件ENOB=15.0316bit。不能不说明口径就说该输入ENOB15.27。
- 若93.7反而被解释为该−1.45dBFS信号本身的ratio，总误差会折算为40.7849µVrms。这说明幅度/归一语义必须保留，不能拿任一换算当已测当前ADC性能。

最终100.708µV均匀量化步长的LSB/√12为29.0719µVrms；论文TableI的23.1µV约对应80µV DACLSB。SRM后的30.9µV已经是preamp+quantization合并项，不能无条件另加23.1或29.07形成重复量化预算。

## 电路规格

| 模块 | 对照值和来源 | 解释/验收重点 |
|---|---|---|
| SS | Cs20p/侧，2个；p.815/817/818 | 不参加bitcycling；Cs长tracking与SAR/SRM重叠；验输入导纳/相关噪声 |
| CDAC | 1p名义/侧；20物理冗余位；6+4+5+5；bridge4/4/12Cu；p.817/818/821 | Cu绝对值未公开；有效权重按实际cap矩阵/寄生确定，不能按20bit二进制 |
| 参考/校准 | 低6bit参考，高14bit测量；reference MC3σINL±.39LSB；p.821 | 确认真实1:2:4:8:16:32；校准SS+SRM都启用；64平均是1kHz/1MSs收敛条件，不等于RTL32P/Nloops |
| Flash | 3comparator→2bit；threshold−1.65/0/+1.65V，Vref3.3V；Cf50f；p.817/818 | 在AZ窗口完成；需offset/noise/meta/kickback/功耗，当前VA+SV只替代功能 |
| 前放1/2 | gain10×8；tail1025/240µA；p.819 | 差模开环增益；stage2CMFB不等于差模闭环。尺寸/工作点SMIC18重新验证 |
| AZ | Caz1.3p/侧；Taz20ns；fc20MHz；p.815/819/820 | tau约8ns，2.5tau约91.8%noise-amplitude settle；.74dB penalty是noise-cancel分析，非16bit signalsettle通过 |
| SRM | 22比较，~3ns/次，hold~70ns；p.818/821 | 冻结CDAC；σΦ⁻¹(P)残差在同坐标扣除。70ns不含数字跨域发布延迟 |
| latch/clock | latchinputIRN540µVrms；clockmeasured2ps；p.815/823 | 除以80只为理想gain换算；需nearzerooverdrive/PVT/ready和总aperturejitter |

物理capCu数组已高清确认：`[1,2,4,8,16,32;2,4,8,16;2,2,4,8,16;8,8,16,32,64]`。重复电容是冗余架构，20与16位差异不是缺口。

## 可调整的内部核心功耗分配

所有数值都是内部核心设计分配，尚未仿真；内部analog+digital目标总额5.31mW，**输出pad/外接负载另算**。这个目标不保证含IO的总芯片功耗≤论文5.31mW，必须以完整normal5MS/s activity和真实analogmodel验收。校准模式持续时间/峰值/平均另列，不能拿DC默认activity或某一个tail电流代表整机。

| 模块 | 首版分配mW | 边界 |
|---|---:|---|
| preamp1 | 1.95 | 接近论文tail1.025mA×1.8V的1.845mW，仍需含全部branch |
| preamp2_CMFB | 0.65 | tail.24mA×1.8V=.432mW仅作量级，CMFB与负载全计 |
| latch | 0.15 | 含reset/evaluate动态电流 |
| SS_CDAC_switch_levelshift | 0.25 | 共享Cs目标；包含analog control levelshift，不含外部driver |
| flash_analog_clock | 0.20 | Flash真实电路及模拟时钟分配；行为模型不是功耗值 |
| local_bias_distribution | 0.20 | 原型externalbias；保留本地分配/辅助余量 |
| digital_normal_SAR_SRM_cal_reconstruction | 1.60 | normal5MS/s含SRM与reconstruction；cal mode另测peak/average |
| unallocated_margin | 0.31 | 可调整，不能用历史默认activity替代 |

内部core分配总和5.31mW，不含输出pad驱动的外接Cload。当前DC2.546mW是未活动标注的辅助数字核心估算，既没有完整normalSAR/重构/IO，也不是5MS/s真实功耗；新增权重重构功耗未知，因此digital1.6mW与margin只是有待实现和调整的目标，不能宣称已低于当前估算或论文。完整Pchip=Pcore+PIO+其他实际供能项；PIO动态按每pin的Cload·VIO²·r01估算，r01为0→1事件率，pad短路/静态另加。未选择pad/输出协议/负载前，不能承诺全芯片≤5.31mW。外供reference/bias方案后续若改为片上实现，应把真实发生器/driver开销加入并重分配；不同process、cell库和normalcontroller也会改变digital额度。论文Fig15百分比经四舍五入和为100.1%，从百分比反推不能冒充精确分项功耗。

## 可调整的噪声/误差分配

| 项目 | 目标µVrms | 证据/假设 |
|---|---:|---|
| sampling | 22.2 | 论文TableI SS sampling，参考目标 |
| preamp_quantization_after_SRM | 30.9 | 论文TableI合并项，不重复加单独quantnoise |
| reference_and_input_source | 12.0 | 建议；外部供给仍会注入ADC误差 |
| settling_distortion_calibration_residual | 15.0 | 建议；含input-dependent error，先按等效RMS分账 |
| clock_jitter | 10.0 | 建议；Fin明确，低频余量不是高频已达标 |

RSS为43.7796µVrms，对应FS等效94.5346dB；相对48.1947µV允许的quadrature余量约20.1513µV。RSS只用于互不重复且cross terms可忽略的误差分账；AZ静态误差、噪声相关性、SRM量化耦合、谐波/建立残差应由联合模型及FFT验证。不能把误差相关性的未验证假设称预算已闭合。

## 200ns首版时间账

| 相位 | 建议ns | 来源/限制 |
|---|---:|---|
| CDAC_sampling | 25 | 论文测试采用25/50ns，选25作首版预算 |
| freeze_nonoverlap_SS_transfer_preparation | 5 | 建议预留；不是论文完整数值边沿规范 |
| AZ_plus_flash | 20 | 论文Taz20ns；Flash与AZ重叠 |
| normal18_async_SAR | 60 | 论文noise model Tconv60ns，本次作为待验证目标；不是实测deadline |
| 22_SRM_hold_decisions | 70 | 论文≈70ns模拟残差hold |
| end_reset_guard | 20 | 建议余量；digital publish可流水且必须维护same-sample |

非重叠时间账总和200ns；Cs自身长tracking与后续phase重叠，不再重复相加。60ns/18≈3.333ns只是平均每decision分配，不能代替LSB/PVT/参考最大切换的真实时序。Tconv60ns原本是论文noise-model假设，不是全corner实测转换deadline；20nsguard是本次建议，实际ready/flash/clockreset边沿需对账。

建立误差暂建议输入等效≤0.25outputLSB≈25.177µV，按实际Vstep和单极近似t≥τln(Vstep/ε)检查。例如3.3Vstep、25ns可用settling时间时，τ≤约2.122ns；这只是单极例子，实际非线性开关、CDAC寄生/冗余容错与每bit窗口另验。不能用AZ的91.8%noise-settle作为16bit signal-settle指标。

Jitter-only SNR=−20log10(2πfinσt)。2ps在2.136kHz/1MHz/2.5MHz分别约151.42/98.02/90.06dB；满幅Nyquist时输入等效jittererror约73.31µVrms，因此论文低频93.7不意味着Nyquist93.7。若加强目标为Nyquist时jitter仅10µV，则总aperturejitter需≤.273ps；这是额外高频设计分配，不能称论文已有要求或当前达到。若保持论文高频性能对标，可按actualfin/amplitude重新分配。

验证依次完成：共享/分布Cs与实际MOMcap；SMIC18OP/gain/AZnoise和latchtiming；18SAR+22SRM/200ns及samplebinding；SS+SRM校准、referenceMC/INL/DNL；低高频FFT/源噪声/归一；全部供能端口normal/cal/idle功耗。当前各项均保留“未验收”状态，避免规格表变成绩效表。
