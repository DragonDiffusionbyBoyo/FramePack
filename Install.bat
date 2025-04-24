@echo off
setlocal enabledelayedexpansion
title ✨ Dragon Diffusion FramePack Installer ✨
echo ✨✨✨ Dragon Diffusion FramePack installation process beginning... ✨✨✨

REM Create log file for error tracking
echo Dragon Diffusion Installation Log > install_log.txt
echo Started at %date% %time% >> install_log.txt
echo. >> install_log.txt

REM -----------------------------------
REM Step 0: Install wget and curl if missing
REM -----------------------------------
echo Step 0: Preparing download warriors (wget and curl)...

where wget >nul 2>nul
if %errorlevel% neq 0 (
    echo wget not found, installing...
    pip install wget >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon wget warrior! Check install_log.txt for clues.
        echo The dragon needs wget to fetch treasures. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_wget
        echo Fleeing the battlefield...
        pause
        exit /b
    )
)
:retry_wget

where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo curl not found or not available, attempting to install...
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

echo Download warriors ready!
REM -----------------------------------
REM Step 1: Check Python 3.10 presence
REM -----------------------------------
echo Step 1: Summoning Python 3.10...
set PYTHON=
for /f "tokens=*" %%i in ('where python3 2^>nul') do (
    set PYTHON=%%i
    for /f "tokens=2 delims= " %%v in ('"%%i" --version 2^>nul') do set PY_VERSION=%%v
    for /f "tokens=1,2 delims=." %%a in ("!PY_VERSION!") do (
        set PY_MAJOR=%%a
        set PY_MINOR=%%b
    )
    if "!PY_MAJOR!.!PY_MINOR!"=="3.10" (
        echo Python 3.10 found at !PYTHON!, ready to breathe fire!
        goto :python_found
    )
)

REM If Python 3.10 not found, try installing it
echo Python 3.10 not found. Summoning Python 3.10...
winget install -e --id Python.Python.3.10 --version 3.10.11 >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to summon Python 3.10! Check install_log.txt for clues.
    echo The dragon needs Python 3.10 to cast its spells. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_python
    echo Fleeing the battlefield...
    pause
    exit /b
)

REM Verify installation
for /f "tokens=*" %%i in ('where python3 2^>nul') do (
    set PYTHON=%%i
    for /f "tokens=2 delims= " %%v in ('"%%i" --version 2^>nul') do set PY_VERSION=%%v
    for /f "tokens=1,2 delims=." %%a in ("!PY_VERSION!") do (
        set PY_MAJOR=%%a
        set PY_MINOR=%%b
    )
    if "!PY_MAJOR!.!PY_MINOR!"=="3.10" (
        echo Python 3.10 installed at !PYTHON!, ready to breathe fire!
        goto :python_found
    )
)

echo [ERROR] Python 3.10 still not found after installation! Check install_log.txt for clues.
echo The dragon needs Python 3.10 to cast its spells. Press R to retry, or any key to flee...
set /p choice=Choice: 
if /i "!choice!"=="R" goto :retry_python
echo Fleeing the battlefield...
pause
exit /b

:retry_python
goto :Step1

:python_found

REM -----------------------------------
REM Step 2: Install Git
REM -----------------------------------
echo Step 2: Summoning Git...
winget install -e --id Git.Git >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to summon Git! Check install_log.txt for clues.
    echo The dragon needs Git to guard its hoard. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_git
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_git
echo Git summoned, ready to track the dragon’s hoard!

REM -----------------------------------
REM Step 3: Create virtual environment
REM -----------------------------------
echo Step 3: Crafting a magical venv in the Dragon’s Lair...
if exist venv (
    echo Magical venv already exists, shimmering with power!
) else (
    "%PYTHON%" -m venv venv >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to craft magical venv! Check install_log.txt for clues.
        echo The dragon needs a lair to rest. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_venv
        echo Fleeing the battlefield...
        pause
        exit /b
    )
)
:retry_venv
echo Magical venv ready to enchant!

REM -----------------------------------
REM Step 4: Activate virtual environment
REM -----------------------------------
echo Step 4: Activating magical venv...
call venv\Scripts\activate.bat >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to activate magical venv! Check install_log.txt for clues.
    echo The dragon can’t enter its lair. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_activate
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_activate
echo Magical venv activated, glowing with arcane energy!

REM -----------------------------------
REM Step 5: Upgrade pip
REM -----------------------------------
echo Step 5: Sharpening pip’s claws...
python -m pip install --upgrade pip >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to sharpen pip’s claws! Check install_log.txt for clues.
    echo The dragon needs a sharp pip to hunt. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_pip
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_pip
echo Pip sharpened, ready to strike!

REM -----------------------------------
REM Step 6: Install PyTorch
REM -----------------------------------
echo Step 6: Summoning PyTorch...
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124 >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to summon PyTorch! Check install_log.txt for clues.
    echo The dragon needs PyTorch’s fire to blaze. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_pytorch
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_pytorch
echo PyTorch summoned, blazing with dragonfire!

REM -----------------------------------
REM Step 7: Summon Triton
REM -----------------------------------
echo Step 7: Summoning Triton...
curl -L -o triton-3.0.0-cp310-cp310-win_amd64.whl https://github.com/woct0rdho/triton-windows/releases/download/v3.1.0-windows.post9/triton-3.0.0-cp310-cp310-win_amd64.whl >> install_log.txt 2>&1
if exist triton-3.0.0-cp310-cp310-win_amd64.whl (
    pip install triton-3.0.0-cp310-cp310-win_amd64.whl >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon Triton! Check install_log.txt for clues.
        echo The dragon needs Triton’s oceanic might. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_triton
        echo Fleeing the battlefield...
        pause
        exit /b
    )
) else (
    echo [ERROR] Triton wheel not found after download! Check install_log.txt for clues.
    echo The dragon’s oceanic ally is missing. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_triton
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_triton
echo Triton summoned, wielding oceanic might!

REM -----------------------------------
REM Step 8: Install SageAttention (from current directory)
REM -----------------------------------
echo Step 8: Summoning SageAttention...
set SAGEATTENTION_WHEEL=.\sageattention-1.0.6-py3-none-any.whl
echo Checking for SageAttention at %CD%\%SAGEATTENTION_WHEEL%
if exist "%SAGEATTENTION_WHEEL%" (
    pip install "%SAGEATTENTION_WHEEL%" >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon SageAttention! Check install_log.txt for clues.
        echo The dragon needs SageAttention’s wisdom. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_sageattention
        echo Fleeing the battlefield...
        pause
        exit /b
    )
) else (
    echo [ERROR] SageAttention-0.0.1-cp310-cp310-win_amd64.whl not found in %CD%! Check install_log.txt for clues.
    echo The dragon’s wise ally is missing. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_sageattention
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_sageattention
echo SageAttention summoned, wise and powerful!

REM -----------------------------------
REM Step 9: Install dependencies
REM -----------------------------------
echo Step 9: Summoning other dependencies...
if exist requirements.txt (
    pip install -r requirements.txt >> install_log.txt 2>&1
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to summon dependencies! Check install_log.txt for clues.
        echo The dragon needs its allies from requirements.txt. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_requirements
        echo Fleeing the battlefield...
        pause
        exit /b
    )
) else (
    echo [ERROR] requirements.txt not found in %CD%! Check install_log.txt for clues.
    echo The dragon’s army list is missing. Press R to retry, or any key to skip...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_requirements
    echo Skipping dependency installation...
)
:retry_requirements
echo Dependencies summoned, ready to support the dragon!

REM -----------------------------------
REM Step 10: Install C++ Redistributable
REM -----------------------------------
echo Step 10: Forging C++ Redistributable...
curl -L -o vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe >> install_log.txt 2>&1
vc_redist.x64.exe /quiet /install >> install_log.txt 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to forge C++ Redistributable! Check install_log.txt for clues.
    echo The dragon’s armor needs strengthening. Press R to retry, or any key to flee...
    set /p choice=Choice: 
    if /i "!choice!"=="R" goto :retry_vcredist
    echo Fleeing the battlefield...
    pause
    exit /b
)
:retry_vcredist
echo C++ Redistributable forged, strengthening the dragon’s armor!

REM -----------------------------------
REM Step 11: Install FFmpeg
REM -----------------------------------
echo Checking for FFmpeg...
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
        echo The dragon needs FFmpeg for video sorcery. Press R to retry, or any key to flee...
        set /p choice=Choice: 
        if /i "!choice!"=="R" goto :retry_ffmpeg
        echo Fleeing the battlefield...
        pause
        exit /b
    )
    echo FFmpeg installed to local directory, ready for video sorcery!
)
:retry_ffmpeg

REM -----------------------------------
REM Step 12: Clear Triton cache
REM -----------------------------------
echo Step 11: Clearing Triton’s ancient cache...
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