@echo off
setlocal enabledelayedexpansion
title Minecraft 一键安装 当前路径:%cd%
cd /d %~dp0

:ProgramFileSet
set ariac=%cd%\aria2c.exe
set zipa=%cd%\7za.exe
set FolderKwordRen=%cd%\FolderKeywordRename.exe
set downloaditems=%cd%\downloaditems.txt

:Check
echo %PROCESSOR_ARCHITECTURE%|findstr "arm" >nul&&(goto InvalidArchitecture)
echo %PROCESSOR_ARCHITECTURE%|findstr "32" >nul&&(goto No32Systems)
echo %PROCESSOR_ARCHITECTURE%|findstr "86" >nul&&(goto No32Systems)
echo %cd%|findstr "%systemdrive%" >nul&&(goto DontInstSystemDrive)
reg query "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" >nul 2>nul&&goto exist||goto Disclaimer

:Disclaimer
title Minecraft 一键安装 当前进行内容: 免责声明 运行路径: %cd%
echo 您需要保证一盘至少两区 (只算分配驱动器号)
echo 若只有一盘一区,您提交了 issue,我们不会受理,但会引导您如何一盘两区
echo 若有多盘,各盘各分一区,则不会涉及该问题
pause & cls

:tips
title Minecraft 一键安装 当前进行内容: 提示 运行路径: %cd%
echo 如果 Hello! Minecraft Launcher、Plain Craft Launcher 2 不能下载,请在之后填写代理
echo 若没有代理,则使用 Steam++ 进行 GitHub 加速,但速度不能与代理相比
pause >nul & pause & echo. & echo.

:choosedir
title Minecraft 一键安装 当前进行内容: 切换下载文件夹 下载路径: %cd%
echo 在此输入要切换的目录,若不输入直接回车则会保持当前目录 & echo 快速输入? 在资源管理器中将文件夹拖入本窗口即可
set /p "target=设置路径: "
if "%target%"=="" (echo 保持当前目录：%cd%) else (if exist "%target%\" (pushd "%target%" 2>nul & if errorlevel 1 (echo 错误：无法访问目录 "%target%" & goto choosedir ) & echo 已切换到：%cd% ) else (echo 错误：目录 "%target%" 不存在 & goto choosedir ))
title Minecraft 一键安装 当前进行内容: 代理设置 下载路径: %cd%

:Setproxy
echo. & echo 如果你拥有代理,在下方写下代理服务器的地址,用于为 GitHub 下载增速 & echo 由于未测试过socks代理协议,当前版本暂时只能填入 http 代理 & echo 带不带协议均可,例如 10.15.1.12:7890,IP地址要和端口一起写 & echo 若没有则回车键跳过,不影响下载
set /p "proxy=在此输入代理地址: "

:ProxyUsrPasswd
echo. & echo 如果该代理要求用户名和密码,在此输入 & echo 通常情况下,代理工具不具备用户名和密码的设置 & echo 若没有则回车跳过即可,不影响下载器运行
set /p "proxyusr=在此输入代理用户名: " & set /p "proxypasswd=在此输入代理对应用户名的密码: "

:StartInst
title Minecraft 一键安装 当前进行内容: 下载 下载路径: %cd% & echo.
echo 下载正在准备当中
echo 如果弹出"Windows 安全警报"窗口请勾选"公用网络"和"专用网络"
echo 保证正常下载
echo.
echo 若出现 Redirecting to 消息是正常现象,继续等候下载
echo 每一段时间出现 Download Progress Summary 时是下载状态报告
echo 请勿退出窗口,否则会终止
echo.
echo 5秒后继续
timeout /t 5 /nobreak >nul
echo. & echo 当前进行内容:
echo 下载 Azul jre 8 fx、Azul JDK 17、Azul JDK 21、Azul JDK 25、
echo Hello! Minecraft Launcher、Plain Craft Launcher 2
echo.
%ariac% --file-allocation=none --all-proxy=%proxy% --all-proxy-user=%proxyusr% --all-proxy-passwd=%proxypasswd% --no-conf --log-level=info --max-connection-per-server=4 --split=2 --max-concurrent-downloads=5 --continue=false -R --dir="%cd%" --input-file=%downloaditems%
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容: 解压缩 运行路径: %cd%
echo ==================
echo.
timeout /t 2 /nobreak >nul
start /wait %zipa% x .\Azul-JDKFX8_X64-Win.zip
start /wait %zipa% x .\Azul-JDK17_X64-Win.zip
start /wait %zipa% x .\Azul-JDK21_X64-Win.zip
start /wait %zipa% x .\Azul-JDK25_X64-Win.zip
start /wait %zipa% x .\PCLRealase.zip
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容: 清理 运行路径: %cd%
del /f /s /q .\Azul*
del /f /s /q .\PCLRealase.zip
timeout /t 2 /nobreak >nul
title Minecraft 一键安装 当前进行内容: 更正名称 运行路径: %cd%
echo ==================
start /wait %FolderKwordRen% -k zulu8 -n jre-x64
start /wait %FolderKwordRen% -k zulu17 -n JDK17
start /wait %FolderKwordRen% -k zulu21 -n JDK21
start /wait %FolderKwordRen% -k zulu25 -n JDK25
rename "Plain Craft Launcher 2.exe" PlainCraftLauncher2.exe
timeout /t 2 /nobreak >nul & echo 加入注册表项目...
reg add "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" /t REG_EXPAND_SZ /d %cd% >nul
echo.
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Hello Minecraft Launcher.lnk""):b.TargetPath=""%cd%\HMCL-3.8.2.exe"":b.WorkingDirectory=""%cd%"":b.Save:close")
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""Desktop"") & ""\Plain Craft Launcher 2.lnk""):b.TargetPath=""%cd%\PlainCraftLauncher2.exe"":b.WorkingDirectory=""%cd%"":b.Save:close")
goto Success

:InvalidArchitecture
cls
echo 处理器类型 %PROCESSOR_ARCHITECTURE% 尚不支持,按任意键退出
pause >nul & pause >nul
exit

:No32Systems
cls
echo 要求64位操作系统
echo 按任意键退出
pause >nul & pause >nul
exit

:DontInstSystemDrive
cls
echo 我们坚决阻止您在系统分区运行安装,此为固定要求
echo 按任意键退出
pause >nul & pause >nul
exit

:Success
mkdir .minecraft;PCL
echo 安装完成,按任意键退出
pause >nul & pause >nul
exit

:exist
echo 你已经拥有了 Minecraft 一键安装
echo 按任意键查看该文件夹并退出批处理
pause >nul & pause >nul
start %MCOneKeyInst%
exit