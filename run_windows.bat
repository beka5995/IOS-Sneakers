@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter is not found in PATH.
  pause
  exit /b 1
)
call flutter pub get
if errorlevel 1 goto fail
call flutter run
if errorlevel 1 goto fail
exit /b 0
:fail
echo An error occurred. Check the terminal output.
pause
exit /b 1
