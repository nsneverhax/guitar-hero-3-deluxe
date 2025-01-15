@echo off

cd "%~dp0.."
python dependencies\python\configure_build.py wii

if %errorlevel% neq 0 (pause /b %errorlevel% && exit /b %errorlevel%)

start "" "%~dp0..\out\wii"