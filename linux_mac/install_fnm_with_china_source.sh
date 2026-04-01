#!/bin/bash

echo "正在从清华镜像源安装 fnm 并配置 Node.js..."

# 检测系统架构
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH_TYPE="x64"
        ;;
    aarch64|arm64)
        ARCH_TYPE="arm64"
        ;;
    *)
        echo "不支持的架构: $ARCH"
        exit 1
        ;;
esac

# 检测操作系统
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# fnm 版本
FNM_VERSION="1.38.1"

# 1. 从清华镜像源下载 fnm
echo "正在从清华镜像源下载 fnm v${FNM_VERSION}..."
FNM_URL="https://mirrors.tuna.tsinghua.edu.cn/github-raw/Schniz/fnm/master/fnm-${OS}-${ARCH_TYPE}.zip"
TEMP_DIR=$(mktemp -d)

cd "$TEMP_DIR" || exit 1

if command -v wget &> /dev/null; then
    wget -q "$FNM_URL" -O fnm.zip
elif command -v curl &> /dev/null; then
    curl -sL "$FNM_URL" -o fnm.zip
else
    echo "错误: 需要 wget 或 curl"
    exit 1
fi

# 解压并安装
echo "正在安装 fnm..."
unzip -q fnm.zip
mkdir -p ~/.local/bin
mv fnm ~/.local/bin/
chmod +x ~/.local/bin/fnm

# 清理临时文件
cd ~ || exit 1
rm -rf "$TEMP_DIR"

# 2. 配置环境变量
echo "配置 fnm 环境变量..."
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

# 检查是否已配置
if ! grep -q 'FNMS_DIR\|fnm env' "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'EOF'

# fnm 配置
export FNMS_DIR="$HOME/.local/share/fnm"
export PATH="$HOME/.local/bin:$PATH"
eval "$(fnm env --shell bash)"
EOF
    echo "已添加 fnm 配置到 $SHELL_RC"
fi

# 确保 PATH 生效
export PATH="$HOME/.local/bin:$PATH"
export FNMS_DIR="$HOME/.local/share/fnm"
eval "$(fnm env --shell bash)"

# 3. 配置 fnm 使用清华镜像源
echo "配置 fnm Node.js 镜像源..."
export FNM_NODEJS_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"

# 将镜像源配置写入 shell 配置文件
if ! grep -q 'FNM_NODEJS_MIRROR' "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'EOF'
# fnm Node.js 镜像源配置
export FNM_NODEJS_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"
EOF
fi

# 4. 安装 Node.js v24 作为默认版本
echo "正在安装 Node.js v24..."
fnm install v24 --mirror="$FNM_NODEJS_MIRROR"
fnm use v24
fnm default v24

# 验证安装
echo ""
echo "安装完成！"
echo "Node.js 版本: $(node -v)"
echo "npm 版本: $(npm -v)"

# 5. 配置 npm 使用清华镜像源
echo ""
echo "配置 npm 使用清华镜像源..."
npm config set registry https://mirrors.tuna.tsinghua.edu.cn/npm/

# 验证 npm 源配置
echo "npm 源已设置为: $(npm config get registry)"

echo ""
echo "======================================"
echo "fnm 安装完成！"
echo "请运行以下命令使配置生效："
echo "  source $SHELL_RC"
echo "或者重新打开终端"
echo "======================================"
