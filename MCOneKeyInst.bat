@echo off
title Minecraft һ����װ ��ǰ·��:%cd%
cd /d %~dp0

:Check
echo %PROCESSOR_ARCHITECTURE%|findstr "arm" >nul&&(goto InvalidArchitecture)
echo %PROCESSOR_ARCHITECTURE%|findstr "32" >nul&&(goto No32Systems)
echo %PROCESSOR_ARCHITECTURE%|findstr "86" >nul&&(goto No32Systems)
echo %cd%|findstr "%systemdrive%" >nul&&(goto DontInstSystemDrive)
reg query "HKEY_CURRENT_USER\Environment" /v "MCOneKeyInst" >nul 2>nul&&goto exist||goto StartInst

:StartInst
echo ����ʼ��������
echo �������"Windows ��ȫ����"�����빴ѡ"��������"��"ר������"
echo ��֤��������
echo.
echo ���Hello! Minecraft Launcher��Plain Craft Launcher 2��������,��ʹ��steam++����GitHub����
echo.
echo ������ Redirecting to ��Ϣ����������,�����Ⱥ�����
echo ÿһ��ʱ����� Download Progress Summary ʱ������״̬����
echo �����˳�����
echo.
echo 5������
echo.
timeout /t 5 /nobreak >nul
title Minecraft һ����װ ��ǰ��������:���� ����·��:%cd%
echo ��ǰ��������:
echo ���� Azul JDKFX 8��Azul JDK 17��Hello! Minecraft Launcher��Plain Craft Launcher 2
echo.
aria2c.exe --no-conf --log-level=info -x4 -s5 -j5 -c -R -d"%cd%" -i".\DownloadItems.txt"
timeout /t 2 /nobreak >nul
title Minecraft һ����װ ��ǰ��������:��ѹ�� ����·��:%cd%
echo ==================
echo.
timeout /t 2 /nobreak >nul
7za.exe x .\Azul-JDKFX8.0.382_X64-Win.zip
7za.exe x .\Azul-JDK17.0.8.1_X64-Win.zip
7za.exe x .\PCLRealase.zip
timeout /t 2 /nobreak >nul
title Minecraft һ����װ ��ǰ��������:�������� ����·��:%cd%
echo ==================
rename .\zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64 jre-x64
rename .\zulu17.44.53-ca-jdk17.0.8.1-win_x64 JDK17
rename ".\Plain Craft Launcher 2.exe" PlainCraftLauncher2.exe
timeout /t 2 /nobreak >nul
title Minecraft һ����װ ��ǰ��������:���� ����·��:%cd%
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
echo ��֧�ֵļܹ�,��������˳�
pause >nul
exit

:No32Systems
cls
echo Ҫ��64λ����ϵͳ!
echo ��������˳�
pause >nul
exit

:DontInstSystemDrive
cls
echo ��ֹ��ϵͳ�������а�װ!
echo ��ֹ���ɿص�Ӳ�̿ռ�ռ��!
echo ��������˳�
pause >nul
exit

:Success
mkdir .minecraft;PCL
echo ��װ���,��������˳�
pause >nul
exit

:exist
echo ���Ѿ�ӵ���� Minecraft һ����װ
echo ��������鿴���ļ��в��˳�������
pause >nul
start %MCOneKeyInst%
exit