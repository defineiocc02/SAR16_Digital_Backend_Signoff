# SAR16 接口规范与接线准备

本目录固定当前 `sar_digi_paper_core` 默认参数的 **31 组、176 位信号接口**，并记录模拟侧的物理索引与待验证边界。20 路非二进制冗余物理权重重构为 16 位校准输出，符合目标架构；`raw_bits_i[19:0]` 的宽度本身不是论文复现差距。当前核心仍需外部 SAR/Flash 控制、权重消费及带 SRM 的重构路径。

| 文件 | 用途 |
| --- | --- |
| [sar16_core_interface.json](sar16_core_interface.json) | 默认参数、RTL 端口组/方向/位宽/signed/时钟域及证据路径；改变参数后需重新审查接口 |
| [sar16_core_pinmap.csv](sar16_core_pinmap.csv) | 176 位信号和 VDD/VSS 共 178 行；逐位给出 Verilog `[]` 名称、建议 OA `<>` 别名、所属 signed 组，以及两份 SPICE 证据中的 1 起始位置 |
| [sar16_core_pin_adapter.sp](sar16_core_pin_adapter.sp) | 仅将规范位置顺序转换为**提取 SP**的实际 formal 顺序 |
| [analog_weight_map.csv](analog_weight_map.csv) | 20 个权重索引 `i` → 物理 CDAC 索引 `j=i+1` → driver `SET<19-i>`；raw 正负号仍待验证 |
| [analog_boundary.csv](analog_boundary.csv) | 模拟侧角色、既有名称、名义电平/格式及待补条件 |

规范顺序为 RTL 声明的端口组顺序，每个总线从 MSB 到 LSB，再附加适配器专用 VDD、VSS。`group_signed=1` 表示该位所属总线为有符号量，并不表示每一位都是符号位。OA 别名只是命名约定；本数字核心尚未有经检查器验证的 OA symbol。

## 可复现检查

在仓库根目录执行：

```sh
make interface
```

需要从已核对的规范和原始证据再生成派生文件时执行：

```sh
python3 tools/check_sar16_interface.py --generate
```

`--generate` 只生成数字逐位 CSV 与位置适配器，不修改 canonical JSON、模拟映射或 `evidence/`。检查器读取实际 RTL、PNR Verilog、源 CDL、提取 SP 和 LEF，检查端口方向/位宽/signed、总线展开、唯一对应及适配器子实例的位置；另外核对 20 行物理映射与 [OA 清单](../docs/analog_integration_20261002/oa_interface_inventory.json) 中的 CDAC pin 和 20 个 driver 连接。边界表只检查非空、角色唯一性及状态/需求字段，电气与时序语义需另行验证。负例测试确认交换 raw 位、漏信号 pin、交换提取子实例位置或漏电源会失败。

## 源 CDL 与提取 SP 的区别

源 [sar16.cdl](../evidence/rpt_v51/sar16.cdl) 的顶层 formal 为 176 个信号，VDD/VSS 在 `.GLOBAL` 声明；原文件保持原状。提取 [sar_digi_paper_core.sp](../evidence/rpt_v51/sar_digi_paper_core.sp) 为 178 个 formal，且顺序发生重排：`clk` 为第 1、VDD 第 45、VSS 第 132、`rst_n` 第 177、`dec_clk` 第 178。

适配器的 `Xcore` 按提取 SP 的 178 个真实位置列出节点。使用时应单独提供该提取核心定义及适当模型，适配器没有 `.include`、PDK 模型或晶体管内容。**它不能用于源 CDL 的 176 pin 顶层实例**，也不改变源 CDL 的全局电源。没有执行 SPICE 或 LVS，因此通过检查只证明名称和位置对应。

基线 [LEF](../evidence/rpt_v51/sar_digi_paper_core.lef) 包含 **109 个标准单元 macro**，可用于叶单元面积检查；没有 `sar_digi_paper_core` 顶层 macro，不能拿它作为数字核心的物理 pin/obstruction 抽象。

## 接入模拟侧前的必要条件

driver 的 `BITP/BITN` 是现有开关逻辑输入，`dac_p_force/dac_n_force` 是校准码；必须先核对实际 switch truth table、P/N 极性、复位行为和采样相位，才能建立连接。电平转换、负载、时钟和复位释放也尚未闭合。当前模拟工程与历史数字实现涉及不同 foundry/PDK，不能直接拼接物理版图；应在统一工艺中重新实现和验证。

样本接口还需要明确 ready/prearm、请求接受条件、超时后的旧 `done` 清除及 raw/residue 配对。`raw_code_o` 每个 `clk` 都更新，消费侧需捕获对应样本并加标签；`raw_code_valid_o` 不能单独证明其与 SRM 属于同一次转换。不要将未实现的时序用固定 0/1 连接后宣称集成完成。

权重、raw 符号和 SRM 残差须在相同数值坐标中重构；最终 16 位归一化/舍入应在残差处理之后验证。现有源代码的校准/重构功能与接口差距见 [模拟与数字集成审计](../docs/analog_digital_integration_20261002.md)。LVS、DRC、CDC、PVT、5 MS/s 与论文 SNDR 的闭合均不由本目录的静态命名检查建立。

电容映射的 `paper_relative_cap_units` 是论文Fig.6的名义比例，当前MOM模型有效值需要另行验证；它不是已测权重或校准结果。模拟边界表已单列未驱动CLKn和CLK名义3.3V到1.8V latch的连接风险。
