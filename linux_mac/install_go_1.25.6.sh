#!/bin/bash

# Go 1.23.6 一键安装脚本

# 1. 删除旧版本（如果存在）
sudo rm -rf /usr/local/go

# 2. 解压新版本
sudo tar -C /usr/local -xzf ~/go1.25.6.linux-amd64.tar.gz

# 3. 配置环境变量
echo '' >> ~/.bashrc
echo '# Go 环境变量配置' >> ~/.bashrc
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> ~/.bashrc
echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.bashrc

# 4. 使环境变量生效
source ~/.bashrc

# 5. 配置 Go 代理（使用 go env -w）
go env -w GOPROXY=https://goproxy.cn,direct

# 6. 配置其他推荐的 Go 环境
go env -w GO111MODULE=on
go env -w GOSUMDB=sum.golang.google.cn

# 7. 验证安装
echo "正在验证 Go 安装..."
go version
echo ""
echo "GOROOT: $GOROOT"
echo "GOPATH: $GOPATH"
echo "GOPROXY: $(go env GOPROXY)"
echo ""
echo "✓ Go 安装完成！"
