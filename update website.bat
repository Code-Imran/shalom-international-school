@echo off
setlocal enabledelayedexpansion

echo ============================================
echo      Shalom International School - Deploy
echo ============================================
echo.

:: 1. Navigate to script directory to ensure correct path
cd /d "%~dp0"

:: 2. Check if .git folder exists
if not exist ".git" (
    echo [ERROR] Not inside a Git repository root.
    echo Ensure this file is placed in your project root folder.
    echo.
    pause
    exit /b 1
)

:: 3. Detect current branch
set "BRANCH=main"
for /f "delims=" %%b in ('git branch --show-current') do (
    set "BRANCH=%%b"
)
echo Active Branch: %BRANCH%
echo.

:: 4. Stage changes
echo [1/3] Staging all files...
git add -A

:: 5. Commit
echo [2/3] Checking for changes to commit...
set /p COMMIT_MSG="Enter commit message (or press ENTER for default): "

if "%COMMIT_MSG%"=="" (
    set "COMMIT_MSG=Site update %date%"
)

git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo No new changes detected or commit completed.
)

:: 6. Push to GitHub
echo.
echo [3/3] Pushing to GitHub...
git push origin %BRANCH%
if errorlevel 1 (
    echo Push with default upstream failed. Trying --set-upstream...
    git push -u origin %BRANCH%
    if errorlevel 1 (
        echo [ERROR] Git push failed.
        pause
        exit /b 1
    )
)
echo GitHub push succeeded!

:: 7. Cloudflare Deployment
echo.
echo ============================================
echo Deploying to Cloudflare...
echo ============================================

if exist "wrangler.toml" (
    call npx wrangler deploy
) else if exist "wrangler.jsonc" (
    call npx wrangler deploy
) else (
    call npx wrangler pages deploy . --commit-dirty=true
)

if errorlevel 1 (
    echo [ERROR] Cloudflare deploy failed.
    pause
    exit /b 1
)

echo.
echo ============================================
echo Deployment Complete!
echo ============================================
echo.
pause