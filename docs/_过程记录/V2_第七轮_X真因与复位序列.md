# 独立核查 V2 第七轮：X 问题的真因找到并解决；但 FSM 仍不动

**跑于** 2026-09-19　**产物** `/tmp/v2h/`（`tb_rst.sv`、`build.log`、`run.log`）
**上一轮的假设被否掉**：`HFSNET_4` 实测 = **1**（不是 x），`SN` 端是**非活跃**的。
真正的原因是**初始化**，不是 SN。

---

## 1. 上一轮的假设：**被实测否掉**

```
SNV srm HFSNET_8   = 0      (根被 force 成 0)
SNV srm HFSNET_4   = 1      ← 反相输出，SN 非活跃，不是 X
SNV srm HFSNET_6   = 1
SNV srm HFSNET_9   = 1
SNV srm go_tgl     = x      ← 仍然 X
```

**⇒ "SN 上的 tie 网络是 X"这个假设不成立。**

## 2. X 的真因：**块从来没有被复位过**

把 tie 根**一开始就 force 成 0**，等于让 `rst_n` **从 t=0 就是 1**；
而这些触发器用的是**同步复位**（异步端只做置位），于是它们**永远等不到复位**，
保持在 X。**这不是 SN 的问题，是复位序列的问题。**

## 3. 修正后的激励：把 tie 根当**复位序列**来驱动

| 阶段 | 根 | `rst_n` | 含义 |
|---|---|---|---|
| 1 | **1** | 0 | 断言复位 |
| 2 | **0** | 1 | 释放复位 |

```
RST reset_asserted  t=320000  rstn_srm=0 state=000 go_tgl=0 busy=0 done=0 total=0
RST reset_released  t=420000  rstn_srm=1 state=000 go_tgl=0 busy=0 done=0 total=0
RST after_start     t=540000  rstn_srm=1 state=000 go_tgl=0 busy=0 done=0 total=0
RST after_decisions t=3180000 rstn_srm=1 state=000 go_tgl=0 busy=0 done=0 total=0
RST late            t=11180000 rstn_srm=1 state=000 go_tgl=0 busy=0 done=0 total=0
```

**`go_tgl` 从 `x` 变成 `0`** ⇒ **复位序列确实生效了，X 问题解决。**

**⇒ 这条同时坐实了交付缺陷的另一半**：要让这份网表跑起来，外部人必须
（a）知道存在这条 tie 根，（b）知道要把它当**复位序列**驱动。
**这两件事都不在接口契约里**——也就是说，**交付的网表对这两个最大子模块没有定义复位。**

## 4. 但**第二个卡点**出现了，本轮将其干净隔离

复位正确、`go_tgl` 已归零、`start_pin` 也已证明跟得上 ——
**`state` 仍然停在 `000`（S_IDLE），`busy` 不抬。**

RTL 的状态转移是 `S_IDLE: next_state = start ? S_ARM : S_IDLE;`，
`start` 脉冲覆盖了两个 `clk` 上升沿。**所以现在排除了：X、复位、start 通路、时钟存在性。**

**剩下的怀疑对象（未验证）**：`state` 寄存器的**时钟被门控**——综合插入了
`SNPS_CLOCK_GATE_*`，若其使能没被拉起，`state` 的时钟就不过去，寄存器恒定不变。
**下一轮第一件事：把 `state` 触发器的时钟脚与那个时钟门的 `ENCLK`/`EN` 打出来。**

## 5. 本轮进度小结

| 项 | 状态 |
|---|---|
| 复位锁死（根值决定块是否被复位） | 第 5 轮对照证实 ✅ |
| X 的真因 | **本轮确定：缺复位序列，不是 SN** ✅ |
| 复位序列生效 | 本轮实测（`go_tgl` x→0）✅ |
| **交付缺陷的另一半：无定义复位** | **本轮坐实** ✅ |
| FSM 为何不离开 S_IDLE | **未解决**（怀疑时钟门控，待验）❌ |
| `ones = 8 of 22` 独立期望核对 | 仍未开始 ❌ |
