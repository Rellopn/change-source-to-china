# Windows APT 源配置说明
#
# 说明: 此脚本对应 Linux 系统的 APT 源配置
# Windows 系统不使用 APT 包管理器，因此不需要配置 APT 源
#
# 如果您需要在 Windows 上使用类似的包管理功能，请使用以下工具之一

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Windows 包管理器说明" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Windows 系统不使用 APT 包管理器。" -ForegroundColor Yellow
Write-Host ""
Write-Host "推荐的 Windows 包管理器:" -ForegroundColor Green
Write-Host ""
Write-Host "1. Winget - Windows 自带（推荐）" -ForegroundColor White
Write-Host "   查看软件: winget search <package>" -ForegroundColor Gray
Write-Host "   安装软件: winget install <package>" -ForegroundColor Gray
Write-Host "   示例: winget install Python.Python.3.14" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Chocolatey - 第三方包管理器" -ForegroundColor White
Write-Host "   安装命令:" -ForegroundColor Gray
Write-Host "   Set-ExecutionPolicy Bypass -Scope Process -Force;" -ForegroundColor Gray
Write-Host "   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;" -ForegroundColor Gray
Write-Host "   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" -ForegroundColor Gray
Write-Host ""
Write-Host "   使用: choco install <package>" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Scoop - 简洁的命令行安装程序" -ForegroundColor White
Write-Host "   安装命令:" -ForegroundColor Gray
Write-Host "   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
Write-Host "   Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression" -ForegroundColor Gray
Write-Host ""
Write-Host "   使用: scoop install <package>" -ForegroundColor Gray
Write-Host ""
Write-Host "如需配置 Winget 为中国镜像，请参考:" -ForegroundColor Yellow
Write-Host "https://learn.microsoft.com/zh-cn/windows/package-manager/winget/" -ForegroundColor Cyan
Write-Host ""
