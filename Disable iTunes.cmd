@echo off
title iTunes Disabler - he3als
color 0a
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause & exit 1
    )
    exit 0
)

:start
cls
echo It is highly recommended that you unplug all of your Apple devices from your computer and close iTunes. 
echo This script is made for people using Sideloady, the non-Store version of iTunes and 64-bits.
echo I have no idea how iCloud will react once running this script.
echo Future support may be added for 32-bit, but I will not test that.
echo I take no responsibility for the damage caused to your devices or system, use at your own risk. 
echo Feel free to do what you like with this script, redistribute it, edit it, etc... Contributions would be great!
echo I have only tested Windows 10 21H2 with this script!
echo You can find the most updated script here: https://www.github.com/he3als/iTunesDisabler
echo.
echo What would you like to do?
echo [1] Disable iTunes
echo [2] Enable iTunes
echo [3] Goto GitHub repository
echo [4] Exit
CHOICE /C:1234 /N /M "Type a number (1, 2, 3 or 4): "
IF %ERRORLEVEL% == 1 GOTO disable
IF %ERRORLEVEL% == 2 GOTO enable
IF %ERRORLEVEL% == 3 start "" https://www.github.com/he3als/iTunesDisabler
IF %ERRORLEVEL% == 4 exit
goto start

:disable
Taskkill /IM "iTunes.exe" /F
Taskkill /IM "iTunesHelper.exe" /F
Taskkill /IM "iTunesVisualizerHost.exe" /F
Taskkill /IM "AppleMobileDeviceHelper.exe" /F
Taskkill /IM "AppleMobileBackup.exe" /F
Taskkill /IM "AppleMobileDeviceService.exe" /F
Taskkill /IM "AppleMobileDeviceProcess.exe" /F
Taskkill /IM "AppleMobileSync.exe" /F
Taskkill /IM "distnoted.exe" /F
Taskkill /IM "iPodService.exe" /F
Taskkill /IM "iTunesHelper.exe" /F
Taskkill /IM "MDCrashReportTool.exe" /F
Taskkill /IM "mDNSResponder.exe" /F
Taskkill /IM "SyncServer.exe" /F
Taskkill /IM "com.apple.IE.client.exe" /F
Taskkill /IM "com.apple.Outlook.client.exe" /F
Taskkill /IM "com.apple.Safari.client.exe" /F
Taskkill /IM "com.apple.WindowsContacts.client.exe" /F
Taskkill /IM "com.apple.WindowsMail.client.exe" /F
Taskkill /IM "SoftwareUpdate.exe" /F
sc stop "Apple Mobile Device Service"
sc stop "Bonjour Service"
:: Error might occur here - I found that the drivers sometimes would not stop in my testing
sc stop "AppleKmdfFilter"
sc stop "AppleLowerFilter"
sc config "Apple Mobile Device Service" start= disabled
sc config "Bonjour Service" start= disabled
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AppleLowerFilter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AppleKmdfFilter" /v "Start" /t REG_DWORD /d "4" /f
rename "C:\Program Files\Common Files\Apple" "Apple1"
rename "C:\Program Files\iTunes" "iTunes1"
rename "C:\Program Files (x86)\Apple Software Update" "Apple Software Update1"
rename "C:\Program Files (x86)\Bonjour" "Bonjour1"
rename "C:\Program Files\Bonjour" "Bonjour1"
rename "C:\Program Files (x86)\Common Files\Apple" "Apple1"
echo iTunes ^& related services/drivers are disabled and folders are renamed!
pause
exit

:enable
sc config "Apple Mobile Device Service" start= auto
sc config "Bonjour Service" start= auto
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AppleLowerFilter" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\AppleKmdfFilter" /v "Start" /t REG_DWORD /d "3" /f
sc start "Apple Mobile Device Service"
sc start "Bonjour Service"
rename "C:\Program Files\Common Files\Apple1" "Apple"
rename "C:\Program Files\iTunes1" "iTunes"
rename "C:\Program Files (x86)\Apple Software Update1" "Apple Software Update"
rename "C:\Program Files (x86)\Bonjour1" "Bonjour"
rename "C:\Program Files\Bonjour1" "Bonjour"
rename "C:\Program Files (x86)\Common Files\Apple1" "Apple"
echo iTunes ^& related services/drivers and folders are reverted back to default!
pause
exit