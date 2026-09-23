# 独立核查 V2 第六轮：复位解除后暴露 X——FSM 进了 `S_ARM` 又退回 `S_IDLE`

**跑于** 2026-09-19　**产物** `/tmp/v2f/`（`tb_st.sv`、`build.log`、`run.log`）
**前提**：本轮把五个 tie 根 `HFSNET_120…124` 全部 force 为 **0**（= 复位解除），
然后在 `srm_start` 脉冲前后密集取样，看块**内部**的 `state`、`go_tgl`、`dec_run`、`dec_total`。

---

## 1. 实测

```
ST idle       t=320000  rstn_srm=1 start_port=0 start_pin=0 state=000 go_tgl=x busy=0 dec_run=x dec_total=x
ST pulse_hi   t=332000  rstn_srm=1 start_port=1 start_pin=1 state=001 go_tgl=x busy=0 dec_run=x dec_total=x
ST pulse_lo_1 t=352000  rstn_srm=1 start_port=0 start_pin=0 state=000 go_tgl=x busy=0 dec_run=x dec_total=x
ST later      t=552000  rstn_srm=1 start_port=0 start_pin=0 state=000 go_tgl=x busy=0 dec_run=x dec_total=x
ST late       t=2552000 rstn_srm=1 start_port=0 start_pin=0 state=000 go_tgl=x busy=0 dec_run=x dec_total=x
```

| 观测 | 值 | 说明 |
|---|---|---|
| `start_pin` vs `start_port` | **完全跟随（0→1→0）** | **`srm_start` 的连接是好的**，排除"端口没接上" |
| `state` | `000` → **`001`（S_ARM）** → `000` | **FSM 确实看到了 start 并走进了 S_ARM**，时钟也在跑 |
| `busy` | 始终 0 | S_ARM 之后没有停在 busy 态 |
| **`go_tgl` / `dec_run` / `dec_total`** | **全是 `x`** | **决策域寄存器是 X** |

**⇒ 卡点不是 start 通路，也不是时钟，而是"决策域寄存器处于 X"。**

## 2. 目前的解释（**假设，尚未验证**）

网表里那些触发器的**异步置位端被接在 tie 网络上**：

```verilog
DFFSX1 go_tgl_s1_reg ( .D ( n132 ) , .CK ( ctosc_gls_0 ) , .SN ( HFSNET_4 ) , … )
```

`HFSNET_4` 是 tie 链的反相副本。若它的值是 **x**，则 `SN = x` ⇒ 触发器输出恒为 **x**，
与实测的 `go_tgl=x / dec_run=x / dec_total=x` 吻合。

**这条是假设**：本轮**没有**打印 `HFSNET_4` 的值，所以不能当成结论。
**下一轮第一件事**：把 `dut.u_srm_residue.HFSNET_4`（及其它 `SN` 上用的 tie 网络）的值打出来。

## 3. 与第 3 轮"无 X"的关系（不矛盾）

第 3 轮我报"20 个输出 + 4 个内部点无 X"。当时**复位是被拉住的**（`rstn_*=0`），
触发器被异步复位钉成 0，输出自然是确定的 0。
**本轮把复位解除之后，X 才暴露出来。**
⇒ 第 3 轮那条结论依然成立，但它成立的前提（复位常驻）正是本轮要绕开的东西。
**"无 X"和"能工作"是两件事**——这是本次独立核查到目前为止最实用的一条经验。

## 4. 本轮**没有**做到的

| 项 | 状态 |
|---|---|
| 复位锁死 → 因果对照 | 第 5 轮已证 ✅ |
| start 通路 / 时钟 | 本轮排除 ❌→✅ |
| 决策域为何是 X | **假设有，未验证** ❌ |
| SRM 计数器的独立期望核对（`ones = 8 of 22`） | **仍未开始** ❌ |

## 5. 工具观察

编译时报 3 条 `Warning-[TFIPC] Too few instance port connections`。
**本轮未追这条警告**——它可能与本问题无关，也可能相关（端口连接数不足会造出悬空端）。
**列为待查**，不猜。
