#!/bin/bash

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <ANTHROPIC_AUTH_TOKEN>"
    echo "示例: $0 sk-xxx"
    exit 1
fi

KEY="$1"

echo "正在安装 @anthropic-ai/claude-code..."
npm install -g @anthropic-ai/claude-code

if [ $? -ne 0 ]; then
    echo "安装失败！"
    exit 1
fi

echo "安装完成！"
echo "正在配置 ~/.claude/settings.json..."

# 创建目录（如果不存在）
mkdir -p ~/.claude

# 写入配置文件
cat > ~/.claude/settings.json << EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$KEY",
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_MODEL": "glm-4.7",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  },
  "skipDangerousModePermissionPrompt": true
}
EOF

echo "配置完成！"
echo "配置文件已写入: ~/.claude/settings.json"
echo ""
echo "请运行以下命令验证安装："
echo "  claude --version"
