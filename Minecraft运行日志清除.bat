@echo off
title Minecraft������־���
echo ���Ҫ����ȡ֤,�����������
echo ���������������
pause >nul
attrib -h .\hmcl.json >nul 2>nul
del /f /s /q .\.minecraft\*.log
del /f /s /q .\.minecraft\versions\*.log
del /f /s /q .\.minecraft\versions\*.log.gz
del /f /s /q .\PCL\log*
echo ����ɣ�����������˳�
pause >nul