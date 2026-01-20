#!/bin/bash

echo "正在配置 Node.js 和 npm 国内镜像源..."

# 1. 配置 nvm 镜像
echo "配置 nvm 镜像源..."
cat >> ~/.bashrc << 'EOF'

# Node.js 国内镜像源配置
export NVM_NODEJS_ORG_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/

EOF