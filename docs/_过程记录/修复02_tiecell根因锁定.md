# 修复日志 02：根因锁定 —— **库里有 tie cell，但 P&R 脚本从没绑定它**

**日期**：2026-09-19 ｜ **承接**：修复日志 01（复位丢失发生在 P&R，机制线索为 OPT-200）

---

## 1. 库里有 tie cell（两级证据）

**① 库文件里有**（`smic18/digital/sc/lvs_netlist/smic18.cdl`，471 个 subckt）：

```
TIEHI
TIELO
```

**② NDM 里也有**（直接问 FC，不是猜）：

```
Q *TIEHI* count=1 names=sar16_smic18_6lm_v4/TIEHI
Q *TIELO* count=1 names=sar16_smic18_6lm_v4/TIELO
Q *TIE*   count=2 names=sar16_smic18_6lm_v4/TIEHI sar16_smic18_6lm_v4/TIELO
```

**⇒ tie 单元在库里、在 NDM 里、FC 也能取到。**

## 2. 可 FC 却在日志里说"没有 tie cell"

```
Warning: No tie cell is available for constant fixing. (OPT-200)
```

**两句都对，只能这么解释：tie cell 存在，但 P&R 脚本没有把它绑定给 FC。**
（我此前检索 `scripts/fc_pnr_paper_core.tcl` 时，只有关于"常量驱动输出端口"的注释，
**没有出现任何 tie cell 绑定语句**。）

没有绑定时，FC 只能**用反相器从常量造常量** —— 这就是网表里 85 个
`HFSINV_*`（`.A(HFSNET_8)` → `.Y(HFSNET_4/6/9/…)`）的来源；
而它们的常量根 `HFSNET_120…124` **在写出的网表里没有驱动**。

## 3. 完整因果链（每一环都有证据）

| # | 环节 | 证据 |
|---|---|---|
| 1 | RTL 把 `rst_n` 接到两个子模块 | `rtl/sar_digi_paper_core.sv:209/240` `.rst_n(rst_n)` |
| 2 | DC 综合保住了它 | `mapped_ss/…_netlist.v:6114/6122` **`.rst_n(rst_n)`**，`HFSNET` **0 行** |
| 3 | **P&R 脚本没有绑定 tie cell** | tcl 里无绑定语句；FC 日志 `OPT-200` |
| 4 | FC 用反相器造常量 | 85 个 `HFSINV_*`，`.A(HFSNET_8)` |
| 5 | 常量根没落地 | `HFSNET_120…124` 无驱动；`HFSNET_119 → rst_n` |
| 6 | 结果：两个最大子模块**复位锁死** | 仿真实测 `rstn_calib=0 rstn_srm=0`，对照：根 0/1 → `rst_n` 1/0 |

## 4. 修复动作（下一步执行，判据明确）

在 `fc_pnr_paper_core.tcl` 里给 FC 绑定 tie cell（等价于
`connect_tie_cells` 的 high/low 库单元），例如：

```tcl
# 让 FC 用库里的 TIEHI/TIELO，而不是用反相器造常量
set_app_options -name opt.tie_cell.high_lib_cell -value sar16_smic18_6lm_v4/TIEHI
set_app_options -name opt.tie_cell.low_lib_cell  -value sar16_smic18_6lm_v4/TIELO
# 或在插入阶段显式 connect_tie_cells
```

（**具体选项名需在目标版本上核实**——本轮只是把根因锁定，没有改脚本。）

**然后重跑 P&R，四条可自动核对的判据**：

| # | 判据 | 目标 |
|---|---|---|
| 1 | 布线后网表里 `HFSNET` 行数 | **0**（当前 1841） |
| 2 | Formality FM-399「实现侧无驱动网」 | **0**（当前 5） |
| 3 | 门级仿真：复位序列后 `busy` | **抬起**（当前恒 0） |
| 4 | LVS | 短路 0、端口 178 不变 |

## 5. 边界与风险

- **本轮只做定位，未改任何脚本/设计**；
- 「脚本没绑定 tie cell」是**由 OPT-200 与"库里确实有 tie cell"两条证据推出的结论**，
  但**尚未做"绑定后 HFSNET 归零"的对照实验** ⇒ 判据 1 未验证前不宣称修好；
- 重跑 P&R 必须在**副本工程或独立输出目录**上做：stage 脚本会 `rm -rf $PRJ/pnr`，
  **不能动现有交付产物**。
