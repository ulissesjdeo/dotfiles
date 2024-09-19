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

# Add ultimate performance power plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
