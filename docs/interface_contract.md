# 当前接口契约与集成假设

依据 v5.1 RTL；日期 2026-09-30。历史契约中已作废的 tie/reset 操作仅供追溯，不用于集成。本文件区分 RTL 行为、已测协议和待验证物理条件。

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

## SRM 发布

- `srm_start` 使用一个 `clk` 周期的脉冲。`busy=0` 不表示决策域已经 armed，请求还要经过 toggle 同步。当前没有对外 `ready/armed`。
- 正常流程接收 22 次有效决策并冻结计数，通过同步读出发布 `srm_done` 脉冲、`srm_residue_valid` 和 residue。
- residue 是 **signed 10 位 Q8**。原报告的 raw word `966` 表示 `966-1024=-58`，即 −0.2265625 LSB；`981` 表示 −43，即 −0.16796875 LSB。
- `residue_consume_i` 清除 valid。RTL 也允许从 HOLD 直接 start，并覆盖未消费结果，调用方需要明确是否允许丢弃。
- start/consume 同拍、start 保持多个周期、busy 中请求和决策流过早到达尚无完整外部协议验证。集成前采用单周期请求，并将 consume 与新 start 分开。
- 看门狗超时时仍会发布 valid，但 `srm_count_shortfall/srm_stalled` 置位。LUT 仍基于 N=22，消费者必须丢弃该结果或明确降级，不能按正常 residue 使用。
- 本轮用固定时钟和足够 arm 间隔验证正常计数、从 HOLD 重启、无决策超时、超时后恢复及忙时复位；未证明任意时钟相位、亚稳态和连续 5 MS/s 的契约。

## raw 与 residue 配对

`raw_code_o/raw_code_valid_o` 是 `clk` 寄存输出，raw 数据在 valid=0 时也可以变化，消费者只在 valid=1 时接受。raw 与 residue 没有 sample ID、FIFO 或配对校验，上游必须保证一一对应及数据保存时间。后续接口设计需要把采样编号、错误状态、arm 时刻和消费规则纳入验收。
