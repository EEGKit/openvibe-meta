@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions

set baseDir=%~dp0
set dependenciesDir=%baseDir%\dependencies
set platformTarget=x64
set buildType=Release
set generator="Ninja"
set buildTool=Ninja

:parameter_parse
if /i "%1"=="-h" (
	Goto print_usage
) else if /i "%1"=="--help" (
	Goto print_usage
) else if /i "%1"=="--debug" (
	set buildType=Debug
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--release" (
	set buildType=Release
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsbuild" (
	set generator="Visual Studio 12 2013 Win64" -T "v120"
	set buildTool=VS
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--platform-target" (
	set platformTarget=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1" neq "" (
	echo Unknown parameter "%1"
	Goto print_usage
)

if /i "%platformTarget%" neq "x86" (
	SET dependenciesDir=%dependenciesDir%_%platformTarget%
)

rem ### Build Tools
set PATH=%dependenciesDir%/cmake/bin;%PATH%
set PATH=%dependenciesDir%/ninja;%PATH%

call .\windows-init-env.cmd --platform-target %platformTarget%

echo generator for cmake is: %generator%

mkdir %baseDir%\build\
cd %baseDir%\build\

if %buildTool% == Ninja (
	cmake .. -G %generator% -DCMAKE_BUILD_TYPE=%buildType% -DBUILD_ARCH=%platformTarget%
	if not "!ERRORLEVEL!" == "0" goto terminate_error
	
	ninja install
	if not "!ERRORLEVEL!" == "0" goto terminate_error
) else (
	cmake .. -G %generator% -DBUILD_ARCH=%platformTarget%
	if not "!ERRORLEVEL!" == "0" goto terminate_error
	
	msbuild OpenVIBE.sln /p:Configuration=%buildType% /p:Platform=%platformTarget%
	if not "!ERRORLEVEL!" == "0" goto terminate_error
	
	cmake --build . --config %buildType% --target install
	if not "!ERRORLEVEL!" == "0" goto terminate_error
)

:terminate_success
exit 0

:terminate_error
echo.
echo An error occured during building process !
echo.
exit /b 1
 
:print_usage
echo "Usage: build.cmd [--debug|--release] [--vsbuilld] [--platform-target <target>]"
echo "    --debug to build in debug, or --release to build release. Default is release"
echo "    --vsbuild generates visual studio solution!. Default is Ninja"
echo "    --platform-target <target>. Options are "x64" and "x86". Default is x64."
pause
exit 0

