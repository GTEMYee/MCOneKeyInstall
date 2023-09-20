@echo off
title Minecraft 一键安装 当前路径:%cd%
cd /d %~dp0

:Check
echo %PROCESSOR_ARCHITECTURE%|findstr "arm" >nul&&(goto InvalidArchitecture)
echo %PROCESSOR_ARCHITECTURE%|findstr "32" >nul&&(goto No32Systems)
echo %PROCESSOR_ARCHITECTURE%|findstr "86" >nul&&(goto No32Systems)
echo %cd%|findstr "%systemdrive%" >nul&&(goto DontInstSystemDrive)
reg query "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" >nul 2>nul&&goto exist||goto StartInst

:StartInst
echo 将开始进行下载
echo 如果弹出"Windows 安全警报"窗口请勾选"公用网络"和"专用网络"
echo 保证正常下载
echo.
echo 如果Hello! Minecraft Launcher、Plain Craft Launcher 2不能下载,请使用steam++进行GitHub加速
echo.
echo 若出现 Redirecting to 消息是正常现象,继续等候下载
echo 每一段时间出现 Download Progress Summary 时是下载状态报告
echo 请勿退出窗口
echo.
echo 5秒后继续
echo.
timeout /t 5 /nobreak >nul
title Minecraft 一键安装 当前进行内容:下载 运行路径:%cd%
echo 当前进行内容:
echo 下载 Azul JDKFX 8、Azul JDK 17、Hello! Minecraft Launcher、Plain Craft Launcher 2
echo.
aria2c.exe --no-conf --log-level=info -x4 -s5 -j5 -c -R -d"%cd%" -i".\DownloadItems.txt"
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容:解压缩 运行路径:%cd%
echo ==================
echo.
timeout /t 2 /nobreak >nul
7za.exe x .\Azul-JDKFX8.0.382_X64-Win.zip
7za.exe x .\Azul-JDK17.0.8.1_X64-Win.zip
7za.exe x .\PCLRealase.zip
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容:更正名称 运行路径:%cd%
echo ==================
rename .\zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64 jre-x64
rename .\zulu17.44.53-ca-jdk17.0.8.1-win_x64 JDK17
rename ".\Plain Craft Launcher 2.exe" PlainCraftLauncher2.exe
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容:清理 运行路径:%cd%
del /f /s /q .\Azul-JDKFX8.0.382_X64-Win.zip
del /f /s /q .\Azul-JDK17.0.8.1_X64-Win.zip
del /f /s /q .\PCLRealase.zip
timeout /t 2 /nobreak >nul
reg add "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" /t REG_EXPAND_SZ /d %cd% >nul
echo.
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\HMCL-3.5.5.lnk""):b.TargetPath=""%~dp0HMCL-3.5.5.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Plain Craft Launcher 2.lnk""):b.TargetPath=""%~dp0PlainCraftLauncher2.exe"":b.WorkingDirectory=""%~dp0"":b.Save:close")
goto Success

:InvalidArchitecture
cls
echo 不支持的架构,按任意键退出
pause >nul
exit

:No32Systems
cls
echo 要求64位操作系统!
echo 按任意键退出
pause >nul
exit

:DontInstSystemDrive
cls
echo 禁止在系统分区运行安装!
echo 防止不可控的硬盘空间占用!
echo 按任意键退出
pause >nul
exit

:Success
mkdir .minecraft;PCL
echo 安装完成,按任意键退出
pause >nul
exit

:exist
echo 你已经拥有了 Minecraft 一键安装
echo 按任意键查看该文件夹并退出批处理
pause >nul
start %MCOneKeyInst%
exit