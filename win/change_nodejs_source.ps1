# Node.js 和 npm 国内镜像源配置脚本

# 检查 PowerShell 执行策略
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($executionPolicy -eq "Restricted") {
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host "  错误: PowerShell 执行策略限制" -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "当前执行策略: Restricted (不允许运行脚本)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请执行以下命令允许运行脚本:" -ForegroundColor Cyan
    Write-Host "  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
    Write-Host ""
    Write-Host "执行后，请重新运行此脚本。" -ForegroundColor Yellow
    Write-Host ""
    exit 1
} elseif ($executionPolicy -eq "Undefined" -or $executionPolicy -eq "Default") {
    Write-Host "检测到执行策略未设置或为默认值，设置为 RemoteSigned..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "✓ 执行策略已设置为 RemoteSigned" -ForegroundColor Green
    } catch {
        Write-Host "警告: 自动设置执行策略失败，但脚本将继续尝试运行" -ForegroundColor Yellow
    }
}

Write-Host "当前执行策略: $executionPolicy" -ForegroundColor Gray
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  配置 Node.js 和 npm 国内镜像源" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 1. 配置 npm 镜像源
Write-Host ""
Write-Host "步骤 1/2: 配置 npm 镜像源..." -ForegroundColor Yellow
npm config set registry https://registry.npmmirror.com

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ npm 镜像源配置完成" -ForegroundColor Green
    $registry = npm config get registry
    Write-Host "当前镜像源: $registry" -ForegroundColor Gray
} else {
    Write-Host "✗ npm 镜像源配置失败" -ForegroundColor Red
}

# 2. 配置 yarn 镜像源（如果已安装）
Write-Host ""
Write-Host "步骤 2/2: 检测并配置 Yarn 镜像源..." -ForegroundColor Yellow
$yarnExists = Get-Command yarn -ErrorAction SilentlyContinue

if ($yarnExists) {
    yarn config set registry https://registry.npmmirror.com
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Yarn 镜像源配置完成" -ForegroundColor Green
        $yarnRegistry = yarn config get registry
        Write-Host "当前镜像源: $yarnRegistry" -ForegroundColor Gray
    } else {
        Write-Host "✗ Yarn 镜像源配置失败" -ForegroundColor Red
    }
} else {
    Write-Host "Yarn 未安装，跳过 Yarn 镜像源配置" -ForegroundColor Gray
    Write-Host "如需安装 Yarn，执行: npm install -g yarn" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "验证配置:" -ForegroundColor Yellow
Write-Host "  npm config get registry" -ForegroundColor White
Write-Host ""
Write-Host "恢复官方源（如需要）:" -ForegroundColor Yellow
Write-Host "  npm config set registry https://registry.npmjs.org/" -ForegroundColor White
Write-Host ""
Write-Host "使用 nrm 工具管理镜像源（可选）:" -ForegroundColor Yellow
Write-Host "  npm install -g nrm" -ForegroundColor White
Write-Host "  nrm ls" -ForegroundColor White
Write-Host "  nrm use taobao" -ForegroundColor White
Write-Host ""
