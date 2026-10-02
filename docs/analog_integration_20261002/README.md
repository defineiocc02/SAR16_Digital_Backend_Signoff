# 2026-10-02 模拟/数字接口核对工件

主结论见 [模拟复现与接口报告](../analog_digital_integration_20261002.md)。原论文、私有完整OA/PDK/仿真网表不在本目录发布。

- `oa_interface_inventory.json`：36个当前schematic的源哈希、读取状态、pins及选定模块连接；源文件前后SHA相同。
- `source_manifest.json`：30个已读文本来源的文件名、长度和SHA；原文在私有审计工作区留存。
- `run_failure_evidence.json`：历史AMS许可证/Spectre解码器错误的源文件行号与去路径摘录。
- `clock_interface_findings.json`：CLKn未驱动及名义跨电压CLK连接的OA/历史网表依据；没有宣称已发生器件损伤。
- `capacitance_estimate.json`：明确底板钳位等假设下的理想网络估算；非MOM模型结果或实测输入电容。
- `interface_check.json`：`make interface`的冻结检查结果。5个正常/故障用例通过；不构成模拟性能或签核通过。

可重新运行 `make interface` 核对公开的端口/位序与源证据；恢复远程原理图后的新提取应另存带哈希快照，不覆盖本次记录。
