# SRM / LUT 原理、协议与 CDC 深度复核

日期：2026-10-02。完整阅读 `srm_residue_estimator.sv` 599 行、`srm_residue_lut.sv` 222 行，并核对 JSSC 2025 原文 III-C/III-D/III-E/IV。本轮新增文档与公开实验，未修改仓库 RTL，未运行商业 EDA。

**结论：默认 22 次决策、sigma=0.5 LSB、Q8 的计数/LUT路径与原始表一致，但外部协议和超时重启并不保证一次请求对应一次结果；参数化小数位也有实际尺度错误。组合 Gray 与同深度同步链尚不能证明物理 CDC 安全。** 已有 1200 个正常 SRM 样本通过只覆盖特定时钟与合法驱动。2026-10-02 新 bench 已从外部端口复现三项协议边界和两项格式风险；其中 held start 与 start/consume 冲突属于当前契约外请求，旧完成晚到则暴露默认超时恢复的归属风险。亚稳态仍未验证。

证据等级：**A** = 直接 RTL 结构或可复核数学事实；**B** = 已保存的零延迟 RTL 实验；**C** = 由 RTL 推出的确定性协议反例、待专门 bench 确认；**D** = 物理 CDC / 模拟统计条件尚未验证。C 项一旦外部端口 bench 成功重现，应升级 B，但“风险复现 PASS”不能叫设计健康通过。本报告的代码行号均指原始 `evidence/rtl_baseline/`。

## 1. SRM 要估计什么

论文 [JSSC 2025, DOI 10.1109/JSSC.2025.3526595](https://doi.org/10.1109/JSSC.2025.3526595)，III-C（印刷页819）在一个转换完成后保持残差电压不变，继续用带噪比较器进行决策。若 `decision_bit=1` 表示 `r+n>0`，其中 n 为零均值 Gaussian 噪声、RMS 为 sigma，则：

- `P(1)=Phi(r/sigma)`；正残差产生更多 1。
- `r_hat=sigma*Phi^-1(P)`，与论文式(8)的 `sqrt(2)*sigma*erfinv(2P-1)` 相同。
- 论文将残差估计从 ADC 输出中减去。当前本块只输出 residue，不执行减法；消费者必须对齐比较器极性、原始加权码极性和减号。

当前数字计数器不会决定物理极性；其直接用 1 的数目查递增表，k<11 给负值、k=11 给0、k>11给正值（estimator:355–363；LUT:128–139、175–197）。如果物理比较器 1 的极性反过来，数字估计应反号；不能仅靠正确 LUT 自证模拟连接正确。证据 A；实际极性与系统重构还需 D。

### 有限样本修正与端点

当前表使用 `p_hat=(k+0.5)/(N+1)`，N=22，见 estimator:186–195、LUT:108–123 和生成器 `tools/gen_srm_lut.py:60–69`。它也是 Beta(0.5,0.5) 先验下 Bernoulli 概率的后验均值。它把 `k/N` 向 0.5 收缩，并使端点有限；**不是论文式(8)本身规定的唯一有限样本方法，也不保证 inverse-CDF 后的估计无偏**。

默认 k=0：p=0.5/23=0.02173913，sigma*Phi^-1(p)=-1.0095431 LSB，乘256后四舍五入为-258；k=22 为+258。当前工具对 k=0 还有 `max(value,-258)`，但本默认设计点自然舍入已经是-258，clamp 实际没有再改变这个值。故准确说法是“固定表的端点为±258 Q8，生成器保留端点下限假设”，不能把默认端点一定归因于额外模拟冗余限幅（证据 A）。改变 sigma 时 clamp 的意义、单位和误差需重新定义，不能继续套用固定的-258。

原文 III-C 给出 Gaussian 模型、估计式和 LUT 484 µm² / 4.7 µW 的综合估算；未在该段规定当前表的 `(k+0.5)/(N+1)`、Q8、±258 或5位输出。RTL 注释混用了旧 thesis 章节，不足以证明这些都是 JSSC 2025 定论。

### 统计误差不能由位宽消除

按本固定表逐项精确计算 iid Binomial(22,P) 的均值/方差，sigma=0.5 LSB、无 offset：

| 真残差 r / LSB | E[r_hat] / LSB | 偏差 / LSB | STD / LSB | k=0或22的概率 |
|---:|---:|---:|---:|---:|
| -1.0 | -0.894530 | +0.105470 | 0.146079 | 0.602731 |
| -0.5 | -0.494423 | +0.005577 | 0.161714 | 0.022358 |
| 0 | 0 | 0 | 0.132967 | 0.000000477 |
| +0.5 | +0.494423 | -0.005577 | 0.161714 | 0.022358 |
| +1.0 | +0.894530 | -0.105470 | 0.146079 | 0.602731 |

这是本模型的数学枚举，证据 A，不是真实 ADC 的测量。复核方法是对 k=0..22 计算 `comb(22,k)*P**k*(1-P)**(22-k)`，用实际 Q8 表值求期望和方差。中心的渐近 STD `sigma*sqrt(pi/(2N))≈0.13360 LSB` 也给出同数量级。±1 LSB 处已有明显向中心收缩；更大的残差受到有限端点范围限制。是否可接受由真实残差分布、冗余范围和最终噪声预算决定。

如果有比较器 offset b，理想无穷样本估计的是 r+b；如果实际噪声 sigma_actual 与表中 sigma_lut 不同，远离端点时约得到 `sigma_lut/sigma_actual*(r+b)`。59.1 µVrms / 80 µV=0.73875 只有在这里的 LSB 就是该 DAC LSB 且两端噪声定义相同才成立，不能仅修改 SIGMA_Q8 就完成校准。

若每组22次决策相关，Binomial方差不成立。对 Bernoulli 决策的等相关系数 rho，`Var(mean)=P(1-P)/N * (1+(N-1)rho)`，等效独立样本数 `N_eff=N/(1+(N-1)rho)`；rho=0.2 时只有约4.23。这里 rho 指决策相关性，不可直接把模拟 Gaussian 电压的相关系数代入。共同 offset、低频噪声、AZ采样噪声或残差在窗口内漂移都可能不被重复比较消除。

论文 III-D（印刷页819–821）还分析 AZ aliasing、噪声频谱和 moving-average 上界；22次、约70ns是其具体电路的折衷，不能推广为任意相同计数器都能得到同样SNDR。论文 IV 的64次 averaging校准验证是1MS/s、1kHz满幅、校准权重重构输出条件，约94dB是该条件下的平均SNDR，不是5MS/s全频保证。

## 2. 两个时钟域的实际操作

### dec_clk 域

1. `go_tgl` 通过 `go_tgl_s1/s2/s3` 同步（estimator:304–324）。前两级做跨域采样，第三级保存上一周期值；`s2^s3` 在 dec_clk 域产生一拍 `arm_dec`。
2. 复位把 counters、run、done toggle清零；arm优先于decision，清 `dec_ones/dec_total` 并置 `dec_run=1`，**arm同拍的decision_valid不会计入**（345–355）。
3. 只有 `dec_run && decision_valid` 的posedge才算一次比较；bit为1则ones+1，每次total+1（355–366）。输入脉冲本身不是事件队列：必须覆盖dec_clk采样边沿，一拍至多计一个决策。
4. 第22次时total固定为22，ones仍按该拍bit增加，run清0，`dec_done_tgl`翻转（360–364）。此后decision_valid不再改计数，直到下次arm。正常完成不会回绕，ones≤total≤22（A）。
5. arm没有复位done toggle，只清counter；done保持历史奇偶状态，避免正常重启看到上次“高电平done”。**done toggle也不带请求序号，不会取消旧测量**。

### clk 域逐状态

状态定义401–408；next-state 442–455；输出更新498–564。

| 旧状态 | 同拍动作 / 迁移 | 外部含义 |
|---|---|---|
| S_IDLE | start使下一状态为ARM；状态输出把busy=0、stalled=0 | go_tgl在独立块按 `start&&!busy` 翻转；busy该拍仍0 |
| S_ARM | 无条件进入WAIT；清stall_cnt/done_pending，保存 `tgl_ref=tgl_s2`；清valid/公开值/counts/flags，busy=1 | ARM只占一个clk，并未等dec域ready |
| S_WAIT | 每拍stall_cnt+1；done差值置pending；done或watchdog使下一状态SETTLE，同时捕获同步Gray数据 | busy=1；没有每收到一个decision就重置watchdog |
| S_SETTLE | 下一状态LUT；busy=1 | cap_*已经在前一拍锁存，不再刷新 |
| S_LUT | 从cap_ones查表写residue，发布counts/shortfall，valid=1、done=1、busy=0；进入HOLD | done只有一拍；错误结果也发布valid |
| S_HOLD | consume优先进入IDLE并清valid；否则start进入ARM | start可覆盖未消费结果；ARM下一拍才清旧valid |

`done` 每个clk默认清0（509）；`residue_valid` 只在ARM清、LUT置、HOLD consume清（517–558）；consume在IDLE/ARM/WAIT/SETTLE/LUT均不清valid。count_shortfall在ARM清后一直保持到下一ARM；stalled在ARM/IDLE清，WAIT trip时置（A）。外部若只看valid而不看shortfall/stalled，会接收超时的错误估计。

正常start前必须处于IDLE或HOLD，脉冲恰好覆盖一个clk，且不与consume冲突；decision stream必须等dec域arm已完成。`busy=0` 本身不代表arm完成，也存在请求后busy晚一拍拉高的窗口。

## 3. Gray、freeze、done与SETTLE到底何时采样

`bin2gray=b^(b>>1)` 正确，`gray2bin=g^(g>>1)^...^(g>>4)` 也正确（226–252）。然而 `ones_g/total_g` 是由binary FF输出**组合**形成（376–380），未在dec_clk域寄存Gray。两组Gray各经过两级clk寄存器；done toggle也是两级（382–395）。

捕获条件为 `state==WAIT && (done_pending || done_now || stall_trip)`；同拍把**捕获前的** `ones_g_s2/tot_g_s2` 解码到cap_*（486–490）。SETTLE随后只等待LUT稳定，不再次捕获。因非阻塞赋值，不能把SETTLE解释为“捕获前多等一个clk”。

正常done路径的零延迟例子：

- 最后比较完成源counter和done toggle更新。
- H1：Gray同步第1级、done第1级同时采样。
- H2：两种第2级更新，done_now在NBA后变真。
- H3：WAIT捕获H2之前第2级中的值，实际上对应H1的那组采样；然后进入SETTLE。
- H4：执行SETTLE，进入LUT。
- H5：执行LUT并发布。

如果H1捕到新done、但由于实际FF/组合Gray/连线延迟仍捕到旧或毛刺Gray，H3仍会锁存这份数据，H4的额外等待不能修复cap_*。RTL中“同深度所以已经稳定至少2dec_clk+2clk”的注释（370–374）没有由本代码保证的源域稳定前提（A结构事实，D物理风险）。正常源counter仅从最后比较那个边沿开始冻结；done同一边沿就翻转，没有先冻结若干dec_clk再完成的协议。

组合Gray还有以下物理条件：

- binary计数carry同时改变多位，FF clk-to-Q不等使组合Gray暂时可能改变多位。理想数学上相邻Gray只变一位，不等于物理组合输出无毛刺（223–225、47–52的“safe by construction”过强）。
- arm会把任意旧计数直接清0，这不是Gray相邻加1；重启时存在多位跳变。
- 两个独立counter的数据与done不是一次原子握手。Gray/binary解码正确不证明ones和total来自同一时刻。
- 两级同步器降低而非消除亚稳态概率；源计数可快于目的clk，仍需源注册、同步链属性/物理邻近、max-delay/bus-skew及冻结/ack约束。当前源码未加 `ASYNC_REG` 属性。

`cap_shortfall`只检查timeout、done条件和total是否等于22；没有检查ones≤total（489–490）。simulation另有cap_ones>22报错，但在 `ifndef SYNTHESIS` 内（566–575）。因此“任意CDC错误都会被shortfall捕获”的注释不成立：total=22、ones错误但仍0..22可无错误标志；合成硬件也没有cap_ones>22的报错。

建议最小可验证方向是：明确完成前冻结数据；注册Gray或使用稳定数据握手；在完成同步后等待并在正确拍捕获数据；用请求/ack或样本序号绑定done；为冻结读出建立时序约束。哪种实现最小须结合新的CDC/STA结果决定，不能凭零延迟波形宣布完成。

## 4. Watchdog与超时重启的关键风险

默认STALL_CYCLES=64；其计数只在WAIT累加，不因进度清零（421–427、477–484）。它是**绝对WAIT期限**，不是“64拍没有进度”的检测。若合法比较流太慢，即使持续有决策也会超时。

start接受E0，E1执行ARM，E2首次执行WAIT；当旧stall_cnt=64时触发，WAIT实际上经历65个判定边沿。再经过SETTLE/LUT，默认超时done在接受start后68clk=680ns。注释“64cycles=640ns”只对应数值常量，不是完整接口延迟（B：已有early-stream记录680ns）。STALL=0禁用watchdog，若没有22个有效比较或dec_clk停止，busy可一直为1。

超时只使clk FSM离开WAIT，**不向dec域发abort、不清dec_run**（345–368 vs486–490）。超时采样时counter可能仍在变化，所以正常完成的“冻结读出”前提不适用；还可能看到不同时间的ones/total。结果仍按固定N=22 LUT查表，不能把total<22的k当正确P。例如total=20、ones=10实际比例0.5，固定表k10却是-14Q8。shortfall/stalled必须丢弃或另建降级算法。

**最严重的确定性协议反例是旧测量晚完成被新请求接受为正常结果（B：本轮已复现）。** normal next run的tgl_ref只记当前同步到的值，不能识别还在链内的旧done（429–440、480）。具体外部端口时间线供bench复现：

- clk posedge=5+10n ns；dec posedge=1.5+3n ns。
- 105ns开始旧测量，正常prearm后送20个全1，随后停止；785ns超时发布total20、shortfall/stalled。
- 790.5ns、793.5ns补送旧测量剩余2个1，使旧done toggle在793.5ns翻转。
- 新start于795ns接受；旧done795ns入tgl_s1、805ns入tgl_s2；新ARM在805ns采样的tgl_ref仍是旧值0。
- 新dec arm约802.5ns清counter；新请求的22个全0从prearm后开始。
- 815ns新WAIT发现done_now，却捕到旧测量22/22；本轮实证835ns发布+258Q8、total22、shortfall=0、stalled=0，新请求尚未完成。

这不是亚稳态：只需合法同步输入、默认时钟、旧流在timeout后晚到即可。应将timeout定义成取消并完成跨域ack，或直到旧dec_run终止/状态复位且同步链排空才允许重启。只要求“见done就可以下一start”不够。

如果正常完成与stall_trip同拍，cap_shortfall因stall_trip直接置1，stalled也置1，即使captured total=22（489–490、531）。这可以作为明确deadline规则，但应写入接口并验收边界，不能认为full count自动免于timeout。

## 5. start / consume / busy 的确定性边界

独立go_tgl块只看start&&!busy（307–310），而FSM只在IDLE/HOLD使用start（445、451–452）；busy又按旧state更新。这两套“接受”条件不完全一致。

| 输入条件 | 当前行为与风险 | 行号 / 等级 |
|---|---|---|
| start后立即送比较 | arm经过同步；arm同拍决策也丢弃，phase0早流只收20/22，680ns错误发布 | 318–324、351–355；B已有记录 |
| start维持两个clk | E0旧IDLE开始ARM、busy仍0；E1再次翻go_tgl，第二次arm清已采样计数 | 309、445–446、513/518；A逻辑、B计数复现；合同外请求 |
| HOLD中start与consume同拍 | go_tgl会翻转，但consume优先使FSM进IDLE；dec acquisition无人等待、busy仍0、不发布done | 309、451–452、558；A逻辑、B外部复现；合同外请求 |
| busy高时start | go_tgl不翻，WAIT等状态也不接受；没有queue/拒绝脉冲，调用方必须自行重发 | 309、447–450；A |
| 新start覆盖未消费HOLD结果 | 该拍旧valid仍在；下一ARM才清valid/数值，旧结果可丢失 | 451–452、517–526、556–559；A |
| consume早于LUT发布 | consume在这些状态不生效；不能假定早ack会保留到发布 | 511–559；A |
| STALL=0或dec_clk停、决策不足 | 无timeout恢复，busy可不结束 | 426–427、447；A |
| reset在两个域不同步释放 | 可能丢arm/出现未定义状态；需要RDC/恢复释放验收 | 307/312/345/386/457/468/498；D |

held-start的确定性默认时序：start覆盖105ns和115ns两个clk；两次arm约112.5ns、121.5ns。按已有bench延迟12ns并等下一个dec negedge，第一比较为121.5ns，恰好被第二次arm优先清掉；22个输入最终计21（B：本轮实证）。若bench等待更长，这个风险可能被第二次arm已过所掩盖。

顶层注释建议把consume接raw_code_valid（core:74–76）不能作为通用规则。raw和SRM结果不是同拍、没有样本标签；过早consume被忽略，HOLD consume又可能撞上下一start。顶层raw每clk无条件更新（core:279–286），并不保持待配对raw。因此消费者必须在raw valid时捕获、保存并与residue对齐；“有raw输出寄存器”不等于配对安全。

## 6. LUT与参数护栏：默认正确，部分旋钮并不安全

### 默认表、half/full与裁剪

默认参数为N22/sigma128/RES_FRAC8/FRAC_OUT8/OUT_WIDTH10/HALF1（LUT:48–69），与estimator默认相同。半表存k0..11，cnt>11用5bit `(22-cnt)` 折叠并反号（152–160）；full表k0..22逐项写出（172–201）。默认SHIFT=0时两种路径完全相同，奇对称且范围±258，可装入10位signed；存储寄存器宽RES_Q_W=10，输出仅sign extend（estimator:261–297、551）。`make check`独立normal inverse-CDF、half/full镜像及生成器一致性检查覆盖12/23个表项（tools/check_repo.py:43–66），证据A/B。

这里有两种“范围”不能混淆：

- 正常dec_run在22时停计数，不会自然出现k>22。
- 输入LUT的非法cnt23..31没有统一饱和：HALF1减法5bit回绕后落到半表default0，因此输出0；HALF0 full表default返回+258（LUT:140、158、198）。不是两种实现都裁剪到+258。

estimator的simulation guard可在S_LUT报cap_ones>22（572–574），硬件不会保留此断言；错误capture若进入非法索引，仍会发布valid并走上述不一致默认值。应让非法count成为明确error而非normal结果。

### 小数位尺度错误

**当前ROM字面量实际固定Q8，未检查RES_FRAC必须为8。** LUT只锁定LUT_DECISION_COUNT22和LUT_SIGMA_Q8=128（122–123、208–211），没有LUT_RES_FRAC常量；而模块声称表是Q(RES_FRAC)，并用SHIFT=RES_FRAC-FRAC_OUT右移（77、160）。estimator又左移同样的差值（261、551），主要只恢复整数位，不能把原Q8字面量转换为新的Q(RES_FRAC)。

例：合法护栏组合RES_FRAC9、FRAC_OUT8、OUT_WIDTH10、RESIDUE_WIDTH11；k0=-258，经LUT >>>1=-129，再estimator<<1=-258。按Q9输出物理值为-0.50390625LSB，而正确重标度后应约-516Q9=-1.0078125LSB。默认8/8正常；允许参数范围并不证明参数功能正确（A/B：本轮LUT与estimator bench均已复现）。修复应锁定baked fraction或明确重生成/重标度且验证宽度，不仅增加sigma/N一致性检查。

### 降精度右移破坏正负对称

即使RES_FRAC仍8，把FRAC_OUT降4，现代码在反号后使用算术右移，向负无穷取整。k1=-194 >>>4=-13；k21=+194 >>>4=12；再左移4发布-208/+192Q8，配对和=-16Q8=-1/16LSB（LUT:160、168，estimator:551；B：本轮输出k1_q4=-13、k21_q4=12、pair_sum_q4=-1）。不是等距对称舍入，也不是原表精确奇对称。默认SHIFT0不受影响。

当前所有11组非零半表项在SHIFT4下都得到配对和-1Q4；如果P=0.5，实际均值约 `-(1-Pr(K=11))*1/32LSB≈-0.025994122LSB`（由 `Pr(K=11)=comb(22,11)/2^22` 精确计算）。头注释里量化噪声 `step/sqrt(12)`（LUT:31–34）只在特定均匀/近无偏误差模型下成立，不能作为当前离散且floor截断路径的已测噪声。要保持对称，可先对绝对幅度做对称舍入/截断，再恢复符号，并与原表定义固定误差策略。

### 护栏覆盖缺口

estimator非SYNTHESIS guard检查N2..31、RES_FRAC1..16、width、FRAC_OUT≤RES_FRAC、sigma正和STALL非负（160–183）；LUT另检查N、FRAC_OUT≤RES_FRAC、OUT_WIDTH≥2、table幅值与baked N/sigma/奇对称（82–105、206–218）。实际限制应看全部护栏：本ROM当前N只能22、sigma只能128，其他设置需要改表。

仍有以下局限（A）：

- 没有限定FRAC_OUT≥0，或在叶单独使用时限定RES_FRAC合法范围。负fraction不是可靠的公开旋钮。
- LUT幅度护栏遍历 `tbl_q8` 半表函数，k>11返回0；vmax实际为0，没有检查full/折叠正半峰值（94–103）。当前±258不恰好撞到signed负端点，默认没有因此溢出，但重新生成刚好负端点的表可能使正端反号溢出。
- 奇对称护栏只检查full表自身（213–215），没有对照半表与full表；手工只改半表可能仍通过叶内部护栏。本仓库外部make check可发现默认表差异，但硬件本身无保护。
- 所有护栏都在 `ifndef SYNTHESIS` 内；直接用非法参数综合可能截断或生成错值，不能靠仿真报错替代构建入口参数验收。
- `1 << (OUT_WIDTH-1)` 使用int宽度，极大OUT_WIDTH时边界表达式也需明确位宽；当前10位无问题，不应把任意正width当已覆盖。

## 7. 需要修正的既有表述

1. “Gray safe by construction / 同深度done说明counter已稳定2dec+2clk”改为待CDC证明；组合Gray、数据/事件相对到达与超时不冻结使该结论不成立（estimator:47–52、223–225、370–374）。
2. “SETTLE多等一拍才捕获”不准确：WAIT→SETTLE边沿已采cap，SETTLE仅位于捕获后（462–490、534）。之前PPA报告没有将其写为CDC验收，但后续说明必须准确。
3. “参数护栏保护尺度”需补RES_FRAC与baked Q8匹配；当前护栏允许明确比例错误。
4. “exact odd symmetry”只适用于未降精度的默认表；FRAC_OUT<RES_FRAC的算术右移可能有负偏差。
5. LUT头42行标FO4/OW6为DEFAULT已经过时，实际参数67–69为FO8/OW10/HALF1；±382是另一sigma示例，不是当前默认表的幅值（estimator:100、195，LUT:15）。
6. 5bit输入/5bit输出、必然片外重构、固定±1LSB饱和不能由JSSC正文当前证据推出。JSSC III-C只给LUT估算及输出修正，Fig6有Dout算术关系；没有明确处理放置不等于证明一定片外。core:17–50以thesis目录缺重构推出off-chip属于过度归因。当前片外划分可以作为本实现选择，不能代称论文定论。
7. 默认±258端点由有限p修正自然舍入已得到，当前clamp没有额外改变该默认值；端点限制不等于已验证模拟冗余范围。
8. “watchdog后ready可以直接重新测”需取消旧dec测量与同步链归属协议；正常200ns restart测试未覆盖旧完成晚到。
9. v3注释把丢decision导致的错误称为输入无关offset（estimator:25–33）过强：若固定N分母而漏计，CDF非线性误差通常随残差/概率变化，不能概括成恒定offset。

## 8. 最小复现与统计实验清单

所有bench仅通过外部ports驱动，不force内部、不读内部state来决定输入。内部wave可用于解释，但判定必须用外部可观察量。异常bench应打印 `RISK_REPRODUCED` / `CHARACTERIZATION_PASS`，不混入健康通过统计。

| 实验 | 输入与行为（明确已运行/待运行） | 验收目的 |
|---|---|---|
| 默认正常基线 | 原始RTL，10/3ns，12相位，100样本/相位，22决策，200ns start，12ns驱动等待 | 已有B，1200正确；保持回归 |
| 过早流 | start后0ns驱动，phase0，22个0 | 已有B，total20、shortfall/stalled、680ns |
| held start | 105/115ns两clk都start=1，12ns等待后22决策 | 已复现B，total21/shortfall/stalled；合同外请求但应收紧接受条件 |
| HOLD同拍start/consume | 正常完成后下一clk两者=1，然后22决策 | 已复现B，2请求只1发布；合同外请求，需一致的拒绝/接受条件 |
| 超时晚完成串新样本 | 第4节790.5/793.5补旧1；795新start，22个0 | 已复现B，新40ns结果+258/ones22/flags0；默认恢复风险未修复 |
| fraction参数 | 原始LUT与RES_FRAC9/FO8/W11 estimator，全0流 | 已复现B，Q9发布-258，正确重标度为-516 |
| coarse正负 | FO4、k1与k21；default同时对照 | 已复现B，Q4为-13/+12，pair sum=-1；恢复Q8为-208/+192 |
| illegal LUT index | 单独leaf对cnt0..31，HALF0/1 | legal两版应等；非法23..31现0/+258，需明确拒绝规则 |
| timeout临界 | 调节第22decision靠近第64WAIT判定，扫相位 | 定義deadline优先与full-count仍shortfall边界 |
| clocks pause/reset | 分别停dec/clk、resume；reset不同相位、重启 | 只证明逻辑异常策略，物理RDC另外验证 |

统计验证优先用精确Binomial枚举，避免把随机Monte Carlo误差当LUT问题：扫描r=-2..2LSB、sigma_actual、sigma_lut、offset，用实际23表项求bias/STD/RMSE/saturation probability。再加有限相关Gaussian过程/每组公共offset、held-residue drift和实际采样间隔，用独立随机种子和置信区间区分统计量。最后把校准误差、raw重构、SRM subtraction和完整ADC输入频率/幅度纳入FFT/INL/DNL；不能仅对LUT输出计算一个漂亮ENOB。

物理最小验收另列：源registered Gray或稳定数据握手选择、同步链标记与MTBF输入、two clocks/phase/ratio CDC分析、bus-skew/max-delay、reset release/RDC、门级四状态和SDF min/typ/max。零延迟风险bench不能证明或否定亚稳态安全。

## 9. 本轮证据与检查点

- 原始RTL：[`srm_residue_estimator.sv`](../../evidence/rtl_baseline/srm_residue_estimator.sv)、[`srm_residue_lut.sv`](../../evidence/rtl_baseline/srm_residue_lut.sv)。共599/222行已完整阅读。
- 顶层接口交叉核对：[`sar_digi_paper_core.sv`](../../evidence/rtl_baseline/sar_digi_paper_core.sv)，重点74–76、229–253、279–286。
- 默认表来源及独立检查：[`gen_srm_lut.py`](../../tools/gen_srm_lut.py)、[`check_repo.py`](../../tools/check_repo.py)。
- 已保存实验：[`tb_srm_latency.sv`](../../tests/tb_srm_latency.sv)、[`latency_result.json`](../../docs/ppa_20261001/latency_result.json)。范围明确为两状态、零延迟。
- 论文依据：JSSC III-C/D/E及IV，只读核对本地13页原文提取；本报告不复制论文全文或旧thesis注释作为结论。
- 本轮风险复现实验：[tb_rtl_review.sv](../../tests/tb_rtl_review.sv)、[review_run.log](review_run.log)。原RTL不变，仅外部端口驱动；`RTL_REVIEW_CHARACTERIZATION_PASS` 表示指定风险被稳定复现，并非设计健康通过。
- 本轮精确统计原型：[analyze_rtl_principles.py](../../tools/analyze_rtl_principles.py)、[统计JSON](principle_numbers.json)，从实际23个ROM字面量读取并计算，默认校准状态动作公式验证207352。
- 检查点：原理/两域状态/默认参数/CDC/超时/协议/统计条件已复核；三项协议与两项参数风险已由主任务外部端口bench确认为B，CDC物理条件仍D。没有修改原RTL或商业工具结果。
