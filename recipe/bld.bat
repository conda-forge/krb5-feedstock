set NO_LEASH=1

:: Finds stdint.h from msinttypes.
set INCLUDE=%LIBRARY_INC%;%INCLUDE%

:: Set the install path
set KRB_INSTALL_DIR=%LIBRARY_PREFIX%

:: Need this set or libs/Makefile fails
set VISUALSTUDIOVERSION=%VS_MAJOR%0

if not "%build_platform%"=="%target_platform%" (
    :: prep-windows uses CPU while generating the Windows makefiles.
    set CPU=ARM64
)

cd src

:: Create Makefile for Windows.
nmake -f Makefile.in prep-windows
if errorlevel 1 exit 1

if not "%build_platform%"=="%target_platform%" (
    :: After prep-windows, prebuild the helper executables into the paths nmake expects.
    setlocal
    set "LIB=%LIB_FOR_BUILD%"
    set "INCLUDE=%INCLUDE_FOR_BUILD%"

    if not exist "obj\%CPU%\rel" mkdir "obj\%CPU%\rel"
    "%CC_FOR_BUILD%" -Feobj\%CPU%\rel\wconfig.exe -Foobj\%CPU%\rel\wconfig.obj wconfig.c
    if errorlevel 1 exit 1

    if not exist "util\windows\obj\%CPU%\rel" mkdir "util\windows\obj\%CPU%\rel"
    "%CC_FOR_BUILD%" -Feutil\windows\obj\%CPU%\rel\libecho.exe -Foutil\windows\obj\%CPU%\rel\libecho.obj util\windows\libecho.c
    if errorlevel 1 exit 1
    endlocal
)

:: Build the sources
nmake NODEBUG=1
if errorlevel 1 exit 1

:: Copy headers, libs, executables.
nmake install NODEBUG=1
if errorlevel 1 exit 1
