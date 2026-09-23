# 修复 10：**为什么不在这轮无人值守地重跑 P&R**（一个"不做"的决定，附受控步骤）

**日期**：2026-09-19 ｜ **性质**：风险判断，不是技术障碍

---

## 1. 障碍是什么：脚本里**硬编码了原工程路径**

```tcl
# scripts/fc_pnr_paper_core.tcl
set PRJ /home/<user>/sar16_work/proj_paper_core      <-- 硬编码
```

而 stage 脚本开头就是：

```bash
# scripts/run_pnr_paper_core.sh
rm -rf "$PRJ/pnr"
```

**⇒ 在副本工程里直接跑，`rm -rf` 仍然指向原工程的 `pnr/`。**
要安全重跑，必须**先把副本里的路径全部替换掉**（tcl 与 sh 都要），
**并且在跑之前验证替换干净**（`grep -c proj_paper_core` 必须为 0）。

## 2. 为什么我不在这轮无人值守地做

| 风险 | 后果 |
|---|---|
| 替换漏掉一处（tcl 里 PRJ 被引用多次） | **`rm -rf` 打掉原工程 `pnr/`** |
| 原工程 `pnr/` 里不只是产物 | 还含 FC 数据库 `sar16_pnr_paper_core/`（`lib.ndm` 等）——**丢了就得从头重跑整条 P&R** |
| 我的本地证据副本 | `evidence/rpt_v51/` 只有 GDS/LEF/网表/SPEF/报告，**没有 ndm 数据库**，救不回来 |

**⇒ 这是一条"错了就不可逆"的操作。在没有余量盯着它跑完并核验的情况下，
不做，比做了再补救更负责。**
（若只是产物丢失，`reproduce_all.sh` 能重跑；但**交付库数据库**丢失属于另一回事。）

## 3. 受控步骤（有人看着时照此执行）

```bash
set -e
SRC=/home/<user>/sar16_work/proj_paper_core
DST=/home/<user>/sar16_work/fix_tie

# 1) 复制工程（含 pnr 库，约 224 MB）
rm -rf "$DST"; cp -a "$SRC" "$DST"

# 2) 把副本里的硬编码路径全部改到副本
sed -i "s|$SRC|$DST|g" "$DST/scripts/fc_pnr_paper_core.tcl"
sed -i "s|$SRC|$DST|g" "$DST/scripts/run_pnr_paper_core.sh"

# 3) 【硬门禁】替换必须干净，否则立刻停
if grep -q "$SRC" "$DST/scripts/fc_pnr_paper_core.tcl" \
   || grep -q "$SRC" "$DST/scripts/run_pnr_paper_core.sh"; then
    echo "STOP: 副本脚本里仍有原工程路径，不能跑"; exit 1
fi
if [ ! -d "$DST/pnr" ]; then echo "STOP: 副本里没有 pnr，复制不完整"; exit 1; fi
echo "GATE OK: 原工程 $SRC 不会被打到"

# 4) 应用修复补丁（见 修复05）：在 link_block 之后绑定 tie 单元
#    connect_tie_cells -tie_high_lib_cell sar16_smic18_6lm_v4/TIEHI \
#                      -tie_low_lib_cell  sar16_smic18_6lm_v4/TIELO
#    set_app_options -name compile.flow.tie_unused_hier_inputs_to_constants -value false

# 5) 跑副本
cd "$DST" && bash scripts/run_pnr_paper_core.sh
```

**第 3 步是硬门禁**：只要它不通过就**不能**进第 5 步。

## 4. 跑完要核的四条（任一不过就是没修好）

| # | 判据 | 目标 | 修复前 |
|---|---|---|---|
| 1 | 副本网表 `grep -c HFSNET` | **0** | 1841 |
| 2 | LEC 日志 `FM-399` 实现侧无驱动网 | **0** | 5 |
| 3 | 门级仿真复位序列后 `busy` | **抬起** | 恒 0 |
| 4 | LVS | 短路 0、端口 178 | 已达标 |

**注意**：判据 1–2 只需 P&R；判据 3 需要再跑一次自写门级仿真；判据 4 需要再跑 LVS。
**四条都过之前，不得宣称复位问题已修好。**

## 5. 这一轮的实际产出

- 一份**带硬门禁的受控执行步骤**（§3）；
- 一个**明确的风险判断**（§2），以及"为何不在无人值守下做"的理由；
- **未执行任何 P&R，未改动原工程任何文件。**
