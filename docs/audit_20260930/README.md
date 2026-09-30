# 本轮静态复核与测试证据

日期：2026-09-30；输入基线 `537cd6d32949789fc129b5e1d6f00d77864b53ec`。原始 evidence 未修改。此目录记录公开检查，不包含私有主机/PDK/许可证路径。

| 文件 | 内容与边界 |
|---|---|
| [repository_check.json](repository_check.json) | 161 文件 SHA-256、126 Python/118 Bash 语法、LUT 12/23、历史 STA/DRC/LVS/PG 摘要重解析；`NOT_CLOSED` 保持可见 |
| [rtl_lint.txt](rtl_lint.txt) | 四份默认设计 RTL 的顶层 lint，27 warnings；不是零警告通过或 27 个功能错误 |
| [smoke_result.json](smoke_result.json)、[smoke_run.txt](smoke_run.txt) | 两状态、零延迟 RTL 166 检查通过；校准两轮各 14 次发布，仅验协议 |
| [gds_layers.txt](gds_layers.txt)、[gds_ports.txt](gds_ports.txt) | 交付 GDS 顶层几何与标签重解析；不证明 PG/LVS 或全层次密度 |
| [lut_invalid_inputs.json](lut_invalid_inputs.json) | 六组非法/溢出配置均在输出表之前以非零码拒绝 |

复现入口：仓库根目录执行 `make check`、`make smoke`。Tcl 命令错误传播验证由 `tests/check_sdc.tcl` 执行，11 场景通过；没有运行真实 Fusion Compiler。

本轮 Verilator CLI 版本输出为 `rev vUNKNOWN-built20260516-4e853d8`，仿真汇总显示 5.49。新的构建会使用调用者的 Verilator，warning 数可能随版本变化。冒烟 runner 保留 build/run 日志和成功标记；CI 使用 Ubuntu 的公开工具重新运行。

SRM 日志中的 160 ns 是固定时钟、测试 arm 等待下“任务请求到观察 done”的值，不是最小延迟或连续 5 MS/s 验收结果。校准的 207350 是每轮 TB 等待循环计数，不与旧文档不同起止口径的 cycle 计数混用。

没有本轮商业 EDA、四状态/X、SDF、CDC/RDC、校准模拟数值、ENOB/SNDR 或最终物理签核测试结果。
