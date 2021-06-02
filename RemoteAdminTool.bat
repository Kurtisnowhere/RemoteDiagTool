@echo off
::Logging for opening the BAT file
pushd \\some\Floanpath\for\logging
echo %date%,%time%,%username%,%computername%,Opened >> RemoteAdminUsageLog.csv
popd \\some\path\for\logging

::Checks if PSExec is installed
if not exist C:\windows\system32\psexec.exe goto choice
if exist C:\windows\system32\psexec.exe goto Start

:Choice
echo.
echo PsExec is not installed.  
echo This tool uses PsExec to remotely access endpoints.
echo.
set /p choice= Would you like to install PsExec now? (Y/N)
echo.
if '%choice%'=='y' goto Install
if '%choice%'=='Y' goto Install
if '%choice%'=='n' goto Warning
if '%choice%'=='N' goto Warning
if '%choice%'=='' goto Null

::Installs PSExec from file location
:Install
pushd \\path\of\installation\file\for\psexec
echo %date%,%time%,%username%,%computername%,Installed PsExec >> RemoteAdminUsageLog.csv
popd \\path\of\installation\file\for\psexec
robocopy "\\path\of\installation\file\for\psexec" c:\windows\system32 PsExec.exe
echo PsExec has been added to your System32 folder
Pause
goto Start


:Warning
echo You have opted out of installing PsExec, you will be unable to use this tool.
echo This tool will now close.
pause
goto Exit

:Null
Echo You have not made a valid selection.
Pause
goto Choice

:start 
title Remote Administration Tool
cls
echo ###################################
Echo ###  Author: Kurtis Carey       ###
Echo ###  Remote Admin Tool          ###
Echo ###  Version 0.5                ###
echo ###################################
echo.
echo     1. List Local Admin
echo     2. Add Local Admin
echo     3. Remove Local Admin
echo     4. List Installed Software
echo     5. Run Network and Device Troubleshooting
echo     6. Change Log
echo.

set /p choice=What would you like to do? 
echo. 
if '%choice%'=='1' goto List
if '%choice%'=='2' goto Add
if '%choice%'=='3' goto Delete
if '%choice%'=='4' goto Program
if '%choice%'=='5' goto Diag
if '%choice%'=='6' goto Change


:List
::Logs action
pushd \\s-files\technical services\.scripts\remote administration
echo %date%,%time%,%username%,%computername%,Listed Admin >> RemoteAdminUsageLog.csv
popd \\s-files\technical services\.scripts\remote administration

echo Lists Local Administrators
echo.
set /p Input= Enter Host Name: 
ping %input%
psexec \\%input% cmd /c net localgroup Administrators
Pause
goto End


:Add
::Logs action
pushd \\some\path\for\logging
echo %date%,%time%,%username%,%computername%,Added Local Admin >> RemoteAdminUsageLog.csv
popd \\some\path\for\logging

echo Adds a Local Administrator
echo.
set /p Input= Enter Host Name: 
set /p Username= Enter Specified User: 
ping %input%
psexec \\%input% cmd /c net localgroup Administrators %username% /add
Pause
goto End

:Delete
::Logs action
pushd \\some\path\for\logging
echo %date%,%time%,%username%,%computername%,Deleted Local Admin >> RemoteAdminUsageLog.csv
popd \\some\path\for\logging

echo Deletes a Local Adminstrator
echo.
set /p Input= Enter Host Name: 
set /p Username= Enter Specified User: 
ping %input%
psexec \\%input% cmd /c net localgroup Administrators %username% /delete
pause
goto end


:Program
::Logs action
pushd \\some\path\for\logging
echo %date%,%time%,%username%,%computername%,Listed Installed Software >> RemoteAdminUsageLog.csv
popd \\some\path\for\logging

echo. Lists all installed software
echo.
set /p Input= Enter Host Name: 
ping %input%
psexec \\%input% wmic product get name,version,installdate | sort 
Pause
goto End


:Diag
::Logs action
pushd \\some\path\for\logging
echo %date%,%time%,%username%,%computername%,Ran Diagnostics >> RemoteAdminUsageLog.csv
popd \\some\path\for\logging

::Checks if Desktop exists, and creates one in C drive
if not exist C:\users\%username%\Desktop\ mkdir C:\users\%username%\Desktop\

::Checks if silentdiag batch is present, if not, copies from file path
if not exist \\path\of\silentdiag robocopy "\\path\to\copy\silentdiag\from" c:\users\%username%\SilentDiag.bat

cls
echo Runs remote diagnostic batch file to collect information on remote endpoint
echo.
echo Saved SilentDiag to C:\Users\%Username%\Desktop
echo.
set /p input= Enter Remote Host Name:
psexec -cf \\%input% c:\users\%username%\desktop\SilentDiag.bat >> C:\users\%username%\Desktop\%input%_%date:~-10,2%%date:~-7,2%%date:~-4,4%_.txt
pause
goto End

:Change
pushd \\s-files\technical services\.scripts\remote administration
echo %date%,%time%,%username%,%computername%,Accessed Change Log >> RemoteAdminUsageLog.csv
popd \\s-files\technical services\.scripts\remote administration

Echo V0.4 Added "Run Network and Device Troubleshooting"
echo V0.4 Added Change Log
echo V0.5 Added PsExec Install 
echo V0.5 Added Desktop creation for OneDrive Users
pause

:End
cls
goto start

:Exit
exit






