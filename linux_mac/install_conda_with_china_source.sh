#!/bin/bash

echo "========================================="
echo "  Miniconda 安装脚本（中国镜像源）"
echo "========================================="

# 检测系统架构
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    ARCH_SUFFIX="Linux-x86_64"
elif [ "$ARCH" = "aarch64" ]; then
    ARCH_SUFFIX="Linux-aarch64"
elif [ "$ARCH" = "arm64" ]; then
    ARCH_SUFFIX="MacOSX-arm64"
else
    echo "错误: 不支持的系统架构 $ARCH"
    exit 1
fi

echo "检测到系统架构: $ARCH"

# Miniconda 版本信息（根据清华镜像站最新版本）
MINICONDA_VERSION="25.11.1-1"
MINICONDA_INSTALLER="Miniconda3-py313_${MINICONDA_VERSION}-${ARCH_SUFFIX}.sh"
DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/${MINICONDA_INSTALLER}"

# 进入临时目录
cd /tmp

echo ""
echo "步骤 1/5: 下载 Miniconda 安装包..."
echo "下载地址: $DOWNLOAD_URL"

if [ -f "$MINICONDA_INSTALLER" ]; then
    echo "安装包已存在，跳过下载"
else
    if command -v wget &> /dev/null; then
        wget "$DOWNLOAD_URL" -O "$MINICONDA_INSTALLER"
    elif command -v curl &> /dev/null; then
        curl -o "$MINICONDA_INSTALLER" "$DOWNLOAD_URL"
    else
        echo "错误: 需要安装 wget 或 curl 才能下载"
        exit 1
    fi
fi

if [ ! -f "$MINICONDA_INSTALLER" ]; then
    echo "错误: 下载失败"
    exit 1
fi

echo "✓ 下载完成"
echo ""
echo "步骤 2/5: 安装 Miniconda..."
echo "安装目录: $HOME/miniconda3"

# 静默安装
bash "$MINICONDA_INSTALLER" -b -p "$HOME/miniconda3"

if [ $? -ne 0 ]; then
    echo "错误: 安装失败"
    exit 1
fi

echo "✓ 安装完成"
echo ""
echo "步骤 3/5: 配置 Conda 中国镜像源..."

# 初始化 conda
$HOME/miniconda3/bin/conda init bash

# 添加清华镜像源
$HOME/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
$HOME/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
$HOME/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
$HOME/miniconda3/bin/conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

# 设置通道优先级
$HOME/miniconda3/bin/conda config --set channel_priority flexible

# 显示channel的URL
$HOME/miniconda3/bin/conda config --set show_channel_urls yes

echo "✓ 镜像源配置完成"
echo ""
echo "步骤 4/5: 显示当前配置..."
$HOME/miniconda3/bin/conda config --show channels

echo ""
echo "步骤 5/5: 清理安装包..."
rm -f "$MINICONDA_INSTALLER"
echo "✓ 清理完成"

echo ""
echo "========================================="
echo "  安装完成！"
echo "========================================="
echo ""
echo "请执行以下命令使 conda 生效："
echo "  source ~/.bashrc"
echo ""
echo "或者重新打开终端。"
echo ""
echo "验证安装："
echo "  conda --version"
echo ""
echo "创建 Python 3.14 环境（可选）："
echo "  conda create -n py314 python=3.14"
echo "  conda activate py314"
echo ""
