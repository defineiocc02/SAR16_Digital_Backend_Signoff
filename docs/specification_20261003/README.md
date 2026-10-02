# SAR16 SMIC18 规格、面积与引脚规划

首版采用 **32 pin、两lane串行ADC数据 + 独立SPI配置**，48 pin并行输出仅作对照。目标是 **20路非二进制冗余物理权重 → 校准重构16位输出**，不是raw20截断。当前规格表以论文目标、历史已核事实与本轮工程分配分别标注；**没有完成整芯片重构、串行输出、SPI、模拟迁移或物理签核，这些数字不是已实现成绩**。

正式报告索引：[PDF](sar16_smic18_spec_floorplan.pdf) · [LaTeX源码](sar16_smic18_spec_floorplan.tex)。

## 规格与方案

| 项目 | 目标/已知条件 | 当前边界 |
| --- | --- | --- |
| 工艺与输入 | 统一SMIC18；差分范围目标6.6Vpp，参考3.3V | 既有模拟与历史数字涉及不同工艺，须重新实现；模拟工作点/器件应力待核 |
| 输出/采样率 | 重构signed16；5MS/s，200ns/sample | 完整ADC→SRM→重构→输出尚未验收；吞吐不等于latency≤200ns |
| 性能基准 | 论文低频93.7dBFS SNDR | 条件约Fin2.136kHz、−1.45dBFS、256k点；不是当前设计测量 |
| 时钟与SRM | core历史100MHz；SRM22次、历史dec_clk3ns | 333MHz封装clock链未核；内部ready事件也需qualified/CDC定义，不能直接绑READYN |
| 首版数据接口 | 两lane24bit frame：16data+4status+4seq；120Mbps | 100MHz SDR burst12周期/120ns是建议时序，pad电平/速度/SI未成为保证 |
| 配置与偏置 | SPI只配置/测试；VB/VBC外调；三个VCM独立 | 未假设片上bias、参考驱动、PLL或input buffer存在；SPI不是全速数据通路 |
| 内部/封装区分 | core31组/176信号，提取SP178formal | 是片内接口；32/48pin按外部角色独立预算 |

详表：[模拟规格](analog_specs.csv) · [数字规格](digital_specs.csv) · [引脚解释与调度预算](digital_pin_budget.md) · [机器可读预算](digital_pin_budget.json)。后续必须修复原SRM的arm/abort及旧done归属，定义raw/residue配对、低六权重初始化、归一化和异常帧；封装握手不能代替RTL修复。

## 当前名义面积模型

以下从 [area_estimate.json](area_estimate.json) 的 `nominal_folded/32pin` 取值。片上重构推荐为两权重/clk的折叠候选，新增cell nominal0.095mm²；没有共享现有无读口shadow RAM的面积信用。132bit配对/输出缓冲包含在协议预算，不重复相加。

| 模块/占位 | 名义面积mm² |
| --- | ---: |
| 数字macro（含新重构与协议） | 0.383838 |
| 两侧共享采样Cs（20pF/side，含版图系数） | 0.053664 |
| 两侧CDAC独立占位 | 0.020000 |
| CAZ / Flash / bootstrap电容占位 | 0.013725 |
| 供电/参考去耦占位 | 0.094943 |
| 其他模拟有源与局部布局 | 0.090000 |
| 模块合计 | 0.656171 |
| 加20% core留白后的面积窗口 | 0.820213 |

推荐整die规划 **1.60×1.60mm = 2.56mm²**，概念core window **0.95×0.95mm**，数字占位约 **410×940µm**。名义公式得到的1.55mm边长是几何结果，推荐另留到1.60mm；这不是package外形尺寸或已布线结果。

真实IO body/corner尺寸已用于模型，**35µm单元宽度不等于bond pitch**。70/90/110µm bond pitch、seal/clearance、MIM版图系数、CDAC匹配与PEX占位仍是情景假设，情景也不是PVT corners。低pin有助于pad-ring约束，但不保证die缩小。1.99fF/µm²的compact MIM2情景还需要对应工艺选项；小unit不能只凭密度公式认定可实现。

全部情景：[area_scenarios.csv](area_scenarios.csv)；IO动态负载示例：[io_power_scenarios.csv](io_power_scenarios.csv)。例如条件1.8V、5pF/pin时，串行data+DCO负载充电功耗约1.458mW；IO电压尚未批准，且该数不含pad内部/短路/静态、控制脚和serializer功耗，不能与论文ADC功耗直接相加排名。

## 逐pin导入

- 主方案：[pinout_serial32.csv](pinout_serial32.csv)，9模拟+10电源/地+13数字。
- 对照：[pinout_parallel48.csv](pinout_parallel48.csv)，9模拟+12电源/地+27数字。

两CSV从 `digital_pin_budget.json` 生成，可作为EDA/封装分配的输入模板。`proposal_index`只是完整性索引；`physical_package_pin`和`die_pad_instance`刻意留空，待pad/ESD/回流/封装共同设计后填写。若封装带exposed pad，需另定义这个端子及其连接。

## 复现与验收

本目录只需Python标准库即可重新计算情景，无需PDK文件或商业EDA：

```sh
python3 area_model.py
```

该脚本生成 `area_estimate.json`、`area_scenarios.csv` 和 `io_power_scenarios.csv`。修改参数后须同步更新正式报告；规格CSV保留各自证据类别，不能把脚本输出当综合/仿真结果。LaTeX源码与PDF提供报告交付与复现入口，使用XeLaTeX连续编译两次，Fandol字体与TikZ图均可复现。

PDK证据仅保留[公开参数与来源hash摘要](smic_public_facts.json)。MIM列出的15–50µm提取结构不是DRC min/max；约7.3fF单元和20pF分块阵列都需验证。bootstrap名义6pF是重设计额度，直接复用两侧原结构为10pF时core增加约0.00722mm²。IO宏内利用率与全局隔离留白分别计账。

下一里程碑：关闭样本/残差归属和数值重构，选定SMIC18器件/IO/ESD，验证完整5MS/s和同条件FFT，再执行新综合、布局布线、CDC/RDC、STA、IR/EM、DRC/LVS。当前文件不含私有PDK路径或模型内容。
