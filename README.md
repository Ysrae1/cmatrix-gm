# cmatrix-gm

以 C / ncurses 实现的 Matrix 字符雨：保留 CMatrix 原模式，并加入 Unimatrix 模式和基于 Gomatrix 下落逻辑的 `cmatrix-gm` 模式。可独立运行，也可嵌入 Neovim 终端区域；不需要预先安装 Neovim、Go 或 Python。

固定版本：`cmatrix-gm-20261017`。支持 Apple Silicon macOS，以及 Windows 的 Ubuntu WSL2 环境。Windows 原生命令行构建不在此版本范围内；WSL2 请使用 UTF-8 终端和支持半角日文的等宽字体。

## 从源码构建

Apple Silicon Mac 先安装 Xcode Command Line Tools 和 Homebrew，再安装依赖：

```sh
xcode-select --install
brew install git pkg-config ncurses
```

Ubuntu / WSL2：

```sh
sudo apt update
sudo apt install -y git build-essential pkg-config libncurses-dev ncurses-term
```

获取固定版本并构建：

```sh
git clone --branch cmatrix-gm-20261017 --depth 1 https://github.com/Ysrae1/cmatrix-gm.git
cd cmatrix-gm
./build-native.sh
./cmatrix-gm --help
./cmatrix-gm
```

构建脚本只编译源码，不自动安装依赖、不修改终端或 Neovim 配置。无需运行 `configure` 或生成 `config.h`。生成的 `cmatrix` 保留原 CMatrix 参数；`cmatrix-uni`、`cmatrix-gm` 两个脚本调用同目录的 `cmatrix-uni-native`。

如果希望加入命令搜索路径，可将以下四个文件一起安装：

```sh
install -d "$HOME/.local/bin"
install -m 755 cmatrix cmatrix-uni-native cmatrix-uni cmatrix-gm "$HOME/.local/bin/"
export PATH="$HOME/.local/bin:$PATH"
```

将最后一行加入所用 shell 的配置文件后，新终端也能找到命令。

## 使用

```sh
cmatrix-gm                         # 默认：独立雨串速度、白/银灰亮头、两档绿色、4 格渐隐尾
cmatrix-gm --intro -t 2             # 已铺开的起始画面，固定 2.5 倍速，播放两秒后退出
cmatrix-gm --length 9:13 --fade 4   # 小型首页区域：显式延长雨串，尾部可从区域外继续进入
cmatrix-gm --fade 8                # 拉长渐隐区；--fade 0 为直接清尾
cmatrix-gm --fps 60                # 仅控制刷新频率，范围 1～120
cmatrix-uni -o -s 98 -l m -a       # 保留 Unimatrix 风格
cmatrix -a -b -u 5 -o              # 保留普通 CMatrix 风格
```

默认字符集为 Gomatrix 的完整 125 个字符：63 个半角日文字符／标点，加 62 个英文字母和数字。`ﾞ`、`ﾟ` 两个浊音符使用空格载体和等价组合字符独占一个单元格绘制，避免终端重绘时向前一格反复叠加；没有移除这两个字符。需要自定义字符集时见 `--help`。

普通模式每条雨串按 30～139 毫秒／格匀速下落，长度参数为 13～21 格（正常可见约 12～20 格）；短窗口默认随高度缩短。`--length MIN:MAX` 可覆盖为 2～128 格，即使长度超过首页高度也能正常清尾。`--intro` 使用同一套逻辑预生成中间帧，然后固定 2.5 倍速播放，不做速度突变；`-t 2` 独立限制实际播放时间。

渐隐按原始绿色亮度乘以尾部曲线，保留深绿／亮绿差别，不改变背景透明度。默认继承终端背景；实际颜色精度取决于终端的真彩色／256 色支持。按 `q`、Esc 或空格退出；`k` 切换日文字符，`b` 恢复完整字符集，`c` 清屏，`+` / `-` 调整刷新频率，`=` 恢复启动时刷新频率。

## 来源与许可

- [CMatrix](https://github.com/abishekvashok/cmatrix)：Chris Allegretta、Abishek V Ashok 及贡献者；GPL-3.0-or-later。完整许可证见 [COPYING](COPYING)，原始说明保留在 [README.upstream.md](README.upstream.md)。
- [Unimatrix](https://github.com/will8211/unimatrix)：William Mannard；本地 C 实现参考固定提交 `dff519f972103f91384f360f270614184de8aa92`，按 GPL-3.0-or-later 分发。
- [Gomatrix](https://github.com/GeertJohan/gomatrix)：Geert-Johan Riemer、Garrett D’Amore；下落调度与字符／颜色逻辑参考固定提交 `cfb8e3310c1f`。其 BSD 2-Clause 版权与完整许可保留在 [LICENSE.gomatrix](LICENSE.gomatrix) 和对应源码中。

本分支整体按 GPL-3.0-or-later 分发；分发二进制时应提供对应完整源码，并保留上述版权、许可和免责声明。固定版本的完整源码随仓库标签发布。
