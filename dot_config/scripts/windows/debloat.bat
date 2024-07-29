# Check for administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run with administrative privileges.
    pause
    exit /b
)

# Disable Windows 11 context menu
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Disable backgrounds apps
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f

# Disable realtime monitoring
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f

# Disable websearch
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f

# Add ultimate performance power plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

# Disable unnecessary services
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*
exit /B
:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0
:Start
sc stop MapsBroker
sc config MapsBroker start= disabled
sc stop DoSvc
sc config DoSvc start= disabled
sc stop WSearch
sc config WSearch start= disabled

# Disable telemetry
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )
:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*
exit /B
:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0
:Start
sc stop DiagTrack
sc config DiagTrack start= disabled
sc stop dmwappushservice
sc config dmwappushservice start= disabled
reg add HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener\ /v Start /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\ /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility\ /v DiagnosticErrorText /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings\ /v DiagnosticErrorText /t REG_SZ /d "" /f
reg add HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Strings\ /v DiagnosticLinkText /t REG_SZ /d "" /f

# Disable telemetry using hosts file
@echo off
SET NEWLINE=^& echo.
ECHO %NEWLINE%^127.0.0.1 localhost>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^::1 localhost>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 data.microsoft.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 msftconnecttest.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 azureedge.net>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 activity.windows.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 bingapis.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 msedge.net>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 assets.msn.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 scorecardresearch.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 edge.microsoft.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 data.msn.com>>%WINDIR%\System32\drivers\etc\hosts
