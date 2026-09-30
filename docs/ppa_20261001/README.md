# PPA 对标与 SRM 时序实验快照

日期：2026-10-01。完整判断、论文口径和发展方向见 [PPA 对标报告](../ppa_paper_comparison_20261001.md)。这些文件是公开脚本的本机运行快照，不是新的 DC/FC/PT 签核结果。

| 文件 | 内容与来源 |
|---|---|
| [netlist_register_inventory.json](netlist_register_inventory.json) | 原 PNR 网表逐层次展开的叶单元数、LEF 面积、寄存器库存；3626 个 cell 的面积和对齐历史 FC 报告 |
| [latency_run.log](latency_run.log) | 仿真器版本响应、12 个相位的 1200 次结果及过早驱动的漏计反例 |
| [latency_result.json](latency_result.json) | 日志解析出的 SRM 延迟范围、实验条件与排除项 |
| [ppa_comparison_numbers.json](ppa_comparison_numbers.json) | 历史报告值、论文原文人工核对的数值与明确标注的条件计算；不代表优化后的 PPA |
| [source_hashes.json](source_hashes.json) | 参与分析的历史工件和公开脚本/testbench 的 SHA-256 |

在仓库根目录运行：

```bash
make check
make ppa
# 非默认安装可指定：make ppa VERILATOR=/path/to/verilator
```

新结果生成到被 Git 忽略的 `build/ppa/`；不会覆盖本目录的历史快照。构建日志在 `build/ppa/latency_build.log`。运行需要 Python 3、Verilator、C++ 编译器和 make；`make check` 还需要 Tcl 和 Bash。GitHub Actions 同样执行这些检查。

分析脚本验证所用历史输入与基线 SHA 一致，检查网表叶单元数和面积对账、相位/样本覆盖及原基线时序。论文数值不是脚本提取所得；其出处为报告中的 DOI、Fig. 15 和相关章节。本仓库不新增发布论文 PDF、原文全文提取或本机私有路径。

实验使用两状态、零延迟的独立 SRM RTL；12 ns 等待只属于本次驱动条件。它不能证明完整 ADC 5 MS/s、模拟噪声/保持窗口、亚稳态/CDC、四状态/SDF 或物理时序闭合。180 个固定参考权重 DFF 和两级快照的数据面积是候选毛收益，原 RTL 没有因此发生修改。
