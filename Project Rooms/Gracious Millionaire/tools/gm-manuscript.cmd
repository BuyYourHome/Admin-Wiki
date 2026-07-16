@echo off
setlocal

set "MODE=%~1"
set "REFRESH=%~2"
if "%MODE%"=="" goto usage

if /I "%MODE%"=="Quick" (
    set "MODE_SLUG=quick-mode"
) else if /I "%MODE%"=="Dialogue" (
    set "MODE_SLUG=dialogue-mode"
) else if /I "%MODE%"=="Rewrite" (
    set "MODE_SLUG=rewrite-mode"
) else (
    goto usage
)

set "PROJECT_ROOT=%~dp0.."
set "PYTHON=C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
set "BUILDER=%~dp0manuscript_modules.py"
set "MANIFEST=%PROJECT_ROOT%\outputs\%MODE_SLUG%\manifest.md"
set "CURRENT_PACKET=%PROJECT_ROOT%\outputs\jenny-chapter-review-current\Gracious Millionaire - Jenny Clickable Chapter Review - CURRENT.html"

if /I "%REFRESH%"=="refresh" (
    "%PYTHON%" "%BUILDER%" workflow --manifest "%MANIFEST%" --current-packet "%CURRENT_PACKET%"
) else (
    "%PYTHON%" "%BUILDER%" workflow --manifest "%MANIFEST%"
)

if errorlevel 1 exit /b %errorlevel%
exit /b 0

:usage
echo Usage: gm-manuscript.cmd Quick [refresh]
echo        gm-manuscript.cmd Dialogue [refresh]
echo        gm-manuscript.cmd Rewrite [refresh]
exit /b 2
