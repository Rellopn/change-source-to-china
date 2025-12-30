#!/bin/bash

# 备份原文件
echo "备份原 sources.list..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d%H%M%S)

# 获取 Ubuntu 版本代号
VERSION=$(lsb_release -cs)
echo "检测到 Ubuntu 版本: $VERSION"

# 定义源内容
SOURCE_CONTENT="
# 清华大学镜像源
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-security main restricted universe multiverse

# 源码仓库（可选）
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $VERSION-security main restricted universe multiverse
"

# 写入新源
echo "写入清华源配置..."
echo "$SOURCE_CONTENT" | sudo tee /etc/apt/sources.list > /dev/null

# 更新软件包列表
echo "更新软件包列表..."
sudo apt update

echo "完成！已将 APT 源更换为清华大学镜像源。"