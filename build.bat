@echo off

setlocal enabledelayedexpansion

set IMAGE=glove80-zmk-config-docker

:: Set ZMK revision from first parameter, default to the pinned RGB fork commit
if "%~1"=="" (
	set ZMK_REVISION=8aeaaa66fbb4b94948c8763e06f1920ab0b69480
) else (
	set ZMK_REVISION=%~1
)

:: Build Docker image
docker build --build-arg "ZMK_REVISION=%ZMK_REVISION%" -t "%IMAGE%" .

:: Run Docker container
docker run --rm -v "%cd%:/config" -e UID=0 -e GID=0 "%IMAGE%"

endlocal
