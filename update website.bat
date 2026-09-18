@echo off
setlocal enabledelayedexpansion

echo ============================================
echo    Shalom International School - Deploy
echo ============================================
echo.

REM Make sure we're in a git repo
if not exist ".git" (
    echo ERROR: This folder is not a git repository.
    echo Make sure "Deploy Website.bat" is sitting inside your
    echo website folder.
    echo.
    pause
    exit /b 1
)

REM Check for changes
echo Checking for changes...
git status --short
echo.

for /f %%i in ('git status --porcelain ^| find /c /v ""') do set "CHANGE_COUNT=%%i"

if "%CHANGE_COUNT%"=="0" (
    echo No changes detected in Git.
    echo Proceeding to deploy live to Cloudflare...
) else (
    REM Ask for a commit message, with a sensible default
    set "COMMIT_MSG="
    set /p COMMIT_MSG="Enter a short description of your changes (or press Enter for default): "

    if "!COMMIT_MSG!"=="" (
        for /f "tokens=1-3 delims=/ " %%a in ("%date%") do set "TODAY=%%a-%%b-%%c"
        set "COMMIT_MSG=Update site - !TODAY! !time!"
    )

    echo.
    echo Staging changes...
    git add .

    echo Committing...
    git commit -m "!COMMIT_MSG!"

    if errorlevel 1 (
        echo.
        echo ERROR: Commit failed. See message above.
        echo.
        pause
        exit /b 1
    )

    echo.
    echo Pushing to GitHub...
    git push

    if errorlevel 1 (
        echo.
        echo ERROR: Push failed. Check your internet connection or GitHub login.
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ============================================
echo Deploying directly to Cloudflare Worker...
echo ============================================
call npx wrangler deploy

if errorlevel 1 (
    echo.
    echo ERROR: Cloudflare deployment failed. See error above.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo    Done! GitHub is updated and site is live.
echo ============================================
echo.
pause