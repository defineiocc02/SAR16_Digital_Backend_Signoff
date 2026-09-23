# 独立核查 V2 第十三轮：**LUT 生成脚本不在交付件里**——一个可复现性缺陷

**方法**：在**整个 `/home/<user>`** 范围内找 `gen/gen_srm_lut.py`（RTL 注释里点名的那支脚本），
每一条搜索都记录结果，避免"没找到就宣称缺失"这种抢跑。

---

## 1. 搜索证据（逐条，含搜索范围）

| 搜索 | 范围 | 结果 |
|---|---|---|
| A | `find /home/<user> -maxdepth 7 -name gen_srm_lut.py` | **无** |
| B | `find /home/<user>/sar16_work -maxdepth 7 -name '*srm_lut*'` | **无** |
| C | `find <project> -maxdepth 4 -type d -name gen` | **无 `gen/` 目录** |
| D | 项目内所有 `*.py` 提及 `erfinv` / `srm_lut` / `SIGMA_Q8` | **无** |
| E | 整个 `/home/<user>` 下所有 `*.py` 提及 `erfinv` | **无** |
| F | 项目顶层目录清单 | **没有 `gen/`** |

## 2. 而 RTL 里有**三处**点名这支脚本

```
srm_residue_lut.sv:114   //  python gen/gen_srm_lut.py --n 22 --sigma-uv <IRN> --lsb-uv <LSB>
srm_residue_lut.sv:209   $error("srm_residue_lut: SIGMA_Q8=%0d does not match the baked table
                          (LUT_SIGMA_Q8=%0d). Regenerate with gen/gen_srm_lut.py;
                          do not just change the parameter.")
srm_residue_estimator.sv:70   // v4.0 exposes SIGMA_Q8, DECISION_COUNT and RES_FRAC, and
                              // gen/gen_srm_lut.py regenerates the table
srm_residue_estimator.sv:79   //  -> python gen/gen_srm_lut.py --n 22 --sigma-uv 59.1 --lsb-uv 80
srm_residue_estimator.sv:201  //  python gen/gen_srm_lut.py --n 22 --sigma-uv 59.1 --lsb-uv 80
```

**其中 `srm_residue_lut.sv:209` 是一条 elaboration 期 `$error`，它的提示语就是
「用 `gen/gen_srm_lut.py` 重新生成；不要只改参数」。**

**⇒ 交付的 RTL 让读者去找一支交付里不存在的脚本。**

## 3. 这条缺陷的实际后果

1. **表内容无法重生成**：第 19 轮实测该表与论文式 `sigma·Φ⁻¹(cnt/N)`（sigma = 0.5 LSB）
   **系统性偏离**，最大 **22 Q8（≈0.086 LSB）@ cnt=1**。
   **偏离的原因本来只能靠生成脚本裁定——现在裁定不了。**
2. **不可审计**：一个硬编码表 + 缺失的生成器 = 读者只能"相信"这张表。
   而它恰恰是 SRM 估计器输出 `residue_o` 的**全部数值来源**。
3. **不可复现**：即使拿到同样的 RTL，也无法验证表是否被改过——
   交付里**没有第二份独立来源**可比对。

## 4. 这一轮的结论（严格按证据）

| 项 | 结论 |
|---|---|
| `gen/gen_srm_lut.py` 是否在交付件里 | **不在**（A–F 六路搜索，范围含整个 home） |
| RTL 是否引用它 | **引用 3 处，含一条 `$error` 提示** |
| 表是否可由交付件重生成 | **不能** |
| 表与论文式偏离的原因 | **因此无法裁定** |
| RTL 对表的使用是否正确 | **逐位正确**（第 19 轮，`cnt=7 → −58` 实测 −58） |
| 计数路径 | **精确吻合**（第 15 轮） |

## 5. 给交付方的整改项（新增）

> **把 `gen/gen_srm_lut.py` 放进交付件**，并在文档里给出表的重生成命令与
> **重生成后与交付 RTL 表体的逐项比对结果**（证明二者一致）。
> 在此之前，`residue_o` 的数值**只能被"读到"，不能被核对**。

## 6. 本轮自我审计

- 上一轮我说"表内容与论文式系统性偏离"——**那是测量，本轮不重复声明，只补充其可裁定性**；
- 本轮**没有**说"表是错的"：**不知道**生成式，就**不能说**表错；
  能说的是 **"偏离存在，且交付件不足以裁定它是不是错"**。
- 搜索做了**六路、跨整个 home**，不是只在项目里找一遍就下结论。
