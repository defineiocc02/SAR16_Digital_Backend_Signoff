# 修复 09：hold 结论与口径**已写入机读汇总**（✅ 完成并验证）

**日期**：2026-09-19 ｜ 承接：修复 08（口径裁定 = PT `viol_hold`，三角 1/16/12 = 29）

---

## 1. 修的是哪一处缺口

`RESULT_CURRENT.env`（交付的机读汇总）里与 hold 有关的键**只有** `dc_hold_viols=105.00`
（**综合阶段**的数），**签核 STA 的 hold 结果一个键都没有**。

## 2. 改法（改 `scripts/collect_result.sh`）

新增一段 hold 汇总，**插在脚本输出组 `{ … } > "$OUT"` 内部**，
数据源用脚本自己已经在用的路径 `$P/pnr/reports/sta/sta_pc_summary.txt`：

```sh
for _c in typical slow fast; do
    _l=$(grep -m1 "^STA_RESULT corner=$_c " "$_HLD")
    _v=$(echo "$_l" | sed -n 's/.*viol_hold=\([0-9]*\).*/\1/p')
    _w=$(echo "$_l" | sed -n 's/.*wns_hold=\(-\{0,1\}[0-9.]*\).*/\1/p')
    echo "sta_${_c}_hold_viols=$_v" ; echo "sta_${_c}_hold_wns=$_w"
done
echo "sta_hold_viols_total=$_tot"
echo "hold_caliber=PT_viol_hold_from_sta_pc_summary"
```

**备份**：`scripts/collect_result.sh.bak_holdfix`、`reports/RESULT_CURRENT.env.bak_pre_hold`。

## 3. 修复前后对照（实测）

| | 修复前 | 修复后 |
|---|---|---|
| `RESULT_CURRENT.env` 里的 hold 键 | **只有 `dc_hold_viols=105.00`**（综合阶段） | 见下 |
| 键数 | — | **+8 个** |

修复后实测内容：

```
dc_hold_viols=105.00
sta_typical_hold_viols=1        sta_typical_hold_wns=-0.0320
sta_slow_hold_viols=16          sta_slow_hold_wns=-0.2020
sta_fast_hold_viols=12          sta_fast_hold_wns=-0.0538
sta_hold_viols_total=29
hold_caliber=PT_viol_hold_from_sta_pc_summary
```

**⇒ "hold 结论只存在于 STA 文本报告里"这个交付完整性问题关闭。**

## 4. 过程中我自己错了一次（记录）

第一版把 hold 段**追加到脚本末尾**，落到了 `} > "$OUT"` **外面** ⇒ 键只进了 stdout、
env 文件里没有。**判据是"env 文件里有没有键"，不是"脚本里有没有代码"**——
所以我做了两次测试运行才确认，第二次才真正落进文件。

## 5. 边界

- 口径说明也一并写进 env（`hold_caliber` 键 + 注释），**明确 39 不可复现**；
- **未改任何 STA 报告、未改任何设计文件**；只改了汇总脚本与生成的 env；
- 两个备份都在，回退只需 `cp` 回去。
