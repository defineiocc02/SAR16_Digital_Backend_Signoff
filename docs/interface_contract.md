# 当前接口契约与集成假设

依据 v5.1 RTL；初始审计日期 2026-09-30，2026-10-01 补充独立 SRM 时序实验，2026-10-02 补充[原理与协议风险复核](rtl_principle_review_20261002.md)。历史契约中已作废的 tie/reset 操作仅供追溯，不用于集成。本文件区分 RTL 行为、已测协议和待验证物理条件。

## 时钟与复位

| 接口 | 当前约定 |
|---|---|
| `clk` | housekeeping 域，历史约束 10 ns |
| `dec_clk` | SRM 判决域，历史约束 3 ns，与 `clk` 异步 |
| `rst_n` | 低有效异步复位，送到两个时钟域；当前 RTL 没有各域同步释放电路 |
| `VDD/VSS` | GDS/LEF 的电源端口；RTL 未建模电源，不能据此证明标准单元 PG 已连接 |

reset 应覆盖两个域的启动条件。如何同步释放及验证 recovery/removal 仍需 RDC 与 STA 关闭；不能把历史文档的“像普通同步复位一样用”当作已经验收的硅上契约。

## 输入所属时钟域

`start_calib`、`data_valid_i/raw_bits_i[19:0]`、`srm_start`、`residue_consume_i` 按 `clk` 同步输入使用。`srm_decision_valid/bit` 按 `dec_clk` 同步输入使用，bit 必须覆盖有效采样边沿。`calib_comp_out` 可以异步输入，控制器含两级采样；仍需验证比较器 settling 和亚稳态风险。

顶层对 `raw_bits_i/data_valid_i` 直接寄存，**没有多位异步握手**。如果模拟侧/SAR sequencer 的输出不同步于 `clk`，集成方必须提供稳定窗口或握手，不能直接按当前同步 SDC 连接。

## 校准发布

- 默认校准地址 **6..19**，每轮 14 次 `w_wr_en`，数据为 signed 30 位 Q8。
- 地址 0..5 是参考段，控制器内部初始化为 `REF_WEIGHT_LSB << i`；外部重构器需按同一契约初始化它们，不能等待不存在的六次发布。
- `calib_done` 保持到重启，`calib_done_pulse` 为完成脉冲；用一个 `clk` 周期的 `start_calib` 请求新一轮。
- 发布流没有 ready/backpressure，消费者必须接收全部写入。`calib_overrange/bits` 应参与该轮权重的接受判断。
- 两次完整 sweep 的地址/数量/完成协议已由新冒烟测试覆盖；独立校准数值精度、失配/offset/noise 覆盖尚未验收。
- 当前校准控制器没有 SRM 残差输入，顶层 SRM 结果未反馈给校准。若按 JSSC 2025 的 SS + SRM 校准流程集成，需先定义残差尺度、样本对应关系和定点累加/平均规则，再验证数值精度；当前 P/N loops 不构成该流程的验收证据。
- 默认每次 SAR 试探到判决为 16T，判决读取两拍前 comparator 样本，实际 settling 截止约为试探后 14T=140 ns，另扣 setup/模拟余量。半 LSB 修正是有条件的中心估计；首目标实验已复现固定无噪声下的量化偏差，完整非二进制 CDAC 精度未验收。

## SRM 发布

- `srm_start` 使用一个 `clk` 周期的脉冲。`busy=0` 不表示决策域已经 armed，请求还要经过 toggle 同步。当前没有对外 `ready/armed`。
- 正常流程接收 22 次有效决策并冻结计数，通过同步读出发布 `srm_done` 脉冲、`srm_residue_valid` 和 residue。
- residue 是 **signed 10 位 Q8**。原报告的 raw word `966` 表示 `966-1024=-58`，即 −0.2265625 LSB；`981` 表示 −43，即 −0.16796875 LSB。
- `residue_consume_i` 清除 valid。RTL 也允许从 HOLD 直接 start，并覆盖未消费结果，调用方需要明确是否允许丢弃。
- 已复现合同外输入的局限：HOLD 同拍 start/consume 会启动决策域但不发布结果，start 保持两个周期会重复 arm。集成采用单周期请求，并将 consume 与新 start 分开；busy 高时请求没有队列。
- 看门狗超时时仍会发布 valid，但 `srm_count_shortfall/srm_stalled` 置位。LUT 仍基于 N=22，消费者必须丢弃该结果或明确降级，不能按正常 residue 使用。
- **超时恢复尚不安全：** watchdog 没有取消决策域测量。默认单周期请求下，迟到旧 done 已复现旧 22/22 全 1 计数被发布给新全 0 请求，且 shortfall/stalled 为 0。修复前，超时后必须协调暂停上游、完成受控复位/重同步并丢弃受影响样本；不能仅凭 busy=0/错误 done 直接重启。新版本需取消/终止 ack 和请求归属验收。
- LUT 字面量固定 Q8；当前护栏允许的 RES_FRAC=9 会尺度错误，FRAC_OUT=4 会负偏置。本核心集成冻结 RES_FRAC=FRAC_OUT=8；其他格式须先重生成/修复及验证。
- 2026-09-30 smoke 验证正常计数、HOLD 重启、无决策超时、特定恢复及忙时复位；恢复用例没有迟到旧 done，不能推广为任意超时恢复。2026-10-01 相位实验见下文；2026-10-02 风险复现为 `make review`。任意时钟关系、亚稳态与整机连续 5 MS/s 仍需验收。

### 已测 start / 发布时序的范围

[`tests/tb_srm_latency.sv`](../tests/tb_srm_latency.sv) 直接实例化原 SRM RTL，在 `clk=10 ns`、`dec_clk=3 ns` 下扫 0..2.75 ns 的 12 个相位，每个相位运行 100 个样本，接受 start 间隔固定为 200 ns。测试在接受 start 后等 12 ns，再对齐决策时钟驱动 22 次比较；正常计数、signed LUT、valid 和错误状态均逐样本核对。

1200 个正常样本通过；接受 start 到 done 为 120 ns，最后比较到 done 为 40.5–43.25 ns。这里的 12 ns 是上述固定配置中的测试驱动等待，**不是任意时钟比/PVT 下的 ready 保证**。phase=0、启动后立即驱动的反例只计入 20/22 次比较，最终置 shortfall/stalled。这给出了真实集成前必须解决的 arm 边界。

集成应以可靠的 armed/ready 应答或经过验证的预先 arm 规则控制首个比较；同时定义末次比较后的冻结窗口、重新 arm 和 consume 顺序。实验从 HOLD 重启并允许覆盖上一结果，只验收孤立 SRM 的处理节拍，不验收消费者的吞吐或完整 ADC 配对。跨域亚稳态、四状态 X、post-route SDF 和模拟保持时间不在本实验中。冻结结果见 [时序解析](ppa_20261001/latency_result.json)，公开复现为 `make ppa`。

## raw 与 residue 配对

`raw_code_o/raw_code_valid_o` 是 `clk` 寄存输出，raw 数据在 valid=0 时也可以变化，消费者只在 valid=1 时接受。raw 与 residue 没有 sample ID、FIFO 或配对校验，上游必须保证一一对应及数据保存时间。SRM 完成后的数字发布可与下一次采样/转换重叠，但消费者必须保存对应 raw，防止新 raw 覆盖尚未发布 residue 所属的样本。后续接口设计需要把采样编号、错误状态、arm 时刻和消费规则纳入验收。
