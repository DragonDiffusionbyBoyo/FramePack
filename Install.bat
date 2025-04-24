@echo off
setlocal enabledelayedexpansion
title ✨ Dragon Diffusion FramePack Installer ✨
echo ✨✨✨ Dragon Diffusion FramePack installation process beginning... ✨✨✨

REM -----------------------------------
REM Step 0: Install wget and curl if missing
REM -----------------------------------
echo Step 0: Preparing download warriors (wget and curl)...

where wget >nul 2>nul
if %errorlevel% neq 0 (
    echo wget not found, installing...
    pip install wget
)

where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo curl not found or not available, attempting to install...
    powershell -Command "Invoke-WebRequest https://curl.se/windows/dl-8.7.1_2/curl-8.7.1_2-win64-mingw.zip -OutFile curl.zip; Expand-Archive curl.zip -DestinationPath curl; Move-Item curl\curl-8.7.1_2-win64-mingw\bin\curl.exe .; del curl.zip; rmdir curl -Recurse"
)

where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo curl installation failed or curl still not found. Please install it manually.
    pause
    exit /b
)

echo Download warriors ready!

REM -----------------------------------
REM Step 1: Install Git
REM -----------------------------------
echo Step 1: Summoning Git...
winget install -e --id Git.Git
echo Git summoned, ready to track the dragon’s hoard!

REM -----------------------------------
REM Step 2: Create virtual environment
REM -----------------------------------
echo Step 2: Crafting a magical venv in the Dragon’s Lair...
:: Find Python 3.10.11 executable
set "PYTHON_EXE="
for /f "delims=" %%i in ('py -3.10 -c "import sys; print(sys.executable)" 2^>nul') do (
    for /f "tokens=2 delims= " %%v in ('"%%i" --version 2^>nul') do (
        if "%%v"=="3.10.11" (
            set "PYTHON_EXE=%%i"
            goto :found_python
        )
    )
)
:found_python
if not defined PYTHON_EXE (
    echo Python 3.10.11 executable not found. Please ensure Python 3.10.11 is installed.
    pause
    exit /b 1
)
if exist venv (
    echo Magical venv already exists, shimmering with power!
) else (
    "!PYTHON_EXE!" -m venv venv
    if errorlevel 1 (
        echo Failed to craft magical venv. Please check Python installation.
        pause
        exit /b 1
    )
    echo Magical venv ready to enchant!
)

REM -----------------------------------
REM Step 3: Activate virtual environment
REM -----------------------------------
echo Step 3: Activating magical venv...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo Failed to activate magical venv. Please check venv creation.
    pause
    exit /b
)
echo Magical venv activated, glowing with arcane energy!

REM -----------------------------------
REM Step 4: Upgrade pip
REM -----------------------------------
echo Step 4: Sharpening pip’s claws...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo Failed to sharpen pip. Please check Python installation.
    pause
    exit /b
)
echo Pip sharpened, ready to strike!

REM -----------------------------------
REM Step 5: Install PyTorch
REM -----------------------------------
echo Step 5: Summoning PyTorch...
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124
if errorlevel 1 (
    echo Failed to summon PyTorch. Please check internet connection or pip.
    pause
    exit /b
)
echo PyTorch summoned, blazing with dragonfire!

REM -----------------------------------
REM Step 6: Summon Triton
REM -----------------------------------
echo Step 6: Summoning Triton...
curl -L -o triton-3.0.0-cp310-cp310-win_amd64.whl https://github.com/woct0rdho/triton-windows/releases/download/v3.1.0-windows.post9/triton-3.0.0-cp310-cp310-win_amd64.whl
if exist triton-3.0.0-cp310-cp310-win_amd64.whl (
    pip install triton-3.0.0-cp310-cp310-win_amd64.whl
    if errorlevel 1 (
        echo Failed to summon Triton. Please check the downloaded wheel file.
        pause
        exit /b
    )
    echo Triton summoned, wielding oceanic might!
) else (
    echo Triton wheel not found after download. Check your internet connection.
    pause
    exit /b
)

REM -----------------------------------
REM Step 7: Install SageAttention
REM -----------------------------------
echo Step 7: Summoning SageAttention...
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
    echo sageattention-1.0.6-py3-none-any.whl not found in %CD%.
    pause
    exit /b
)

REM -----------------------------------
REM Step 8: Install dependencies
REM -----------------------------------
echo Step 8: Summoning other dependencies...
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
REM Step 9: Forging C++ Redistributable
REM -----------------------------------
echo Step 9: Forging C++ Redistributable...
curl -L -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
if not exist vc_redist.x64.exe (
    echo Failed to download C++ Redistributable. Please check your internet connection.
    pause
    exit /b
)
vc_redist.x64.exe /quiet /install /norestart
if %errorlevel%==3010 (
    set RESTART_REQUIRED=1
)
if %errorlevel%==1 (
    echo Failed to forge C++ Redistributable. Please check the installer.
    pause
    exit /b
)
del vc_redist.x64.exe
echo C++ Redistributable forged, strengthening the dragon’s armor!

REM -----------------------------------
REM Step 10: Clear Triton cache
REM -----------------------------------
echo Step 10: Clearing Triton’s ancient cache...
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
REM Step 11: Create helper batch files
REM -----------------------------------
echo Step 11: Crafting mighty helper dragons...
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
REM -----------------------------------
REM Step 12: Check for required restart
REM -----------------------------------
if defined RESTART_REQUIRED (
    echo.
    echo Installation completed, but a system restart is required to finalize setup.
    echo Please restart your computer manually when ready.
    echo.
)
echo ✨✨✨ Installation complete! The dragons are ready to soar! ✨✨✨
echo Run "Run_FramePack.bat" to begin your journey!
pause
cmd.exe /k
