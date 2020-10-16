@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

set BuildType=Release
set BuildOption=--release
set base_dir=%~dp0
set build_dir_base=%base_dir%\build
set install_dir_base=%base_dir%\dist
set dependencies_dir=%base_dir%\dependencies
set UserDataSubdir=openvibe-3.0.0-beta
set PlatformTarget=x64

:parameter_parse
if /i "%1"=="-h" (
	echo Usage: build.cmd [Build Type] [Init-env Script]
	echo -- Build Type option can be : --release (-r^), --debug (-d^). Default is Release.
	pause
	exit 0
) else if /i "%1"=="--help" (
	echo Usage: build.cmd [Build Type] [Init-env Script]
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
	set dependencies_dir=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsproject" (
	set vsbuild=--vsproject
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsbuild" (
	set vsbuild=--vsbuild
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--vsbuild-all" (
	set multibuild_all=TRUE
	SHIFT
	Goto parameter_parse
) else if /i "%1" == "--userdata-subdir" (
	set UserDataSubdir=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1" == "--platform-target" (
	set PlatformTarget=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1" neq "" (
	echo Unknown parameter "%1"
	exit /b 1
)

if /i "%PlatformTarget%" neq "x86" (
	SET dependencies_dir=%dependencies_dir%_%PlatformTarget%
)

if not defined multibuild_all (
	REM the default build
	
	echo Building sdk
	cd %base_dir%\sdk\scripts
	call windows-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\sdk-%BuildType%-%PlatformTarget% --install-dir %install_dir_base%\sdk-%BuildType%-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --build-unit --build-validation --test-data-dir %dependencies_dir%\test-input --platform-target %PlatformTarget%  
	call :check_errors !errorlevel! "!BuildType! SDK" || exit /b !_errlevel!

	echo Building designer
	cd %base_dir%\designer\scripts
	call windows-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\designer-%BuildType%-%PlatformTarget% --install-dir %install_dir_base%\designer-%BuildType%-%PlatformTarget% --sdk %install_dir_base%\sdk-%BuildType%-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "!BuildType! Designer" || exit /b !_errlevel!

	echo Building extras
	cd %base_dir%\extras\scripts
	call windows-build.cmd --no-pause %vsbuild% %BuildOption% --build-dir %build_dir_base%\extras-%BuildType%-%PlatformTarget% --install-dir %install_dir_base%\extras-%BuildType%-%PlatformTarget% --sdk %install_dir_base%\sdk-%BuildType%-%PlatformTarget% --designer %install_dir_base%\designer-%BuildType%-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "!BuildType! Extras" || exit /b !_errlevel!
	
) else (
	REM a build that creates a visual studio solution
	
	echo Building sdk
	cd %base_dir%\sdk\scripts
	call windows-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\sdk-%PlatformTarget% --install-dir %install_dir_base%\sdk-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --build-unit --build-validation --test-data-dir %dependencies_dir%\test-input --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Debug SDK" || exit /b !_errlevel!
	
	call windows-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\sdk-%PlatformTarget% --install-dir %install_dir_base%\sdk-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --build-unit --build-validation --test-data-dir %dependencies_dir%\test-input --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Release SDK" || exit /b !_errlevel!
	
	echo Building designer
	cd %base_dir%\designer\scripts
	call windows-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\designer-%PlatformTarget% --install-dir %install_dir_base%\designer-%PlatformTarget% --sdk %install_dir_base%\sdk-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Debug Designer" || exit /b !_errlevel!
	
	call windows-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\designer-%PlatformTarget% --install-dir %install_dir_base%\designer-%PlatformTarget% --sdk %install_dir_base%\sdk-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Release Designer" || exit /b !_errlevel!

	echo Building extras
	cd %base_dir%\extras\scripts
	call windows-build.cmd --no-pause --vsbuild --debug --build-dir %build_dir_base%\extras-%PlatformTarget% --install-dir %install_dir_base%\extras-%PlatformTarget% --sdk %install_dir_base%\sdk-%PlatformTarget% --designer %install_dir_base%\designer-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Debug Extras" || exit /b !_errlevel!
	
	call windows-build.cmd --no-pause --vsbuild --release --build-dir %build_dir_base%\extras-%PlatformTarget% --install-dir %install_dir_base%\extras-%PlatformTarget% --sdk %install_dir_base%\sdk-%PlatformTarget% --designer %install_dir_base%\designer-%PlatformTarget% --dependencies-dir %dependencies_dir% --userdata-subdir %UserDataSubdir% --platform-target %PlatformTarget%
	call :check_errors !errorlevel! "Release Extras" || exit /b !_errlevel!
	
	echo Generating meta project
	where /q python
	if !errorlevel! neq 0 (
		echo Python not in path, trying C:\python34\python ...
		set my_python=C:\python34\python
	) else (
		set my_python=python
	)
	!my_python! %base_dir%\visual_gen\generateVS.py --platformtarget %PlatformTarget% --builddir %build_dir_base% --outsln %build_dir_base%\OpenViBE-Meta-%PlatformTarget%.sln
	if !errorlevel! neq 0 (
		echo Error constructing the meta .sln file
		exit /b !errorlevel!
	)
)


:check_errors
SET _errlevel=%1
SET _stageName=%2
if !_errlevel! neq 0 (
	echo Error while building !_stageName!
	exit /b !_errlevel!
)

