set NO_LEASH=1

:: Finds stdint.h from msinttypes.
set INCLUDE=%LIBRARY_INC%;%INCLUDE%

:: Set the install path
set KRB_INSTALL_DIR=%LIBRARY_PREFIX%

:: Need this set or libs/Makefile fails
set VISUALSTUDIOVERSION=%VS_MAJOR%0

if "%target_platform%"=="win-arm64" set CPU=ARM64
if "%target_platform%"=="win-arm64" for %%I in ("%VCToolsInstallDir%bin\Hostx64\x64\cl.exe") do set "CC_FOR_BUILD=%%~sI"
if "%target_platform%"=="win-arm64" if not defined BUILD_VC_LIB for %%I in ("%VCToolsInstallDir%lib\x64") do set "BUILD_VC_LIB=%%~sI"
if "%target_platform%"=="win-arm64" if not defined BUILD_UCRT_LIB for %%I in ("%WindowsSdkDir%Lib\%WindowsSDKLibVersion%ucrt\x64") do set "BUILD_UCRT_LIB=%%~sI"
if "%target_platform%"=="win-arm64" if not defined BUILD_UM_LIB for %%I in ("%WindowsSdkDir%Lib\%WindowsSDKLibVersion%um\x64") do set "BUILD_UM_LIB=%%~sI"
if "%target_platform%"=="win-arm64" if not defined BUILD_CCLINKOPTION set "BUILD_CCLINKOPTION=/link /LIBPATH:%BUILD_VC_LIB% /LIBPATH:%BUILD_UCRT_LIB% /LIBPATH:%BUILD_UM_LIB%"

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
