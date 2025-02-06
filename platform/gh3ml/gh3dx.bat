@echo off
setlocal enabledelayedexpansion

:: Fix administrator stuffs
set "script_dir=%~dp0"
cd /d "%script_dir%"

:: We need to write files so check if we need admin perms
echo. >test_write_permission.tmp 2>nul
if not exist test_write_permission.tmp (
	echo Because of where you have Guitar Hero III installed, you need to run this script as an Administrator.
	pause
	exit /b
) else (
	del test_write_permission.tmp >nul 2>nul
)

:: Make sure this is actually a GH3 folder, wii love intel craptop gaming
if not exist "IntelLaptopGaming.dll" (
	echo This is not a Guitar Hero III installation folder. Run this script where you have Guitar Hero III installed.
	pause
	exit /b
)

:: Check if gh3ml is installed
if not exist "gh3ml.dll" (
	echo ERROR: gh3ml is not installed. Please install gh3ml before continuing.
	echo https://github.com/nsneverhax/gh3ml/releases
	pause
	exit /b
)

:: Check for latest commit
echo Checking for updates...
for /f "delims=" %%A in ('powershell -Command "(Invoke-RestMethod -Uri https://api.github.com/repos/nsneverhax/guitar-hero-3-deluxe/commits/main).sha"') do set "latest_commit=%%A"

:: Get last commit from cache file
if exist gh3dx_last_commit.txt (
	set /p last_commit=<gh3dx_last_commit.txt

	:: Clean up whitespace
	for /f "delims=" %%B in ("%last_commit%") do set "last_commit=%%B"

	:: Don't update if there are no new updates
	if "!latest_commit!"=="!last_commit!" (
		goto :start_game
	)
) else (
	:: that's a surprise tool that'll help us later
	set first_time=true
)

:: Download shortcut icon
powershell -Command "Invoke-WebRequest -Uri https://github.com/nsneverhax/guitar-hero-3-deluxe/raw/refs/heads/main/dependencies/art/gh3dx.ico -OutFile gh3dx.ico"

:: fuck onedrive
if exist "%USERPROFILE%\Desktop\" (
	set DesktopDir=%USERPROFILE%\Desktop
) else (
	set DesktopDir=%USERPROFILE%\OneDrive\Documents\Desktop
)

:: Create a desktop shortcut
powershell -Command ^
	$s = (New-Object -COM WScript.Shell).CreateShortcut('%DesktopDir%\Guitar Hero III Deluxe.lnk'); ^
	$s.TargetPath = '%cd%\gh3dx.bat'; ^
	$s.IconLocation = '%cd%\gh3dx.ico'; ^
	$s.Save()

:: Create a start menu shortcut
powershell -Command ^
	$s = (New-Object -COM WScript.Shell).CreateShortcut('%APPDATA%\Microsoft\Windows\Start Menu\Programs\Guitar Hero III Deluxe.lnk'); ^
	$s.TargetPath = '%cd%\gh3dx.bat'; ^
	$s.IconLocation = '%cd%\gh3dx.ico'; ^
	$s.Save()

:: Update GH3DX to nightly if an update is found
echo Updating Guitar Hero III Deluxe...
powershell -Command "Invoke-WebRequest -Uri https://nightly.link/nsneverhax/guitar-hero-3-deluxe/workflows/build/main/GH3DX-gh3ml.zip -OutFile GH3DX-gh3ml.zip"
echo Installing...
powershell -Command "Expand-Archive -Path GH3DX-gh3ml.zip -DestinationPath '.' -Force"

:: cleanup cleanup everybody everywhere
del /f /q GH3DX-gh3ml.zip

:: Save new commit to the cache file
echo %latest_commit%>gh3dx_last_commit.txt

goto :start_game

:start_game
:: Prefer the borderless window exe from wes's gh3 portable
if exist "gh3WindowedBorderless.exe" (
	start "" "%cd%\gh3WindowedBorderless.exe"
) else (
	start "" "%cd%\gh3.exe"
)

endlocal
