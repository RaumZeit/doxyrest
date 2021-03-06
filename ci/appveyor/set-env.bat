::..............................................................................
::
::  This file is part of the Doxyrest toolkit.
::
::  Doxyrest is distributed under the MIT license.
::  For details see accompanying license.txt file,
::  the public copy of which is also available at:
::  http://tibbo.com/downloads/archive/doxyrest/license.txt
::
::..............................................................................

@echo off

:loop

if "%1" == "" goto :finalize
if /i "%1" == "msvc10" goto :msvc10
if /i "%1" == "msvc12" goto :msvc12
if /i "%1" == "msvc14" goto :msvc14
if /i "%1" == "x86" goto :x86
if /i "%1" == "i386" goto :x86
if /i "%1" == "amd64" goto :amd64
if /i "%1" == "x86_64" goto :amd64
if /i "%1" == "x64" goto :amd64

echo Invalid argument: '%1'
exit -1

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Toolchain

:msvc10
set TOOLCHAIN=msvc10
set CMAKE_GENERATOR=Visual Studio 10 2010
set LUA_TOOLCHAIN=vc10
shift
goto :loop

:msvc12
set TOOLCHAIN=msvc12
set CMAKE_GENERATOR=Visual Studio 12 2013
set LUA_TOOLCHAIN=vc12
shift
goto :loop

:msvc14
set TOOLCHAIN=msvc14
set CMAKE_GENERATOR=Visual Studio 14 2015
set LUA_TOOLCHAIN=vc14
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:: Platform

:x86
set TARGET_CPU=x86
set CMAKE_GENERATOR_SUFFIX=
set LUA_PLATFORM=Win32
shift
goto :loop

:amd64
set TARGET_CPU=amd64
set CMAKE_GENERATOR_SUFFIX= Win64
set LUA_PLATFORM=Win64
shift
goto :loop

:: . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

:finalize

if "%TOOLCHAIN%" == "" goto :msvc14
if "%TARGET_CPU%" == "" goto :amd64
if "%CONFIGURATION%" == "" (set CONFIGURATION=Release)
if not "%APPVEYOR_REPO_TAG_NAME%" == "" if "%TOOLCHAIN%" == "msvc10" if "%CONFIGURATION%" == "Release" (set BUILD_PACKAGE=ON)

set LUA_VERSION=5.3.3
set LUA_LIB_NAME=lua53
set LUA_DOWNLOAD_FILE=lua-%LUA_VERSION%_%LUA_PLATFORM%_%LUA_TOOLCHAIN%_lib.zip
set LUA_DOWNLOAD_URL=https://sourceforge.net/projects/luabinaries/files/%LUA_VERSION%/Windows%%20Libraries/Static/%LUA_DOWNLOAD_FILE%/download

set EXPAT_VERSION=2.1.0
set EXPAT_DOWNLOAD_FILE=expat-%EXPAT_VERSION%.tar.gz
set EXPAT_DOWNLOAD_URL=https://sourceforge.net/projects/expat/files/expat/%EXPAT_VERSION%/%EXPAT_DOWNLOAD_FILE%/download

set EXPAT_CMAKE_FLAGS= ^
	-DBUILD_shared=OFF ^
	-DBUILD_examples=OFF ^
	-DBUILD_tests=OFF ^
	-DBUILD_tools=OFF

set RAGEL_DOWNLOAD_FILE=ragel-68-visualstudio2012.7z
set RAGEL_DOWNLOAD_URL=http://downloads.yorickpeterse.com/files/%RAGEL_DOWNLOAD_FILE%

set CMAKE_CONFIGURE_FLAGS=-G "%CMAKE_GENERATOR%%CMAKE_GENERATOR_SUFFIX%"

set CMAKE_BUILD_FLAGS= ^
	--config %CONFIGURATION% ^
	-- ^
	/nologo ^
	/verbosity:minimal ^
	/consoleloggerparameters:Summary

echo ---------------------------------------------------------------------------
echo LUA_LIB_NAME:       %LUA_LIB_NAME%
echo LUA_DOWNLOAD_URL:   %LUA_DOWNLOAD_URL%
echo EXPAT_DOWNLOAD_URL: %EXPAT_DOWNLOAD_URL%
echo RAGEL_DOWNLOAD_URL: %RAGEL_DOWNLOAD_URL%
echo ---------------------------------------------------------------------------
