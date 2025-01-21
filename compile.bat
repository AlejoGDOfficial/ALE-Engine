@echo off
color 0b

title Compile the ALE Engine Source Code

:choose_platform
echo Choose the platform to compile:
echo A: Android
echo W: Windows
choice /c AW /m "Select Option"
if errorlevel 2 (
    set platform=Windows
) else if errorlevel 1 (
    set platform=Android
) else (
    goto choose_platform
)

:run_command
echo Compiling for %platform%...
if "%platform%" == "Android" (
    lime test android
) else if "%platform%" == "Windows" (
    lime test windows
)

choice /c YN /m "Retry?"

if errorlevel 2 (
    exit
) else (
    goto run_command
)
