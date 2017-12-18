:: Metasploit RPC Deployer
:: Version: 1.0
:: Written by Metaspook
:: License: <http://opensource.org/licenses/MIT>
:: Copyright (c) 2017 Metaspook.
::
::               "Exploring is better then following" --Metaspook.
::

@echo off
title Metasploit RPC Deployer :-)
pushd "%~dp0"
::mode con: cols=55 lines=30
if exist "%homedrive%\metasploit\apps\pro\msf3\msfrpcd" set MSFDIR=%homedrive%\metasploit\
if exist "%~dp0apps\pro\msf3\msfrpcd" set MSFDIR=%~dp0


:TASK01
:: Finding running RPC Daemon process and redirect between functions.
for /f %%i in ('tasklist ^|find "rubyw.exe"') do call:TASK02
call:MSG01
echo [ OFFLINE ] Metasploit RPC Daemon.
echo.
set /p usrinput="DEPLOY ? (Y/N): "
if /i "%usrinput%"=="Y" call:TASK03
if /i "%usrinput%"=="N" exit
call:TASK01

:TASK02
call:MSG01
echo [ ONLINE ] Metasploit RPC Daemon.
echo.
set /p usrinput="TERMINATE ? (Y/N): "
if /i "%usrinput%"=="Y" for /f %%i in ('tasklist ^|find "rubyw.exe"') do taskkill /F /IM rubyw.exe >nul && call:TASK01
if /i "%usrinput%"=="N" exit
call:TASK02

:TASK03
:: Finding Metasploit Framework and set it's directory on a variable.
if exist "%homedrive%\metasploit\apps\pro\msf3\msfrpcd" set MSFDIR=%homedrive%\metasploit\
if exist "%~dp0apps\pro\msf3\msfrpcd" set MSFDIR=%~dp0
if not defined MSFDIR call:MSG02
set HOST=127.0.0.1
set PORT=55553
set USER=msf
set PASS=test
call:MSG01
echo Default configuration:
echo.
echo  HOST     : %HOST%
echo  PORT     : %PORT%
echo  USERNAME : %USER%
echo  PASSWORD : %PASS%
echo.
echo.
set /p HOST="Enter a HOST/IP  (Leave blank for default): "
set /p PORT="Enter a PORT     (Leave blank for default): "
set /p USER="Enter a USERNAME (Leave blank for default): "
set /p PASS="Enter a PASSWORD (Leave blank for default): "
cd "%MSFDIR%"
set PATH=%MSFDIR%ruby\bin;%MSFDIR%java\bin;%MSFDIR%tools;%MSFDIR%nmap;%MSFDIR%postgresql\bin;%PATH%
if exist "%MSFDIR%java" set JAVA_HOME="%MSFDIR%java"
set MSF_DATABASE_CONFIG="%MSFDIR%apps\pro\ui\config\database.yml"
set MSF_BUNDLE_GEMS=0
set BUNDLE_GEMFILE=%MSFDIR%apps\pro\Gemfile
cd "%MSFDIR%apps\pro\msf3"
start /b rubyw msfrpcd -a %HOST% -U %USER% -P %PASS% -S -f -p %PORT%
call:MSG01
echo  * AFTER ONLINE WAIT FEW SECONDS BEFORE CONNECT.
ping -n 3 localhost >nul
call:MSG01
for /f %%i in ('tasklist ^|find "rubyw.exe"') do call:MSG03
call:MSG04
:: There was a problem occurred while I trying to run the batch file from another directory 
:: without "%homedrive% or %systemdrive%" or directories under it.
:: But when I compiled it into a .exe executable it was solved.

:MSG01
cls
echo.
echo  +---------------------------------+
echo  ^| METASPLOIT RPC DEPLOYER v1.0 ^| 
echo  +---------------------------------+
echo.
echo.
echo.
goto:EOF

:MSG02
call:MSG01
echo [ FAIL ] I cannot find the Metasploit Framework.
ping -n 3 localhost >nul & exit

:MSG03
echo [ ONLINE ] Metasploit RPC Daemon.
ping -n 3 localhost >nul & exit

:MSG04
echo [ FAIL ] Metasploit RPC server is not established.
echo          * Try to run me from "%homedrive%\metasploit\"
ping -n 4 localhost >nul & exit