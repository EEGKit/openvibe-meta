@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set base_dir=%~dp0
set dependencies_dir=%base_dir%\dependencies
set PlatformTarget=x64

if /i "%PlatformTarget%" neq "x86" (
	SET dependencies_dir=%dependencies_dir%_%PlatformTarget%
)

rem ### Build Tools
set PATH=%dependencies_dir%/cmake/bin;%PATH%
set PATH=%dependencies_dir%/ninja;%PATH%

call .\windows-init-env.cmd --platform-target %PlatformTarget%

rem SET generator="Visual Studio 12 2013 Win64" -T "v120"
SET generator=Ninja

echo generator for cmake is: %generator%

mkdir %base_dir%\build\
cd %base_dir%\build\
cmake .. -G %generator% -DCMAKE_BUILD_TYPE=Release
ninja install
rem cmake --build . --target install

