# AHU Beamer 模板 — 项目规范

## 项目概述

安徽大学 Beamer 演示文稿模板，基于 XeLaTeX + biber 编译，使用自定义主题 `ahutheme.sty`。

## 三层 Input 架构

```
main.tex                              (第1层：入口)
  ├── \input{pages/title}             封面/目录/致谢
  ├── \input{pages/toc}
  │
  ├── \section{节标题}                节声明 + 节头
  │   └── \input{sections/sectionhead/secXX_xxx}
  │           ├── \input{sections/secXX_xxx/subsecYY_zzz}  子节文件
  │           └── ...
  └── ...
```

### 各层职责

| 层级 | 位置 | 职责 |
|------|------|------|
| 第1层 | `main.tex` | 文档类、宏包、元信息、\section{} + 节头引入 |
| 第2层 | `sections/sectionhead/secXX_xxx.tex` | 管理该节所有子节顺序 |
| 第3层 | `sections/secXX_xxx/subsecYY_zzz.tex` | 单个子节内容，一个 \begin{frame}...\end{frame} |

## 命名约定

| 层级 | 前缀 | 示例 |
|------|------|------|
| 节目录 | `secXX_` | `sec1_introduction/` |
| 节头文件 | `secXX_` | `sectionhead/sec1_introduction.tex` |
| 子节文件 | `subsecYY_` | `subsec01_overview.tex` |

编号从 01 开始，两位数。

## 编译命令

```bash
make              # build → clean-build → clean-root → output
make build        # xelatex → biber → xelatex × 2
make xelatex      # 单次 xelatex（不含文献）
make output NAME=xxx  # 输出到 output/xxx.pdf
make clean-build  # 清理 build 辅助文件（保留 PDF）
make clean-all    # 清除所有临时文件 + PDF
```

xelatex 已配置 `-interaction=nonstopmode`，出错即退出。

## 主题功能清单 (ahutheme.sty)

### 颜色系统
- `yantex@main` (56,67,120) — 主蓝，用于标题、块头
- `yantex@light` (224,242,255) — 浅蓝，用于正文背景
- `yantex@dark` (43,51,92) — 深蓝，用于页脚页码
- `block@example` (53,184,108) — 绿色
- `block@alertblock` (167,51,51) — 红色

### 块环境
- `\begin{block}{标题}...\end{block}` — 蓝底
- `\begin{alertblock}{标题}...\end{alertblock}` — 红底
- `\begin{exampleblock}{标题}...\end{exampleblock}` — 绿底

### 列表样式
- `itemize` 三级：square → circle → triangle（主蓝色）
- `enumerate` 三级：蓝底白字方块 → 深蓝底白字圆圈 → 浅底黑字数字
- `description` 描述列表

### 多栏
- `\begin{columns}[T]` + `\column{0.48\textwidth}`
- 配合 block / tabular / tikzpicture / figure 使用

### 数学公式
- 行内 `$...$`、行间 `\[...\]`
- `align`、`matrix`（pmatrix/bmatrix）、`cases`

### 图表
- `\includegraphics`、`subfig`（\subfloat）
- `booktabs` 三线表（\toprule/\midrule/\bottomrule）

### TikZ 预加载库
- `matrix`、`3d`、`positioning`、`arrows.meta`
- `calc`、`decorations.pathreplacing`、`shapes.geometric`
- `fit`、`backgrounds`、`shapes.arrows`

注意：frame 内 TikZ matrix 需加 `ampersand replacement=\&` 并用 `\&` 替代 `&`。

### 引用与文献
- biblatex + biber，国标样式 `gb7714-2015`
- `\cite{key}` 引用，`\printbibliography` 输出
- `citation/references.bib` 存放文献数据库

## 内容编写规则

1. 每个子节文件只包含一个 `\begin{frame}...\end{frame}`
2. `\frametitle` 必须填写，`\framesubtitle` 可选
3. 避免在 columns 内放过多内容导致 Overfull vbox/hbox
4. 使用 `\structure{text}` 标记主色文字，`\alert{text}` 标记警告色文字
5. 不要添加多余注释，保持代码简洁

## 工作流程：添加新节

1. 创建节目录 `sections/secXX_xxx/`
2. 创建子节文件 `sections/secXX_xxx/subsec01_yyy.tex`
3. 创建节头文件 `sections/sectionhead/secXX_xxx.tex`
4. 在 `main.tex` 添加 `\section{标题}\input{sections/sectionhead/secXX_xxx}`
