# SAR16 后端 · 接手第 5 轮：LVS 残差归因 + 块 abstract 可行性判定

**时间**：2026-09-18 20:40–21:05　**性质**：只读诊断（未改设计、未改脚本）

---

## 1. 本轮最重要的结果：**"库数据坏了"这个假设被实测推翻**

上一轮把 LVS 的残差收敛到：**变换后端口 178 = 178 相等**，剩下的只是
`Nets −109`、`MN +14 / MP +21`、`Total Inst +50`，以及 35 个"版图有、源没有"的单管。
形态（符号有正有负、散布在 ~20 种单元类型上）像是**逐单元数量对不上**。

于是做了那个决定性实验：**拿 kit 自己的版图 + kit 自己的 CDL，单独跑每个标准单元的 LVS**。
若单元跟自己都对不上，任何用它搭的设计都不可能过 LVS —— 那就是库数据问题。

| 规模 | 结果 |
|---|---|
| 先做 12 个代表单元 | **12/12 CORRECT** |
| **再扩到该设计实际用到的全部 109 个 master** | **109/109 CORRECT（0 个 INCORRECT）** |

**→ 库是自洽的。** 这条排掉了一整类解释，也就意味着残差**不能甩给库数据**。

### 1.1 网表 ↔ 版图在单元层面**完全一致**（另一个干净结果）

把 P&R 网表**按层次展平**后与版图顶层的放置逐 master 对差：

```
版图顶层放置 : 3626 个单元 / 109 种 master
展平后网表   : 3626 个实例 / 109 种 master
仅版图有 : 0        仅网表有 : 0        计数不同 : 0
```

**所以 +50 的器件残差发生在"单元内部"，不是"多了/少了单元"。**
这把问题也收窄了一大步：库单元单独自洽、单元数目又完全对得上，
残差只能来自**同一单元在本设计的行/轨/条带环境里被提取出的器件与孤立提取不同**。

（顺带记一个装置坑：kit GDS 的 precision 是 **1000**，而我们合并后的 GDS 是 **10000**；
第一轮测试全 `rc=4` 且 `.rep` 为 0 字节，原因就是
`ERROR: Rule file precision 10000 is not consistent with database precision 1000`。
**deck 的 PRECISION 必须跟着被读的那个文件走**，这正是他自己脚本注释里记过的同一类坑。）

---

## 2. 残差的精确构成（v5.1，变换后）

```
                Layout    Source
 Ports:            178       178        ← 相等 ✅（上一轮修 GLOBALS 的成果）
 Nets:           12146     12255    *   (−109)
 Instances:         27        13    *   MN (4 pins)   (+14)
                    34        13    *   MP (4 pins)   (+21)
 Total Inst:     19375     19325        (+50)
```

50 条 incorrect nets 的**源侧名字全部落在 `Xu_calib_ctrl`**（`n1089`、`n1224`、
`shadow_weights[18][13]`、`HFSNET_*`…），布局侧无名（`X0/596`、`604`…）。

连接数差：`VDD +934`（14636 vs 13702）、`VSS +14`，其余 38 条各 `+1…+21`。
**VDD 那 +934 与初始器件差（MN +306 / MP +354 ≈ 660）是同一件事的两种量法。**

---

## 3. 另外两条被实测否掉的假设

| 假设 | 检验 | 结果 |
|---|---|---|
| 版图里有网表没有的单元（填充/连接单元是纯物理的） | 对差版图顶层 34 356 次放置 vs 网表 master | **否**：布局独有的 master 只有 `$$via1..via5`（30 730 次过孔放置），**没有任何多余逻辑单元** |
| 那些名字是库里的单元名 | 在 kit CDL(471)/源网表/提取网表里检索 `_sdw2v/_pmp2b/_nand2b/_invv` | **否**：三处都不存在 → 它们是 **Calibre 内部的门级识别结构**，不是单元 |

**这轮我自己的一个工具错误**：第一版"坐标→单元"定位器把 SREF 的 XY 当成 bbox，
而 **SREF 的 XY 只有一个放置原点**，于是 35 个器件全判成"不在任何实例内"。用
"单元自身 bbox + 放置原点（含 R90/R270 交换）"重算后才有结果——但仍有 15 个落在实例外、
2 个落进 `$$via1`，说明镜像/旋转的放置我的模型还没吃准，**所以这一列结论不外推**。

---

## 4. F3：块自身 abstract —— **本版本的写出路径不提供**

这是本轮第二个有结论的项，全部靠**读工具自己的 usage**，不猜拼写：

| 命令 | 存在性 | 实测行为 |
|---|---|---|
| `write_lef_abstract` | **absent** | —— |
| `create_abstract` | EXISTS | 选项有 `-blocks/-all_blocks/-timing_level/-placement/-target_use/-force_recreate`；**在顶层块上调用报 `Error: Could not find any instantiation for the given block(s). (ABS-297)`** —— 它的语义是"**从父层给被子块建 abstract**"，我们的块没有父层 |
| `create_abstract_model` / `abstract_model` | absent | —— |
| `create_boundary` / `set_boundary` / `remove_boundary` | absent | —— |

`write_lef` 的**全部选项**（读 `-help` 得到）：
`[-library] [-design] [-include {cell,tech}] [-properties] [-exclude_layers]
[-slice_polygon] [-version] [-write_additional_viarule] <file>`

**六个变体全部实测**（判据 = 文件里 `^MACRO sar_digi_paper_core` 的条数）：

| 变体 | 字节 | MACRO 总数 | **块自身 MACRO** | PIN |
|---|---|---|---|---|
| `-design <block>`（现用） | 179 596 | 109 | **0** | 630 |
| `-include cell` | 176 050 | 109 | **0** | 630 |
| `-include {cell tech}` | 179 596 | 109 | **0** | 630 |
| `-include tech` | 3 709 | 0 | 0 | 0 |
| `-design sar16_route_paper_core -include cell` | 176 050 | 109 | **0** | 630 |
| `-library <lib> -include cell` | 163 | 0 | 0 | 0 |

并且**库里物理上只有 `design.ndm` 一种 view**（`sar16_route_paper_core/`、`sar_digi_paper_core/`
两个目录下都只有 `design.ndm` + `data_map.*` + `SHADOW_DESIGN_0`），**没有 abstract view 可供导出**。

**结论**：本 FC 版本（W-2024.09-SP3）在"顶层块 + 无父层"的前提下，
**无法用文档化的写出路径产出块自身 abstract**。剩下唯一未试的候选是
**先造一个父层 wrapper 例化本块，再从父层调 `create_abstract`** —— 这是下一步的明确动作，
不是"再猜一个拼写"。

---

## 5. 本轮踩到并记下的坑

1. **`uplevel 1` 在全局作用域 = `bad level "1"`** —— 四个 `write_lef` 变体**一个都没执行**，
   是我核了输出文件（`NOT WRITTEN`）才发现的。**这正是被接手方记忆里记过的同一个坑**，
   说明"守卫失败在放行一侧"这件事在这套工具里是常态。
2. **`fc_shell` 出错后不退出、转而把管道里剩下的 bash 当 Tcl 吃** —— 必须
   `fc_shell -f x.tcl < /dev/null`（上一轮记过，这轮继续遵守）。
3. **deck 的 PRECISION 必须匹配被读文件**（kit 1000 / 我们 10000）。

---

## 6. 下一轮

1. **等库自洽性全量结果**（109 个 master）——若出现 INCORRECT 的单元，
   按"该单元放置数 × 器件差"量化它对 +660 的贡献。
2. **F3 的 wrapper 实验**：造父层例化本块 → `create_abstract -blocks sar_digi_paper_core`。
3. 若 1 全 CORRECT 且 2 不通：残差归因转向**提取侧**（比较同一单元在我们的版图里
   与在 kit 版图里的器件数差）。
4. 交付 README 的 LEF 计数改正（实测 **109 MACRO / 630 PIN**，原文 115/665 / 652 — 待定稿时重数）。
