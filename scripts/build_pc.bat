@echo off

cd "%~dp0.."
python dependencies\python\configure_build.py pc

if %errorlevel% neq 0 (pause /b %errorlevel% && exit /b %errorlevel%)

start "" "%~dp0..\out\pc"