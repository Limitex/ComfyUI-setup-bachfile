@echo off
setlocal enabledelayedexpansion

call :CreateLink "ComfyUI\custom_nodes\ComfyUI-AnimateDiff-Evolved\models" "F:\models\Stable Diffusion AnimateDiff"
call :CreateLink "ComfyUI\custom_nodes\ComfyUI-AnimateDiff-Evolved\motion_lora" "F:\models\Stable Diffusion AnimateDiff Motion Lora"
call :CreateLink "ComfyUI\models\checkpoints" "F:\models\Stable Diffusion Checkpoint"
call :CreateLink "ComfyUI\models\controlnet" "F:\models\Stable Diffusion Controlnet"
call :CreateLink "ComfyUI\models\vae" "F:\models\Stable Diffusion Variational Autoencoder"
call :CreateLink "ComfyUI\models\loras" "F:\models\Stable Diffusion Lora"

endlocal
exit

:CreateLink
    set "dirPath=%~1"
    set "linkPath=%~2"

    for %%i in (%dirPath%) do set "dirname=%%~nxi"

    set "output="
    for /f "delims=" %%a in ('dir %dirPath%\.. ^| findstr /C:%dirname% ^| findstr /C:"<SYMLINKD>"') do set "output=%%a"
    if not defined output (
        for %%F in ("%dirPath%\*") do ( if %%~zF==0 del "%%F" )
        rd %dirPath%
        mklink /D "%dirPath%" "%linkPath%"
    )
goto :eof
