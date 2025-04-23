@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title ✨ Dragon Diffusion FramePack Installer ✨
echo ✨✨✨ Dragon Diffusion FramePack installation process beginning... ✨✨✨

REM Create log file for error tracking
echo Dragon Diffusion Installation Log > install_log.txt
echo Started at %date% %time% >> install_log.txt
echo. >> install_log.txt

REM -----------------------------------
REM Step 0: Pre-check tools
REM -----------------------------------
echo Step 0: Scouting for essential tools (pip, winget, curl)...

where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Pip not found! The dragon needs pip to summon allies.
    echo Please ensure Python is installed and pip is in PATH. Check install_log.txt.
    echo Press any key to flee...
    pause
    exit /b
)

where winget >nul 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Winget not found! The dragon may struggle to summon optional tools.
    echo You may need to install some tools manually later. Press any key to continue...
    pause
)

where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo curl not found, summoning it...
    powershell -Command "Invoke-WebRequest https://curl.se/windows/dl-8.7.1_2/curl-8.7.1_2-win64-mingw.zip -OutFile curl.zip; Expand-Archive curl.zip -DestinationPath curl; Move-Item curl\curl-8.7.1_2-win64-mingw\bin\curl.exe .; del curl.zip; rmdir curl -Recurse" >> install_log.txt 2>&1
    where curl >nul 2>nul
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon curl warrior! Check install_log.txt for clues.
        echo The dragon needs curl to weave its web spells. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_curl
        echo Fleeing the battlefield...
        pause
        exit /b
    )
)
:retry_curl
echo Essential tools scouted!

REM -----------------------------------
REM Step 1: Check Python 3.10 presence
REM -----------------------------------
echo Step 1: Summoning Python 3.10...
set PYTHON=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310\python.exe
set PYTHON_RETRY=0
:try_python
if exist "%PYTHON%" (
    for /f "tokens=2 delims= " %%i in ('"%PYTHON%" --version') do set PY_VERSION=%%i
    for /f "tokens=1,2 delims=." %%a in ("!PY_VERSION!") do (
        set PY_MAJOR=%%a
        set PY_MINOR=%%b
    )
    if "!PY_MAJOR!.!PY_MINOR!"=="3.10" (
        echo Python 3.10 found, ready to breathe fire!
    ) else (
        echo Wrong Python version detected. Summoning Python 3.10...
        where winget >nul 2>nul
        if %errorlevel% equ 0 (
            winget install -e --id Python.Python.3.10 --version 3.10.11 >> install_log.txt 2>&1
            if %errorlevel% neq 0 (
                echo [ERROR] Failed to summon Python 3.10! Check install_log.txt for clues.
                echo The dragon needs Python 3.10 to cast its spells.
                set /a PYTHON_RETRY+=1
                if !PYTHON_RETRY! lss 3 (
                    echo Press R to retry, or any key to flee...
                    set /p choice=Choice: 
                    if /i "!choice!"=="R" goto :try_python
                )
                echo Please install Python 3.10 manually from https://www.python.org/downloads/.
                pause
                exit /b
            )
        ) else (
            echo [ERROR] Winget not found! Cannot auto-install Python 3.10.
            echo Please install Python 3.10 manually from https://www.python.org/downloads/.
            pause
            exit /b
        )
    )
) else (
    echo Python not found. Summoning Python 3.10...
    where winget >nul 2>nul
    if %errorlevel% equ 0 (
        winget install -e --id Python.Python.3.10 --version 3.10.11 >> install_log.txt 2>&1
        if %errorlevel% neq 0 (
            echo [ERROR] Failed to summon Python 3.10! Check install_log.txt for clues.
            echo The dragon needs Python 3.10 to cast its spells.
            set /a PYTHON_RETRY+=1
            if !PYTHON_RETRY! lss 3 (
                echo Press R to retry, or any key to flee...
                set /p choice=Choice: 
                if /i "!choice!"=="R" goto :try_python
            )
            echo Please install Python 3.10 manually from https://www.python.org/downloads/.
            pause
            exit /b
        )
    ) else (
        echo [ERROR] Winget not found! Cannot auto-install Python 3.10.
        echo Please install Python 3.10 manually from https://www.python.org/downloads/.
        pause
        exit /b
    )
)
echo Python 3.10 ready to roar!

REM -----------------------------------
REM Step 2: Check for Git (optional)
REM -----------------------------------
echo Step 2: Checking for Git to guard the dragon’s hoard...
where git >nul 2>nul
if %errorlevel% equ 0 (
    echo Git already summoned, ready to track the dragon’s hoard!
) else (
    echo Git not found. The dragon can guard its hoard manually, but Git helps with updates.
    echo Would you like to summon Git? Press Y to install, or any key to skip...
    set /p choice=Choice: 
    if /i "!choice!"=="Y" (
        where winget >nul 2>nul
        if %errorlevel% equ 0 (
            set GIT_RETRY=0
            :try_git
            winget install -e --id Git.Git >> install_log.txt 2>&1
            if %errorlevel% neq 0 (
                echo [ERROR] Failed to summon Git via winget! Check install_log.txt for clues.
                set /a GIT_RETRY+=1
                if !GIT_RETRY! lss 3 (
                    echo Press R to retry, or any key to skip...
                    set /p choice=Choice: 
                    if /i "!choice!"=="R" goto :try_git
                )
                echo Please install Git manually from https://git-scm.com/download/win if you want updates.
                pause
            ) else (
                echo Git summoned, ready to track the dragon’s hoard!
            )
        ) else (
            echo [WARNING] Winget not found! Cannot auto-install Git.
            echo Please install Git manually from https://git-scm.com/download/win if you want updates.
            pause
        )
    ) else (
        echo Skipping Git installation. Update the hoard manually by re-downloading from GitHub.
    )
)

REM -----------------------------------
REM Step 3: Create virtual environment
REM -----------------------------------
echo Step 3: Crafting a magical venv in the Dragon’s Lair...
set VENV_RETRY=0
:try_venv
if exist venv (
    echo Magical venv already exists, shimmering with power!
) else (
    "%PYTHON%" -m venv venv >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to craft magical venv! Check install_log.txt for clues.
        echo The dragon needs a lair to rest.
        set /a VENV_RETRY+=1
        if !VENV_RETRY! lss 3 (
            echo Press R to retry, or any key to flee...
            set /p choice=Choice: 
            if /i "!choice!"=="R" goto :try_venv
        )
        echo Please check Python installation or create venv manually.
        pause
        exit /b
    )
)
echo Magical venv ready to enchant!

REM -----------------------------------
REM Step 4: Activate virtual environment
REM -----------------------------------
echo Step 4: Activating magical venv...
set ACTIVATE_RETRY=0
:try_activate
call venv\Scripts\activate.bat >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to activate magical venv! Check install_log.txt for clues.
    echo The dragon can’t enter its lair.
    set /a ACTIVATE_RETRY+=1
    if !ACTIVATE_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_activate
    )
    echo Please check venv creation or activate manually.
    pause
    exit /b
)
echo Magical venv activated, glowing with arcane energy!

REM -----------------------------------
REM Step 5: Upgrade pip
REM -----------------------------------
echo Step 5: Sharpening pip’s claws...
set PIP_RETRY=0
:try_pip
python -m pip install --upgrade pip >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to sharpen pip’s claws! Check install_log.txt for clues.
    echo The dragon needs a sharp pip to hunt.
    set /a PIP_RETRY+=1
    if !PIP_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_pip
    )
    echo Please check Python installation or upgrade pip manually.
    pause
    exit /b
)
echo Pip sharpened, ready to strike!

REM -----------------------------------
REM Step 6: Install PyTorch
REM -----------------------------------
echo Step 6: Summoning PyTorch...
set PYTORCH_RETRY=0
:try_pytorch
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124 >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to summon PyTorch! Check install_log.txt for clues.
    echo The dragon needs PyTorch’s fire to blaze.
    set /a PYTORCH_RETRY+=1
    if !PYTORCH_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_pytorch
    )
    echo Please install PyTorch manually.
    pause
    exit /b
)
echo PyTorch summoned, blazing with dragonfire!

REM -----------------------------------
REM Step 7: Summon Triton
REM -----------------------------------
echo Step 7: Summoning Triton...
set TRITON_RETRY=0
:try_triton
curl -L -o triton-3.0.0-cp310-cp310-win_amd64.whl https://github.com/woct0rdho/triton-windows/releases/download/v3.1.0-windows.post9/triton-3.0.0-cp310-cp310-win_amd64.whl >> install_log.txt 2>&1
if exist triton-3.0.0-cp310-cp310-win_amd64.whl (
    pip install triton-3.0.0-cp310-cp310-win_amd64.whl >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon Triton! Check install_log.txt for clues.
        echo The dragon needs Triton’s oceanic might.
        set /a TRITON_RETRY+=1
        if !TRITON_RETRY! lss 3 (
            echo Press R to retry, or any key to flee...
            set /p choice=Choice: 
            if /i "!choice!"=="R" goto :try_triton
        )
        echo Please check the downloaded wheel file or install Triton manually.
        pause
        exit /b
    )
) else (
    echo [ERROR] Triton wheel not found after download! Check install_log.txt for clues.
    echo The dragon’s oceanic ally is missing.
    set /a TRITON_RETRY+=1
    if !TRITON_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_triton
    )
    echo Please check your internet connection or download Triton manually.
    pause
    exit /b
)
echo Triton summoned, wielding oceanic might!

REM -----------------------------------
REM Step 8: Install SageAttention (from current directory)
REM -----------------------------------
echo Step 8: Summoning SageAttention...
set SAGEATTENTION_WHEEL=.\sageattention-1.0.6-py3-none-any.whl
echo Checking for SageAttention at %CD%\%SAGEATTENTION_WHEEL%
set SAGEATTENTION_RETRY=0
:try_sageattention
if exist "%SAGEATTENTION_WHEEL%" (
    pip install "%SAGEATTENTION_WHEEL%" >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon SageAttention! Check install_log.txt for clues.
        echo The dragon needs SageAttention’s wisdom.
        set /a SAGEATTENTION_RETRY+=1
        if !SAGEATTENTION_RETRY! lss 3 (
            echo Press R to retry, or any key to flee...
            set /p choice=Choice: 
            if /i "!choice!"=="R" goto :try_sageattention
        )
        echo Please check the wheel file or install SageAttention manually.
        pause
        exit /b
    )
) else (
    echo [ERROR] SageAttention-0.0.1-cp310-cp310-win_amd64.whl not found in %CD%! Check install_log.txt for clues.
    echo The dragon’s wise ally is missing.
    set /a SAGEATTENTION_RETRY+=1
    if !SAGEATTENTION_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_sageattention
    )
    echo Please ensure the SageAttention wheel file is in the current directory.
    pause
    exit /b
)
echo SageAttention summoned, wise and powerful!

REM -----------------------------------
REM Step 9: Install dependencies
REM -----------------------------------
echo Step 9: Summoning other dependencies...
set DEPS_RETRY=0
:try_requirements
if exist requirements.txt (
    pip install -r requirements.txt >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon dependencies! Check install_log.txt for clues.
        echo The dragon needs its allies from requirements.txt.
        set /a DEPS_RETRY+=1
        if !DEPS_RETRY! lss 3 (
            echo Press R to retry, or any key to flee...
            set /p choice=Choice: 
            if /i "!choice!"=="R" goto :try_requirements
        )
        echo Please install dependencies manually from requirements.txt.
        pause
        exit /b
    )
) else (
    echo [ERROR] requirements.txt not found in %CD%! Check install_log.txt for clues.
    echo The dragon’s army list is missing.
    set /a DEPS_RETRY+=1
    if !DEPS_RETRY! lss 3 (
        echo Press R to retry, or any key to skip...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_requirements
    )
    echo Skipping dependency installation...
)
echo Dependencies summoned, ready to support the dragon!

REM -----------------------------------
REM Step 10: Install C++ Redistributable
REM -----------------------------------
echo Step 10: Forging C++ Redistributable...
set VCREDIST_RETRY=0
:try_vcredist
curl -L -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe >> install_log.txt 2>&1
vc_redist.x64.exe /quiet /install >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to forge C++ Redistributable! Check install_log.txt for clues.
    echo The dragon’s armor needs strengthening.
    set /a VCREDIST_RETRY+=1
    if !VCREDIST_RETRY! lss 3 (
        echo Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :try_vcredist
    )
    echo Please install the C++ Redistributable manually from https://aka.ms/vs/17/release/vc_redist.x64.exe.
    pause
    exit /b
)
echo C++ Redistributable forged, strengthening the dragon’s armor!

REM -----------------------------------
REM Step 11: Install FFmpeg
REM -----------------------------------
echo Step 11: Checking for FFmpeg...
set FFMPEG_RETRY=0
:try_ffmpeg
where ffmpeg >nul 2>nul
if %errorlevel% equ 0 (
    echo FFmpeg already installed, skipping installation.
) else (
    echo Installing FFmpeg to local directory...
    curl -L -o ffmpeg.zip https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-7.1-essentials_build.zip >> install_log.txt 2>&1
    powershell -Command "Expand-Archive ffmpeg.zip -DestinationPath ffmpeg" >> install_log.txt 2>&1
    move ffmpeg\ffmpeg-7.1-essentials_build\bin\ffmpeg.exe .\ffmpeg\ffmpeg.exe >> install_log.txt 2>&1
    set "PATH=%PATH%;%CD%\ffmpeg"
    echo set "PATH=%%PATH%%;%CD%\ffmpeg" >> Activate_Venv.bat
    rmdir /s /q ffmpeg\ffmpeg-7.1-essentials_build >> install_log.txt 2>&1
    del ffmpeg.zip >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install FFmpeg! Check install_log.txt for clues.
        echo The dragon needs FFmpeg for video sorcery.
        set /a FFMPEG_RETRY+=1
        if !FFMPEG_RETRY! lss 3 (
            echo Press R to retry, or any key to flee...
            set /p choice=Choice: 
            if /i "!choice!"=="R" goto :try_ffmpeg
        )
        echo Please install FFmpeg manually from https://www.gyan.dev/ffmpeg/builds/.
        pause
        exit /b
    )
    echo FFmpeg installed to local directory, ready for video sorcery!
)

REM -----------------------------------
REM Step 12: Clear Triton cache
REM -----------------------------------
echo Step 12: Clearing Triton’s ancient cache...
set TRITON_CACHE=C:\Users\%USERNAME%\.triton\cache
set TORCHINDUCTOR_CACHE=C:\Users\%USERNAME%\AppData\Local\Temp\torchinductor_%USERNAME%\triton
if exist "!TRITON_CACHE!" (
    rmdir /s /q "!TRITON_CACHE!" >> install_log.txt 2>&1
    mkdir "!TRITON_CACHE!" >> install_log.txt 2>&1
)
if exist "!TORCHINDUCTOR_CACHE!" (
    rmdir /s /q "!TORCHINDUCTOR_CACHE!" >> install_log.txt 2>&1
    mkdir "!TORCHINDUCTOR_CACHE!" >> install_log.txt 2>&1
)
echo Triton cache cleared, ready for fresh magic!

REM -----------------------------------
REM Step 13: Create helper batch files
REM -----------------------------------
echo Step 13: Crafting mighty helper dragons...
(
echo @echo off
echo call venv\Scripts\activate.bat
echo echo Virtual environment activated
echo .\venv\Scripts\python.exe -s demo_gradio.py
echo pause
) > Run_FramePack.bat

(
echo @echo off
echo call .\Scripts\activate.bat
echo echo Virtual environment activated
echo cmd.exe /k
) > Activate_Venv.bat

(
echo @echo off
echo git pull
echo pause
) > Update_FramePack.bat

echo.
echo ✨✨✨ Installation complete! The dragons are ready to soar! ✨✨✨
echo Run "Run_FramePack.bat" to begin your journey!
echo Note: If you skipped Git, update by re-downloading from GitHub.
pause
cmd.exe /k