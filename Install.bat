@echo off
setlocal enabledelayedexpansion
title ✨ Dragon Diffusion FramePack Installer ✨
echo ✨✨✨ Dragon Diffusion FramePack installation process beginning... ✨✨✨

REM -----------------------------------
REM Step 1: Check Python 3.10 presence
REM -----------------------------------
echo Step 1: Summoning Python 3.10...
set PYTHON=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310\python.exe

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
        winget install -e --id Python.Python.3.10 --version 3.10.11
        if errorlevel 1 (
            echo Failed to summon Python 3.10. Please install it manually.
            pause
            exit /b
        )
    )
) else (
    echo Python not found. Summoning Python 3.10...
    winget install -e --id Python.Python.3.10 --version 3.10.11
    if errorlevel 1 (
        echo Failed to summon Python 3.10. Please install it manually.
        pause
        exit /b
    )
)
echo Python 3.10 ready to roar!

REM -----------------------------------
REM Step 2: Install Git
REM -----------------------------------
echo Step 2: Summoning Git...
winget install -e --id Git.Git
echo Git summoned, ready to track the dragon’s hoard!

REM -----------------------------------
REM Step 3: Create virtual environment
REM -----------------------------------
echo Step 3: Crafting a magical venv in the Dragon’s Lair...
if exist venv (
    echo Magical venv already exists, shimmering with power!
) else (
    "%PYTHON%" -m venv venv
    if errorlevel 1 (
        echo Failed to craft magical venv. Please check Python installation.
        pause
        exit /b
    )
)
echo Magical venv ready to enchant!

REM -----------------------------------
REM Step 4: Activate virtual environment
REM -----------------------------------
echo Step 4: Activating magical venv...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo Failed to activate magical venv. Please check venv creation.
    pause
    exit /b
)
echo Magical venv activated, glowing with arcane energy!

REM -----------------------------------
REM Step 5: Upgrade pip
REM -----------------------------------
echo Step 5: Sharpening pip’s claws...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo Failed to sharpen pip. Please check Python installation.
    pause
    exit /b
)
echo Pip sharpened, ready to strike!

REM -----------------------------------
REM Step 6: Install PyTorch
REM -----------------------------------
echo Step 6: Summoning PyTorch...
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124
if errorlevel 1 (
    echo Failed to summon PyTorch. Please check internet connection or pip.
    pause
    exit /b
)
echo PyTorch summoned, blazing with dragonfire!

REM -----------------------------------
REM Step 7: Install Triton from URL
REM -----------------------------------
echo Step 7: Summoning Triton...
curl -L -o triton-3.0.0-cp310-cp310-win_amd64.whl https://github.com/woct0rdho/triton-windows/releases/download/v3.1.0-windows.post9/triton-3.0.0-cp310-cp310-win_amd64.whl
pip install triton-3.0.0-cp310-cp310-win_amd64.whl
if errorlevel 1 (
    echo Failed to summon Triton. Please check the downloaded wheel file.
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
if exist "%SAGEATTENTION_WHEEL%" (
    pip install "%SAGEATTENTION_WHEEL%"
    if errorlevel 1 (
        echo Failed to summon SageAttention. Please check the wheel file.
        pause
        exit /b
    )
    echo SageAttention summoned, wise and powerful!
) else (
    echo SageAttention-0.0.1-cp310-cp310-win_amd64.whl not found in %CD%.
    pause
    exit /b
)

REM -----------------------------------
REM Step 9: Install dependencies
REM -----------------------------------
echo Step 9: Summoning other dependencies...
if exist requirements.txt (
    pip install -r requirements.txt
    if errorlevel 1 (
        echo Failed to summon dependencies. Please check requirements.txt.
        pause
        exit /b
    )
) else (
    echo requirements.txt not found in %CD%. Skipping dependency installation.
)
echo Dependencies summoned, ready to support the dragon!

REM -----------------------------------
REM Step 10: Install C++ Redistributable
REM -----------------------------------
echo Step 10: Forging C++ Redistributable...
curl -L -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
vc_redist.x64.exe /quiet /install
if errorlevel 1 (
    echo Failed to forge C++ Redistributable. Please check the installer.
    pause
    exit /b
)
echo C++ Redistributable forged, strengthening the dragon’s armor!

REM -----------------------------------
REM Step 11: Clear Triton cache
REM -----------------------------------
echo Step 11: Clearing Triton’s ancient cache...
set TRITON_CACHE=C:\Users\%USERNAME%\.triton\cache
set TORCHINDUCTOR_CACHE=C:\Users\%USERNAME%\AppData\Local\Temp\torchinductor_%USERNAME%\triton
if exist "!TRITON_CACHE!" (
    rmdir /s /q "!TRITON_CACHE!"
    mkdir "!TRITON_CACHE!"
)
if exist "!TORCHINDUCTOR_CACHE!" (
    rmdir /s /q "!TORCHINDUCTOR_CACHE!"
    mkdir "!TORCHINDUCTOR_CACHE!"
)
echo Triton cache cleared, ready for fresh magic!

REM -----------------------------------
REM Step 12: Create helper batch files
REM -----------------------------------
echo Step 12: Crafting mighty helper dragons...
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
pause
cmd.exe /k