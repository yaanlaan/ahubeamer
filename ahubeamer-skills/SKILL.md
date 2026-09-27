# AHU Beamer 模板 — 项目规范

## 项目概述

安徽大学 Beamer 演示文稿模板，基于 XeLaTeX + biber 编译，采用 16:9 宽屏画幅，使用自定义主题 `ahutheme.sty`。

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
| 第1层 | `main.tex` | 文档类 (`10pt,aspectratio=169`)、宏包、元信息、\section{} + 节头引入 |
| 第2层 | `sections/sectionhead/secXX_xxx.tex` | 管理该节所有子节的引入与排序 |
| 第3层 | `sections/secXX_xxx/subsecYY_zzz.tex` | 单个子节内容，一个完整的 \begin{frame}...\end{frame} |

## 命名约定

| 层级 | 前缀 | 示例 |
|------|------|------|
| 节目录 | `secXX_` | `sec1_introduction/` |
| 节头文件 | `secXX_` | `sectionhead/sec1_introduction.tex` |
| 子节文件 | `subsecYY_` | `subsec01_overview.tex` |

编号从 01 开始，采用两位数字。

## 编译命令

```bash
make              # build → clean-build → clean-root → output
make build        # xelatex → biber → xelatex × 2
make xelatex      # 单次 xelatex（不含文献处理，适合快速预览）
make output NAME=xxx  # 输出到 output/xxx.pdf
make clean-build  # 清理 build 辅助文件（保留 PDF）
make clean-all    # 清除所有临时文件 + PDF
```

xelatex 已配置 `-interaction=nonstopmode`，出错即自动退出。

## 主题功能清单 (ahutheme.sty)

### 画幅与页面边距
- 采用 `aspectratio=169`（16:9 现代宽屏画幅）。
- 页边距设为 `text margin left=0.8cm, text margin right=0.8cm`。

### 字体设置
- 西文字体：主体使用 Arial，正文细节使用 Times New Roman，代码等宽使用 Consolas。
- 中文字体：微软雅黑（`Microsoft YaHei`）与黑体（`SimHei`），均配置 `[AutoFakeBold=2, AutoFakeSlant=0.2]` 消除缺失斜体警告。
- 数学字体：公式采用衬线体 `\usefonttheme[onlymath]{serif}`。

### 颜色系统
- `yantex@main` (56, 67, 120) — 主深蓝，用于标题、主色块头、强调文字
- `yantex@light` (224, 242, 255) — 浅蓝色，用于正文块背景
- `yantex@dark` (43, 51, 92) — 深蓝色，用于页脚页码与顶栏
- `block@example` (53, 184, 108) — 绿色，用于示例块与代码字符串
- `block@alertblock` (167, 51, 51) — 红色，用于警告块与重点提示

### 块环境
- `\begin{block}{标题}...\end{block}` — 蓝底白字头
- `\begin{alertblock}{标题}...\end{alertblock}` — 红底白字头
- `\begin{exampleblock}{标题}...\end{exampleblock}` — 绿底白字头

### 列表样式
- `itemize` 三级：square → circle → triangle（统一主蓝色）
- `enumerate` 三级：蓝底白字方块 → 深蓝底白字圆圈 → 浅底黑字数字
- `description` 描述列表环境

### 多栏布局
- `\begin{columns}[T]` + `\column{0.48\textwidth}`
- 配合 block / tabular / tikzpicture / figure 使用

### 数学公式
- 行内 `$...$`、行间 `\[...\]`
- `align`、`matrix`（pmatrix/bmatrix）、`cases`

### 图表
- `\includegraphics`、`subfig`（\subfloat）
- `booktabs` 三线表（\toprule / \midrule / \bottomrule）

### TikZ 预加载库
- `matrix`、`3d`、`positioning`、`arrows.meta`
- `calc`、`decorations.pathreplacing`、`shapes.geometric`
- `fit`、`backgrounds`、`shapes.arrows`

注意：frame 内 TikZ matrix 需加 `ampersand replacement=\&` 并用 `\&` 替代 `&`。

### 代码高亮 (listings)
- 内置定制 `ahustyle` 样式，语法关键字契合安大蓝配色。
- 包含代码块的 frame 必须在声明时添加 `[fragile]` 参数：`\begin{frame}[fragile]`。

### 动态展示动画 (Overlay)
- 支持 `<+->` 逐步揭示列表与 `\pause` 分步停顿。
- 支持 `\alert<+>{}` 配合时间轴进行动态视觉高亮聚焦。

### 引用与文献
- biblatex + biber，国标样式 `gb7714-2015`。
- `\cite{key}` 进行正文引用，`citation/references.bib` 存放文献条目。
- 文献列表输出时**必须使用 `\printbibliography[heading=none]`**，以避免在 Beamer 顶栏重复注册 Section 导航条目。

### 三重水印设置与规范
1. **背景底纹水印**：`assets/background.pdf`，带 `0.88` 不透明度白色遮罩，在 `ahutheme.sty` 中可通过注释 `\setbeamertemplate{background}{...}` 关闭。
2. **顶栏右上角 Logo**：`assets/logo.png`，在 `ahutheme.sty` 的 `frametitle` 模板中控制。
3. **右下角原生 Logo**：`assets/logo2.png`，在 `main.tex` 中通过 `\logo{...}` 控制。

### 页面设计规范
1. **封面页 (`pages/title.tex`)**：必须包含 `[plain]` 并局部隐藏 `headline` 与 `footline`，避免底栏页码暴露。
2. **目录页 (`pages/toc.tex`)**：局部抑制 `headline`，保持版面清洁。
3. **致谢页 (`pages/thanks.tex`)**：必须使用 `[plain]` 并隐藏页眉页脚。
4. 每个正文子节文件只包含一个 `\begin{frame}...\end{frame}`，避免 Overfull vbox 垂直溢出。

## 工作流程：添加新节

1. 创建节目录 `sections/secXX_xxx/`
2. 创建子节文件 `sections/secXX_xxx/subsec01_yyy.tex`
3. 创建节头文件 `sections/sectionhead/secXX_xxx.tex`（在其中 \input 各子节）
4. 在 `main.tex` 添加 `\section{标题}\input{sections/sectionhead/secXX_xxx}`
