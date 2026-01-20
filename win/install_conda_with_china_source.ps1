# Miniconda 安装脚本（中国镜像源）- Windows 版本

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
Write-Host "  Miniconda 安装脚本（中国镜像源）" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 检测系统架构
$ARCH = $env:PROCESSOR_ARCHITECTURE
if ($ARCH -eq "AMD64") {
    $ARCH_SUFFIX = "Windows-x86_64"
} else {
    Write-Host "错误: 不支持的系统架构 $ARCH" -ForegroundColor Red
    exit 1
}

Write-Host "检测到系统架构: $ARCH" -ForegroundColor Green

# Miniconda 版本信息（根据清华镜像站最新版本）
$MINICONDA_VERSION = "25.11.1-1"
$MINICONDA_INSTALLER = "Miniconda3-py313_${MINICONDA_VERSION}-${ARCH_SUFFIX}.exe"
$DOWNLOAD_URL = "https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/${MINICONDA_INSTALLER}"

# 设置下载目录
$DOWNLOAD_DIR = "$env:TEMP"
$INSTALLER_PATH = Join-Path $DOWNLOAD_DIR $MINICONDA_INSTALLER

# 设置安装路径
$INSTALL_PATH = "$env:USERPROFILE\miniconda3"

Write-Host ""
Write-Host "步骤 1/5: 下载 Miniconda 安装包..." -ForegroundColor Yellow
Write-Host "下载地址: $DOWNLOAD_URL" -ForegroundColor Gray

# 检查是否已下载
if (Test-Path $INSTALLER_PATH) {
    Write-Host "安装包已存在，跳过下载" -ForegroundColor Gray
} else {
    try {
        Write-Host "正在下载..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $INSTALLER_PATH -UseBasicParsing
        Write-Host "✓ 下载完成" -ForegroundColor Green
    } catch {
        Write-Host "错误: 下载失败 - $_" -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $INSTALLER_PATH)) {
    Write-Host "错误: 安装包文件不存在" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "步骤 2/5: 安装 Miniconda..." -ForegroundColor Yellow
Write-Host "安装目录: $INSTALL_PATH" -ForegroundColor Gray

try {
    # 静默安装
    $process = Start-Process -FilePath $INSTALLER_PATH `
        -ArgumentList "/S", "/D=$INSTALL_PATH" `
        -Wait -PassThru -NoNewWindow

    if ($process.ExitCode -eq 0) {
        Write-Host "✓ 安装完成" -ForegroundColor Green
    } else {
        Write-Host "错误: 安装失败 (退出码: $($process.ExitCode))" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "错误: 安装过程出错 - $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "步骤 3/5: 配置 Conda 中国镜像源..." -ForegroundColor Yellow

# 将 conda 添加到 PATH
$CONDA_EXE = Join-Path $INSTALL_PATH "Scripts\conda.exe"

if (-not (Test-Path $CONDA_EXE)) {
    Write-Host "错误: 找不到 conda.exe" -ForegroundColor Red
    exit 1
}

try {
    # 初始化 conda（仅当前用户）
    & $CONDA_EXE init powershell

    # 添加清华镜像源
    & $CONDA_EXE config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
    & $CONDA_EXE config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
    & $CONDA_EXE config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
    & $CONDA_EXE config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

    # 设置通道优先级
    & $CONDA_EXE config --set channel_priority flexible

    # 显示channel的URL
    & $CONDA_EXE config --set show_channel_urls yes

    Write-Host "✓ 镜像源配置完成" -ForegroundColor Green
} catch {
    Write-Host "警告: 镜像源配置出现问题，但安装已成功" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "步骤 4/5: 显示当前配置..." -ForegroundColor Yellow
& $CONDA_EXE config --show channels

Write-Host ""
Write-Host "步骤 5/5: 清理安装包..." -ForegroundColor Yellow
try {
    Remove-Item $INSTALLER_PATH -Force
    Write-Host "✓ 清理完成" -ForegroundColor Green
} catch {
    Write-Host "警告: 清理安装包失败" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  安装完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "请关闭并重新打开 PowerShell，然后执行以下命令：" -ForegroundColor Yellow
Write-Host "  conda --version" -ForegroundColor White
Write-Host ""
Write-Host "或者执行以下命令立即生效：" -ForegroundColor Yellow
Write-Host "  & '$INSTALL_PATH\shell\condabin\conda-hook.ps1'" -ForegroundColor White
Write-Host ""
Write-Host "创建 Python 3.14 环境（可选）：" -ForegroundColor Yellow
Write-Host "  conda create -n py314 python=3.14" -ForegroundColor White
Write-Host "  conda activate py314" -ForegroundColor White
Write-Host ""
