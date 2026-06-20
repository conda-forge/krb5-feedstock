set NO_LEASH=1
setlocal enabledelayedexpansion

:: Finds stdint.h from msinttypes.
set INCLUDE=%LIBRARY_INC%;%INCLUDE%

:: Set the install path
set KRB_INSTALL_DIR=%LIBRARY_PREFIX%

:: Need this set or libs/Makefile fails
set VISUALSTUDIOVERSION=%VS_MAJOR%0

if not "%build_platform%"=="%target_platform%" (
    set CPU=ARM64
    >"!SRC_DIR!\cc_for_build.bat" (
        echo @echo off
        echo set "LIB=!LIB_FOR_BUILD!"
        echo set "INCLUDE=!INCLUDE_FOR_BUILD!"
        echo "!CC_FOR_BUILD!" %%*
    )
    set "CC_FOR_BUILD=!SRC_DIR!\cc_for_build.bat"
)

cd src

:: Create Makefile for Windows.
nmake -f Makefile.in prep-windows
if errorlevel 1 exit 1

:: Build the sources
nmake NODEBUG=1
if errorlevel 1 exit 1

:: Copy headers, libs, executables.
nmake install NODEBUG=1
if errorlevel 1 exit 1
