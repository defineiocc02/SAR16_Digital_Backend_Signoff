# 2026-10-02 复核冻结结果

入口：[原理/功能综述](../rtl_principle_review_20261002.md)、[校准详解](calibration_analysis.md)、[SRM/LUT详解](srm_analysis.md)、[综合资源详解](synthesis_analysis.md)。本目录冻结本次成功复现的结果，不覆盖前一轮数据或原始 evidence。

| 文件 | 来源与范围 |
|---|---|
| `review_run.log` / `review_result.json` | `tools/run_rtl_review.py`；7 个首目标校准、3 个协议边界、2 个格式实验，原始 leaf RTL、外部端口驱动、两状态零延迟；已知局限复现成功，不是修复成功 |
| `principle_numbers.json` | `tools/analyze_rtl_principles.py`；实际 23 项 LUT 的精确 Binomial 枚举、降精度偏置、端点舍入、决策相关示例、207352 校准状态动作周期公式 |
| `synthesis_inventory.json` / `synthesis_inventory_run.log` | `tools/inventory_synthesis.py`；固定 PNR 网表+LEF，对账层级/寄存器/库原语、门控、clock/reset 逻辑连接、DC 路径；未启动综合 |
| `source_hashes.json` | 实验与库存的输入/工具 SHA-256，原 evidence 另受 baseline manifest 锁定 |

在仓库根目录运行 `make review`，最新结果写入 `build/rtl_review/`。约 1 MB 的 `synthesis_leaf_inventory.json` 在运行时生成，用于逐实例定位，不重复冻结。编译/lint 日志也在 build 目录；本目录公开运行摘要。

本次本地模拟器为 Verilator 5.49，`--version` 为 `rev vUNKNOWN-built20260516-4e853d8`，日志保存该原始版本字符串；C++20、assertion 已启用。CI 另用 Ubuntu 提供的 Verilator 复现，不要求日志 wall time 或版本字符串逐字相同。

所有统计使用明确的理想 noise/offset/held-residue 假设，不是模拟电路验证。首目标实验不覆盖完整非二进制 CDAC；完整模拟 FFT/INL/DNL、亚稳态、四状态、SDF、顺序形式等价、活动功耗和物理签核均未完成。详见每份报告的证据范围。
