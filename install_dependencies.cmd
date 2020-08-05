@echo off
setlocal EnableDelayedExpansion
setlocal enableextensions 

REM The dependencies are hosted by Inria
set PROXYPASS=anon:anon
set URL=http://openvibe.inria.fr/dependencies/win32/3.0.0/

set base_dir=%~dp0
set dependencies_prefix=%base_dir%\dependencies
set platform_target=x86

:parameter_parse
if /i "%1"=="-h"  (
	echo Usage: install_dependencies.cmd [--dependencies-dir directoryprefix]
	echo -- 
	pause
	exit /B 0
) else if /i "%1"=="--help" (
	echo Usage: install_dependencies.cmd [--dependencies-dir directoryprefix]
	echo -- 
	pause
	exit /B 0	
) else if /i "%1"=="--dependencies-dir" (
	set dependencies_prefix=%2
	SHIFT
	SHIFT
	Goto parameter_parse
) else if /i "%1"=="--platform-target" (
	set platform_target=%2
	SHIFT
	SHIFT
	Goto parameter_parse	
) else if /i "%1" neq "" (
	echo Unknown parameter "%1"
	exit /b 1
)

if /i "%platform_target%"=="x86" (
	set dep_dir=%dependencies_prefix%
	set designer_manifest_file=.\windows-dependencies.txt
) else (
	set dep_dir=%dependencies_prefix%_%platform_target%
	set designer_manifest_file=.\windows-dependencies-%platform_target%.txt	
)

echo Installing dependencies for build target %platform_target%
echo The target folder is %dep_dir%

if not exist "%dep_dir%\arch\data" ( mkdir "%dep_dir%\arch\data" )
if not exist "%dep_dir%\arch\build\windows" ( mkdir "%dep_dir%\arch\build\windows" )


echo Installing sdk dependencies
cd %base_dir%\sdk\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-build-tools.txt -dest_dir %dep_dir%
call :check_errors !errorlevel! "Build tools" || exit /b !_errlevel!

powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-dependencies-%platform_target%.txt -dest_dir %dep_dir%
call :check_errors !errorlevel! "SDK" || exit /b !_errlevel!

powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\tests-data.txt -dest_dir %dep_dir%
call :check_errors !errorlevel! "SDK tests" || exit /b !_errlevel!


echo Installing Designer dependencies
cd %base_dir%\designer\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file %designer_manifest_file% -dest_dir %dep_dir%
call :check_errors !errorlevel! "Designer" || exit /b !_errlevel!

echo Installing OpenViBE extras dependencies
cd %base_dir%\extras\scripts
powershell.exe -NoProfile -ExecutionPolicy Bypass -file "%base_dir%\sdk\scripts\windows-get-dependencies.ps1" -manifest_file .\windows-dependencies-%platform_target%.txt -dest_dir %dep_dir%
call :check_errors !errorlevel! "Extras" || exit /b !_errlevel!

echo Creating OpenViBE extras dependency path setup script
set "dependency_cmd=%dep_dir%\windows-dependencies.cmd"
echo @ECHO OFF >%dependency_cmd%
echo. >>%dependency_cmd%
echo SET "dependencies_base=%dep_dir%" >>%dependency_cmd%
echo. >>%dependency_cmd%
type %base_dir%\extras\scripts\windows-dependencies.cmd-base >>%dependency_cmd%

echo Done.
exit /b 0

:check_errors
SET _errlevel=%1
SET _stageName=%2
if !_errlevel! neq 0 (
	echo Error while installing !_stageName! dependencies
	exit /b !_errlevel!
)

