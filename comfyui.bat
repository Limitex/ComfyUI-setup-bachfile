@echo off
setlocal enabledelayedexpansion

for %%X in (ffmpeg ffplay ffprobe) do (
    where /q %%X
    if errorlevel 1 (
        echo %%X not found. Please check your installation.
        echo https://github.com/BtbN/FFmpeg-Builds/releases
        pause
        exit /b 1
    )
)

if not exist ".env" python -m venv .env
set "activate=%cd%\.env\scripts\Activate.ps1"

powershell -Command "%activate%; python -m pip install --upgrade pip"
powershell -Command "%activate%; pip install torch torchvision torchaudio --upgrade --extra-index-url https://download.pytorch.org/whl/cu121"
powershell -Command "%activate%; pip install onnxruntime-gpu"

call :GitClone https://github.com/comfyanonymous/ComfyUI.git

cd ComfyUI/custom_nodes
    call :GitClone https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved.git
    call :GitClone https://github.com/FizzleDorf/ComfyUI_FizzNodes.git
    call :GitClone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git
    call :GitClone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
    call :GitClone https://github.com/Fannovel16/comfyui_controlnet_aux.git
cd ../../

PowerShell -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c cd /d "%cd%" && comfyui-link.bat && pause'"

powershell -Command "%activate%; python ComfyUI/main.py" --auto-launch --listen localhost --port 80 --output-directory "E:\AI\Generates\ComfyUI"

endlocal
exit

:GitClone
    set "remoteuri=%~1"
    for %%i in (%remoteuri%) do set "localdir=%%~ni"
    git clone %remoteuri% || git -C %localdir% pull
    if exist "%localdir%/requirements.txt" (
        powershell -Command "%activate%; pip install -r %localdir%/requirements.txt"
    )
goto :eof

:: usage: main.py [-h] [--listen [IP]] [--port PORT] [--enable-cors-header [ORIGIN]] [--max-upload-size MAX_UPLOAD_SIZE]
::                [--extra-model-paths-config PATH [PATH ...]] [--output-directory OUTPUT_DIRECTORY]
::                [--temp-directory TEMP_DIRECTORY] [--input-directory INPUT_DIRECTORY] [--auto-launch]
::                [--disable-auto-launch] [--cuda-device DEVICE_ID] [--cuda-malloc | --disable-cuda-malloc]
::                [--dont-upcast-attention] [--force-fp32 | --force-fp16] [--bf16-unet]
::                [--fp16-vae | --fp32-vae | --bf16-vae]
::                [--fp8_e4m3fn-text-enc | --fp8_e5m2-text-enc | --fp16-text-enc | --fp32-text-enc]
::                [--directml [DIRECTML_DEVICE]] [--disable-ipex-optimize]
::                [--preview-method [none,auto,latent2rgb,taesd]]
::                [--use-split-cross-attention | --use-quad-cross-attention | --use-pytorch-cross-attention]
::                [--disable-xformers] [--gpu-only | --highvram | --normalvram | --lowvram | --novram | --cpu]
::                [--disable-smart-memory] [--dont-print-server] [--quick-test-for-ci] [--windows-standalone-build]
::                [--disable-metadata]