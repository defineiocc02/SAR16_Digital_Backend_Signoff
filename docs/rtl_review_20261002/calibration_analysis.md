# 校准 RTL 深度复核：功能、算法、定点与综合边界

日期：2026-10-02。复核对象：`evidence/rtl_baseline/sar_calib_ctrl_serial.sv` 全部 774 行；并抽查顶层、公开/历史 testbench、mapped PNR netlist 与 DC timing。此文未改原始 RTL，未运行商业 EDA；本轮已执行新增端口行为测试，并核对源码与运行日志。

**结论：默认参数下，状态机、两相采样、串行求和、平均与写回的数据依赖是自洽的；不能由此认定校准精度复现 JSSC。** 主要缺口是未接入 SRM 的残差修正、模拟 DAC/比较器极性与 settling 契约未联合验证，以及将半 LSB 修正、64 个搜索结果和端码标记解释为过强的精度/范围保证。默认参数未见静态证据证明有必然溢出；参数护栏并非完整范围证明。

证据等级：**代码事实**＝直接由当前源码/工件读出；**历史报告事实**＝已有商业工具报告所述、非本轮重跑；**B：新增行为仿真**＝已执行的两状态、零延迟 RTL 与指定端口模型下的结果，不是晶体管/硅片测量；**数学推断**＝在明确假设下的计算；**模拟契约待核对**＝需要实际电路/行为模型联合验证。

## 1. 逐状态的数据流与执行计数

以下 `C=COMP_WAIT_CYC`、`L=AVG_LOOPS`、`N=CAP_NUM`，`n_k` 是目标 k 实际搜索的位数。每个表项按“当前状态在一个上升沿执行的数据动作”计数，转移条件使用该沿前的寄存器值，数据更新是 nonblocking。

| 状态 | 每目标/每搜索的执行周期 | 数据动作与下一状态 | 证据 |
|---|---:|---|---|
| `S_IDLE` | 等待 | 每沿清 `done/mode/overrange`、重置 target 为首目标；采样到 start 后进入 INIT | `evidence/rtl_baseline/sar_calib_ctrl_serial.sv:453`、`:533` |
| `S_INIT_TARGET` | 每目标 1 | `accumulator=ROUND_K`、avg_cnt=0、target overrange=0；不重置目标号/整轮 flags | 同文件 `:454`、`:547` |
| `S_PHASE_P_SETUP` | 每 P 搜索 1 | 清 SAR code、设置首搜索位/等待计数；驱动 P 为目标，N 为带保护的搜索码 | 同文件 `:574`、`:749` |
| `S_PHASE_P_SAR` | 每 P 搜索 `n_k(C+1)` | 每位第一沿试置 1，等待计数下降到 0，在下一判决沿按同步 comparator 保留/清位；到 bit0 后清 calc_cnt/temp_acc | 同文件 `:457`、`:585` |
| `S_PHASE_P_CALC` | 每 P 搜索 `N+1` | calc_cnt=0..N−1，每周期最多累加一个已知权重；calc_cnt=N 的末周期捕获恢复后的 P 估计并 OR 端码状态 | 同文件 `:459`、`:607` |
| `S_PHASE_N_SETUP/SAR/CALC` | 与 P 相同 | 交换目标/搜索的 DAC 两侧，N 的 comparator 保留极性反转；末周期捕获正值 N 估计 | 同文件 `:462`、`:574`、`:593`、`:619`、`:756` |
| `S_ACCUMULATE` | 每 P/N 对 1 | 加 `meas_val_p+meas_val_n`；用 old avg_cnt==L−1 决定结束，否则回 P_SETUP | 同文件 `:468`、`:623` |
| `S_UPDATE_ROUND` | 每目标 1 | 捕获完成的 accumulator、目标号、target overrange | 同文件 `:633` |
| `S_UPDATE_FINAL` | 每目标 1 | 捕获算术右移后的值 | 同文件 `:639` |
| `S_UPDATE_WEIGHT` | 每目标 1 | 同沿发布 addr/data/en、更新 shadow、更新位级/整轮 overrange；最后一位产生 done pulse，否则目标+1 | 同文件 `:477`、`:644` |
| `S_DONE` | 等待 | 保持 done、mode=0、最后 addr/data 与 shadow；采样到 start 则重置 target/整轮 flags 并进入 INIT | 同文件 `:481`、`:665` |

**代码事实：**默认 `n_k=k`（k=6..17）；目标 18/19 强制保护位、只搜索 b16..b0，故二者 `n_k=17`，不是 18/19。来源：同文件 `:151`、`:578`。

**数学推断：**每目标处理周期为

`T_k = 1 + L { 2 [ 1 + (C+1)n_k + (N+1) ] + 1 } + 3`。

默认 N=20、C=16、L=32、目标 6..19，`Σn_k=172`，总处理周期 `ΣT_k=207352`，即 100 MHz 下 2.07352 ms。该数是 INIT 到末目标 UPDATE_WEIGHT 的状态动作总数；不同 testbench 的 start/negedge/轮询计数基准可相差几个观察周期，不能把观察循环下标当作统一接受启动延迟。源码 `:209`/`:731` 的 207352 与此式一致。第一目标 AVG=1 的处理周期为 253 个 clk，适合端口数值实验。

关键 nonblocking 依赖没有发现 off-by-one：最后 SAR 位在进入 CALC 的沿更新，首 CALC 沿晚一周期；calc_cnt=19 的加法完成后，在 calc_cnt=20 捕获；N 最后捕获后下一沿 ACCUMULATE 才使用它；最后 ACCUMULATE 完成后下一沿 ROUND 才捕获总和。证据：同文件 `:597`–`:625`、`:633`。

## 2. P/N 比较极性、保护权重与 offset 抵消

### 2.1 必须先定义真实模拟接口

历史 testbench 明确定义 `comp_out = [ Σ_i (dac_p_force_i−dac_n_force_i) W_i + V_os > 0 ]`，见 `evidence/tb_baseline/tb_sar16_paper_core.sv:64`、`:87`–`:98`；公开 smoke 使用同样的正负加法，见 `tests/tb_sar16_smoke.sv:34`–`:43`。**这是 testbench 的模拟契约，不是 bit1 在真实开关网络中产生该电压方向的晶体管级证明。** 需要核对真实 bottom/top-plate 切换、比较器输出是否反相、AZ 时序及 offset 归一单位。

令 `P_k` 为当前目标被强制加在参考侧的物理保护权重之和：k≤17 时 0；k=18 时 W17；k=19 时 W18+W17。有效待测差为 `T_k=W_k−P_k`。搜索码 s 的物理权重为 `Q(s)=Σ s_i W_i`。

在上述 comparator 契约下，P 方向输入差为 `T_k−Q(s)+V_os`，代码保留试置位当 comp=1，即搜索值严格小于 `T_k+V_os`。N 方向输入差为 `Q(s)−T_k+V_os`，代码保留当 comp=0，即搜索值小于或等于 `T_k−V_os`。证据：校准 RTL `:593`–`:595`、`:753`–`:758`。无噪声刚好相等时 P/N 的不等号不同，是 `>` 比较契约的直接结果。

**代码事实：**P/N 被转成两个**正值权重估计**，都通过 shadow sum 加保护恢复，不对 `meas_val_n` 取负；最终是相加而不是相减。恢复代码在同文件 `:398`–`:407`，P/N 捕获在 `:616`–`:619`，累加在 `:624`。若将旧注释的 signed `D_W−` 定义为负方向结果，`(D_W+−D_W−)/2` 可以对应当前正值的 `(m_P+m_N)/2`；不能因为代码相加就认定 offset 极性错，也不能忽略这项符号转换。

**数学推断：**若连续值测量分别是 `W_k+V_os+ε_P`、`W_k−V_os+ε_N`，且保护恢复权重正确，则求和平均抵消固定 offset。当前实际为有量化、shadow 误差与噪声的 greedy 搜索；固定 offset 仍可能改变 P/N 落入的码格，不能保证每个 offset 下结果完全相同。

**模拟契约待核对：**保护位降低了有效测量差，并非在所有情况下把电压“固定为 W17”。`W18−W17=W17`、`W19−W18−W17=W17` 需要理想二倍关系；对真实非二进制/失配权重并不恒等。搜索过程中 Q(s) 还在变化。源码头部 `:23`–`:25` 的表述只能作为名义设计解释。

### 2.2 精确的数字恢复与递归误差

令当前 shadow 值为 `ŵ_i`（有符号 Q8 整数），则每相搜索后数字值为：

`m_P/N = trunc_W [ Σ s_P/N,i · ŵ_i + ŵ_protect ]`，

其中 `ŵ_protect=0 / ŵ17 / (ŵ18+ŵ17)`，`trunc_W` 是捕获到 WEIGHT_WIDTH 位时的二补码截断。**不能用“物理 DAC 权重求和”替代该式**：物理比较依赖 W，而数字恢复依赖先前估计 ŵ。来源：校准 RTL `:610`、`:403`–`:406`、`:617`–`:619`。

每个已估权重的误差会按搜索码与保护位参加下一目标的恢复。此递归关系不能一般推出“所有权重误差恰好共享一个比例”。尤其可信参考段不被校准、仍是理想值；每个目标还单独增加半 LSB。历史 testbench 将绝对误差增长直接解释为统一增益的注释（`evidence/tb_baseline/tb_sar16_paper_core.sv:325`–`:336`）不是完整 INL/DNL 验证。必须用真实非二进制阵列、输出重构和码相关误差验证；理想二进制 20-bit 权重不是该 JSSC CDAC 的精度替代模型。

## 3. 平均、两种舍入及半 LSB 的准确含义

令 L=2^S、`H=ROUND_HALF_LSB ? REF_WEIGHT_LSB/2 : 0`，`X_k=Σ_{j=0}^{L−1}(m_P,j+m_N,j)`。忽略溢出时：

`ROUND_K=2^S + H·2^(S+1)`；

`accumulator_final = X_k + ROUND_K`；

`calc_result = floor[(X_k + 2^S)/2^(S+1)] + H`。

来源：校准 RTL `:144`、`:165`–`:167`、`:214`–`:216`、`:569`、`:624`、`:740`。默认 S=5、H=128，ROUND_K=8224；右移 6 位，分母是 64。`REF_WEIGHT_LSB=256` 表示 1 个 DAC LSB 的 Q8 数值，H=128 是 **0.5 DAC LSB**；加 32 后除 64 的平均舍入是 **0.5 Q8 数值单位**，二者相差 256 倍，不能混称。

**代码事实：**`ROUND_HALF_LSB=0` 只取消 H，`2^S` 的平均舍入仍在。平均是 nearest、恰好半整数时向正无穷取整；对负值不是所有语言中常见的 ties-away-from-zero 或 ties-to-even。`>>>` 的有符号 floor 语义由 signed accumulator/avg register 保持。来源同上及 `:343`、`:357`。

**数学推断：**折叠常量与末端加法的恒等式在不溢出且单位/符号一致时成立。源码内 131072 个值的 fold guard（`:265`–`:288`）验证窄范围代数一致性，不能替代完整 reachable range 证明或含真实 DAC 的精度验证。

### 3.1 头部“精确 −0.5 LSB”并不成立

源码 `:63` 从 `m W0 ≤ W_k < (m+1) W0` 写出 `E[mW0]=W_k−W0/2`，`:65` 更称每位“exactly half”。前者需要目标小数相位/噪声 dither 的量化误差近似均匀；对固定无噪声目标，误差是目标在格内的位置，不是必然 −0.5。加 H 是格中心估计，也不是每个样本都精确还原或在 analog 阈值处重新做了 nearest 搜索。

**B：新增行为仿真已执行并通过。** `tests/tb_rtl_review.sv:175`–`:181` 的七个 first-target case 与 [冻结日志](review_run.log) 中七条 `CAL_QUANT_REPRO` 一致，并出现总完成标记。范围严格为每例的**第一个 `w_wr_en`、地址6**（testbench `:38`–`:42`）；可信 b0..5 为理想 1/2/4/8/16/32 LSB0，comp 采用上述严格 `>`，无噪声、无cell delay，两状态。模型对高位b7..19不赋权重，在首写回后即reset结束，**不代表完整真实CDAC、完整校准表或ADC精度**。c0..c3/c5确认本表前五行输出；P/N码值仍由数学式推导，没有force或内部采样。c4确认L=1时输出8576 Q8（33.50 LSB0），与c2的L=32相同；c6关闭H时输出8448 Q8（33.00 LSB0）。本表Vos=−0.5的第六行仍为未执行的数学预测。

| W6 / LSB0 | Vos / LSB0 | P 搜索预测值 | N 搜索预测值 | 启用 H 后输出 / LSB0 | 相对模型目标的误差 / LSB0 | 输出证据 |
|---:|---:|---:|---:|---:|---:|---|
| 33.00 | 0 | 32 | 33 | 33.00 | 0 | B，c0：8448 Q8 |
| 33.05 | 0 | 33 | 33 | 33.50 | +0.45 | B，c1：8576 Q8 |
| 33.53 | 0 | 33 | 33 | 33.50 | −0.03 | B，c2：8576 Q8 |
| 33.99 | 0 | 33 | 33 | 33.50 | −0.49 | B，c3：8576 Q8 |
| 33.53 | +0.50 | 34 | 33 | 34.00 | +0.47 | B，c5：8704 Q8 |
| 33.53 | −0.50 | 33 | 34 | 34.00 | +0.47 | 数学预测，未运行 |

这里 P=`ceil(W6+Vos)−1`、N=`floor(W6−Vos)`。固定无噪声时把 L 从 1 改为 32 只是重复同一码，表中偏差保持。含失配的高位参考 DAC 不再是单一均匀格，半 LSB 的统计依据还需联合模型验证。应将头部注释改成“在相应统计条件下补偿平均量化偏差的中心估计”，保留误差/条件，而不是承诺每位精确纠偏。

### 3.2 “32 P/N = 64 平均”成立在哪个层次

**代码事实：**每目标恰好执行 L 次 P 搜索和 L 次 N 搜索，除以 2L；默认确实是 64 个正值测量结果的平均。计数在 `:161`、`:468`、`:624`–`:625`。

**数学推断：**若这 64 个结果是独立同方差、已无系统偏差的权重估计，平均的标准差才是单次 σ/√64=σ/8。若每对 P/N 相关系数为 ρ，跨对独立且各相方差 σ²，则方差是 `σ²(1+ρ)/(2L)`；跨对相关、量化锁定、AZ 采样相关噪声及 shared shadow 误差均会改变收益。实际搜索是多位判决的非线性函数，不等同 64 个直接连续值测量。

**论文原文事实：**JSSC 2025 III-E（印刷页 821）明确校准期间启用 SS 与 SRM、采 common-mode，并将 averaging 的加速归因于降低 ADC 噪声；IV 的 64 次 averaging/约94 dB 是用所得权重重构 **1 kHz 满幅、1 MS/s** 输入的测量。它没有在该段把“64 次平均”定义成此 RTL 的 32 个 P/N 对，也没有给出此 RTL 的独立噪声统计证明。不得将数字 64 的相同当作算法和精度相同。来源：[论文 DOI](https://doi.org/10.1109/JSSC.2025.3526595)；已核对原文印刷页 821，原文文件及提取文本不发布。

## 4. 定点位宽、溢出与参数限制

默认 W=30、S=5：temp_acc/compensated_meas 为 36 位，meas_P/N 为 30 位，accumulator/avg register 为 37 位，calc_result 为 32 位，最终写回为 30 位。来源：校准 RTL `:145`、`:341`–`:358`、`:378`、`:617`–`:619`、`:646`。

**代码事实：**上述求和操作数均声明为 signed，宽目标与较窄 signed 数据的相加正常扩展；没有发现该默认表达式因为一个 unsigned operand 必然失去符号。物理已知权重单个为30位，temp_acc 的额外6位能容纳最多20项的最坏 signed 线性求和。每相捕获时却只保留低30位；若宽 sum/保护恢复超出该范围，会无饱和地二补码回绕。最终 32位 calc_result 写回低30位也没有显式溢出比较。

**数学推断：**以每相已有30位 signed 截断值为边界，64个值的最大正和为 `2^(W+S)−2L=34359738304`；加默认 ROUND_K=8224 得34359746528，仍低于37位 signed最大值68719476735。最大负和亦有充足空间。因此**默认 accumulator 容器对其实际输入的算术边界有余量**；不能把这点扩展为“宽测量到30位截断不会出错”或“最终30位输出总安全”。若均值接近30位上界，加H后32位仍为正，低30位却可回绕成负，`:768` 检查的是截断前32位结果，不能检测所有最终输出截断。

参数 guard（`:221`–`:253`）要求 CAP_NUM=20、W≥30、C≥4、L≥1且为2的幂、0≤MAX_CALIB_BIT<16、REF>0、启用H时REF为偶数。**代码事实：**guard 包在 `ifndef SYNTHESIS` 内，是 elaboration/simulation 检查，不是综合网表里的运行保护。CAP_NUM/保护结构、wire接口地址固定5位，因此不能将任意参数组合视为已 qualified。

需要补的范围证明：`REF_WEIGHT_LSB << MAX_CALIB_BIT` 必须在 signed W 位内；宽 compensated_meas 到 meas 的截断必须受真实权重/冗余范围约束；ROUND_K 必须不因 REF 的符号截断而变负；最后写回须验证符号/范围。现有 ROUND_K guard 只比较上界 `ROUND_K > 2^(ACCUM_W−2)`，不检查负值（`:252`）。例如 standalone 校准模块取 W=30、REF=2^30 时，REF为正偶数却截成0，HALF_LSB=2^29截成30位负数；正数/偶数 guard 不能拒绝此类配置。这是**参数化风险的代码推断，不是默认REF=256的已发生错误**。

顶层另有 longint 范围检查 `evidence/rtl_baseline/sar_digi_paper_core.sv:364`，但仅在 `ifdef SIMULATION` 下启用，且 standalone 模块不能依赖调用方可选 guard。不要把窄 sweep identity guard 称为已覆盖 wrap-around 的全部物理输入。

AVG=1 的计数器至少1位，AVG_LAST=0，old count在唯一一次ACCUMULATE即触发结束，未见多平均一轮；默认AVG=32在最后一次加法后5位avg_cnt回绕0，但转移已经依据old31进入finalize。非2幂L若逃过guard，除法仍采用`2^(clog2(L)+1)`，不再等于2L。来源同文件 `:144`、`:149`、`:161`、`:468`。

## 5. 过量程标记：码端点提示，不是比较器范围证明

`search_mask` 是本次可搜索位，普通目标为所有低于target位，保护目标为b0..16；全0/全1产生rail_low/high，P和N末CALC状态都OR到该目标，UPDATE时发布位级及整轮sticky标记。DETECT=0时，mask/rail逻辑被关闭。来源：校准 RTL `:425`–`:440`、`:614`、`:636`、`:653`–`:654`。

**代码事实：**此标记只观察最终码，没有执行额外阈值比较，不知道真实offset、权重误差或target超出范围的程度。合法落在首/末量化格的输入也可能得到端码；all-zero/all-one既是范围不足的信号，也可能是合法边界。源码 `:436`–`:437` 把“railed code”直接解释成offset/失配超过±W5预算过强。

**代码事实：**标记为1仍照常写回 shadow/w_wr_data，继续使用该权重递归测量下一位，并最终置done（`:646`–`:659`）。当前模式是“发布已完成的表并告知质量风险”，不是失败时回滚、拒绝更新或保留旧表。系统如果要求出错时保持上一份可信表，需要外部表commit策略或新RTL设计；overrange标记不能单独保证后续权重有效。

旧头部中的 sigma(Vos)=300µV、4σ、±1.2mV（`:83`–`:97`）来自其引用的旧学位论文段落，不能当作 JSSC 2025 III-E 已核实参数。JSSC III-E有参考LSB段3σ INL±0.39 LSB和SS/SRM降低噪声的证据，但该段未载上述300µV/1.2mV数字。须明确来源或标为待电路预算确认。

## 6. reset、重校准、异常状态和模拟等待

异步低有效reset将state设IDLE、flags/data/counts清零，低参考shadow[0..MAX]载`REF<<i`、其余shadow清零。来源：校准 RTL `:445`–`:447`、`:489`–`:525`。在reset解除后仍为IDLE，DAC两侧因phase inactive均为0（`:391`–`:396`、`:749`–`:759`）；这不直接表示真实模拟节点已经被common-mode采样/AZ处理。

重校准在DONE采样start后只重设目标号与整轮overrange；不清整个shadow表。下一轮按低到高更新，每个新目标只读已经更新的低位与保护位，所以在正常状态序列下上一轮高位不会被错误当成未校准低位。来源：`:684`–`:687` 与 `:578`–`:581`、`:403`–`:406`。该判断不涵盖非法状态/索引扰动。冷启动参考段始终被视为可信理想值，对真实LSB失配不存在闭环估计。

`start_calib`只有在IDLE或DONE被采样；忙时请求被忽略，没有队列/abort。若持续置1到DONE，会立即安排下一轮；请求者必须控制脉宽/重新发起时刻。DONE接受重启的沿仍执行DONE动作、保持done=1，下一INIT沿才清done并置mode；不能期待接受重启沿就立即done=0。来源：`:453`、`:481`、`:665`–`:688`、`:547`–`:549`。start没有内部同步链，跨域使用需调用方契约。

非法state走default回IDLE并清多数工作寄存器，保留shadow与最后addr/data；整轮overrange也要等随后IDLE沿才清。来源：`:482`、`:691`–`:711`、`:533`–`:545`。这不是故障恢复/保存已完成校准的完整安全协议；四状态/X、reset释放及门控后的reset tree需RDC/门级验证。

**重要模拟等待边界：**trial bit在wait=C的SAR沿更新，判决在C个clk之后使用old`comp_out_rr`。同步寄存器每沿更新`comp_out_r<=comp_out; comp_out_rr<=comp_out_r`，同沿判决读old rr。因此判决值来自判决沿前2个clk的comparator采样，实际analog结果须在trial后约 `(C−2)T_clk` 之前稳定并满足采样setup。默认是140ns，而状态机trial到判决相隔160ns。来源：`:527`–`:530`、`:586`–`:595`。**代码时序推断；真实settling/亚稳态待电路与CDC核对。** C≥4只给了数字等待下界，没有证明真实DAC/前放/比较器已settle。COMPARATOR输出每clk采样，即使idle也在同步；宏观校准域门控要保留可靠唤醒/重新稳定流程。

## 7. 与 JSSC SRM-assisted 校准的准确边界

**代码事实：**校准模块只有二值`comp_out`输入，没有residue/count/sigma/sample-valid接口（`:118`–`:142`）。meas的路径是SAR码→shadow串行sum→保护恢复→P/N平均（`:607`–`:625`），不包含22个重复比较的逆正态估计。顶层 `evidence/rtl_baseline/sar_digi_paper_core.sv:198`–`:222` 与 `:229`–`:253` 并列实例校准和SRM，SRM结果仅输出、没有回到校准数据通路。

因此，准确说法是“**当前仓库的校准数字模块未消费或实现SRM残差修正，顶层也未连成该闭环**”。这不表示外部模拟SS/AZ不能降低单次比较噪声，也不排除宿主在仓库外另做修正；但这些能力不能由现有模块接口和工件证明。把SRM模块的存在与校准平均数字64拼在一起，不能代表论文SRM-assisted self-calibration。

论文 III-A/III-C 说SRM在SAR码固定后保持DAC、追加22次binary比较、统计残差并从输出减去residue；III-E在校准期间启用SS/SRM。来源：JSSC印刷页818、819、821，[DOI](https://doi.org/10.1109/JSSC.2025.3526595)；原文文件与提取文本不发布。当前CALC会继续保持该方向的DAC码21个clk，但没有相应SRM arm/done/残差与测量绑定协议。新集成应定义每相结束、DAC冻结、SRM结果尺度、P/N符号修正、有限样本偏差与何时允许继续改变DAC。

## 8. mapped 工件、面积与时序抽查

**历史工件事实：**`evidence/rpt_v51/sar_digi_paper_core_pnr.v` 保留shadow[0..19]每项30个DFF，低可信段180 DFF；`:1403` 可见shadow[0][0]仍是DFF。实际avg snapshot存储bit6..35共30 DFF，calc_result存储bit0..29共30 DFF；声明的37/32位已有死位优化。例子：同网表 `:1161`、`:1163`；完整库存见 `docs/ppa_20261001/netlist_register_inventory.json`。不能按声明位宽37+32估计可以消除的寄存器面积。

**推断：**低可信段在合法FSM路径上没有写回，但动态`shadow_weights[wr_idx_r]`写口使综合保留数据存储；常量分段及结构限定写地址有优化机会，需等价/参数/reset回归后新综合，不是本轮已达到的面积收益。两级快照可评估改用稳定accumulator形成数据、保留状态和publish时序；不能因为注释说“delay-only/no logic”就认为其中60个真实DFF没有成本，或直接删寄存器不改变时序路径。

**历史报告事实：**DC typical、wire-load、ideal clocks下首setup路径从meas_val_p[1]到accumulator[35]，arrival9.63ns、slack0.00；另一长路径calc_cnt[0]到temp_acc[29]，arrival9.65ns、slack0.00；第三路径shadow[17][0]到meas_val_p[29]涉及保护恢复。来源：`evidence/rpt_v51/dc/timing_setup.rpt:16`、`:73`–`:87`、`:90`、`:147`–`:161`、`:164`–`:166`。精确报告值不能因source shift已无adder就归纳“全部算术短路径”。提频应优先看ACCUMULATE的双加与串行sum读选择/加法，不是仅finalize。

DC check_design的14个不驱动cell告警有9个在校准模块（`evidence/rpt_v51/dc/check_design.rpt:10`–`:22`）；不是功能错误证明，也不是clean lint。历史PG/hold/CDC签核仍有缺口，本轮代码审阅不关闭它们。

## 9. 本轮已完成与后续独立实验

1. **第一权重数值实验（七例已完成，见第3节与冻结日志）**：独立DUT，用端口驱动comparator模型；可信6LSBs为理想binary、b6用上表4种非整数权重，较高位只给合法占位值。在第一次`w_wr_en && addr==6`接受数据并结束，各实例不force内部状态。比较AVG=1/32、ROUND=0/1、Vos=0/±0.5。实验只证明数字控制/算术在该契约下的输出及偏差，不能宣称完整真实CDAC或16bit精度。
2. **同步等待实验**：同样首目标，comparator模型在DAC码变化后延迟更新；扫描接近140ns、150ns的模型延迟，核对稳定截止时间和结果。延迟输出模型要定义惯性/transport与每次DAC改变的取消规则，不能把模拟事件调度竞争当作物理settling结论。
3. **端码实验**：设首目标恰好位于0/63参考端码或略超范围，观察overrange、写回与done，明确合法端格也可能flag、flag不会阻止发布。该模型只验告警语义。
4. **参数拒绝实验**：单独elaborate AVG=3、COMP_WAIT=3、REF奇数且H=1，以及范围过大的正偶数REF；记录哪些现有guard能拒绝、哪些只在结果阶段报错。不要将运行正面测试或fold guard当作参数全覆盖。

优先修改的是过强的注释、接口契约与数值验收；SRM闭环、真实LSB失配和存储结构优化属于后续有明确等价/混合信号验收条件的RTL变更。
