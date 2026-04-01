#!/bin/bash

echo "正在安装 fnm..."

# 使用官方安装脚本
curl -fsSL https://fnm.vercel.app/install | bash

# 配置环境变量
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

echo ""
echo "======================================"
echo "fnm 安装完成！"
echo "请运行以下命令使配置生效："
echo "  source $SHELL_RC"
echo "或者重新打开终端"
echo "======================================"
