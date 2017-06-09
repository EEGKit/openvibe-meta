@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set BuildType=Release
set BuildOption=--release
set base_dir=%~dp0
set build_dir_base=%base_dir%\build
set install_dir_base=%base_dir%\dist
set dependencies_dir_designer=%base_dir%\sdk\dependencies

:parameter_parse
if /i "%1"=="-h" (
	echo Usage: win32-build.cmd [Build Type] [Init-env Script]
	echo -- Build Type option can be : --release (-r^), --debug (-d^). Default is Release.
	pause
	exit 0
) else if /i "%1"=="--help" (
	echo Usage: win32-build.cmd [Build Type] [Init-env Script]
	echo -- Build Type option can be : --release (-r^), --debug (-d^). Default is Release.
	pause
	exit 0
) else if /i "%1"=="-d" (
	set BuildType=Debug
	set BuildOption=--debug
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--debug" (
	set BuildType=Debug	
	set BuildOption=--debug
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="-r" (
	set BuildType=Release
	set BuildOption=--release
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--release" (
	set BuildType=Release
	set BuildOption=--release
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--build-dir" (
	set build_dir_base=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--install-dir" (
	set install_dir_base=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--dependencies-dir" (
	set dependencies_dir=--dependencies-dir %2
	set dependencies_dir_designer=%2
	SHIFT
	SHIFT
	Goto parameter_parse
)

set base_dir=%~dp0
echo Building sdk
cd %base_dir%\sdk\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\sdk-%BuildType% --install-dir %install_dir_base%\sdk-%BuildType% %dependencies_dir%

echo Building designer
cd %base_dir%\designer\scripts
call windows-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\designer-%BuildType% --install-dir %install_dir_base%\designer-%BuildType% --sdk %install_dir_base%\sdk-%BuildType% %dependencies_dir%

echo Building extras
cd %base_dir%\extras\scripts
call win32-build.cmd --no-pause %BuildOption% --build-dir %build_dir_base%\extras-%BuildType% --install-dir %install_dir_base%\extras-%BuildType% --certsdk %install_dir_base%\designer-%BuildType% --studiosdk %install_dir_base%\designer-%BuildType% %dependencies_dir%
