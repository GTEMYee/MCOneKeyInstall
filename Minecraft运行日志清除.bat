@echo off
title Minecraft运行日志清除
echo 如果要用于取证与发送错误报告,请勿继续
echo 按任意键继续清理
pause >nul
attrib -h .\hmcl.json >nul 2>nul
del /f /s /q .\.minecraft\*.log
del /f /s /q .\.minecraft\versions\*.log
del /f /s /q .\.minecraft\versions\*.log.gz
del /f /s /q .\PCL\log*
echo 已完成，按下任意键退出
pause >nul