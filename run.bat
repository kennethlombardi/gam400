::----------------------------------------------------------------::
:: Copyright (c) 2010-2011 Zipline Games, Inc.
:: All Rights Reserved.
:: http://getmoai.com
::----------------------------------------------------------------::

@echo off

:: verify paths
echo Bin = %MOAI_BIN%
echo Config = %MOAI_CONFIG%

if not exist "%MOAI_BIN%\moai.exe" (
	echo.
	echo --------------------------------------------------------------------------------
	echo ERROR: The MOAI_BIN environment variable either doesn't exist or it's pointing
	echo to an invalid path. Please point it at a folder containing moai.exe.
	echo --------------------------------------------------------------------------------
	echo.
	
	goto end
)

if not exist "%MOAI_CONFIG%" (
	echo.
	echo -------------------------------------------------------------------------------
	echo WARNING: The MOAI_CONFIG environment variable either doesn't exist or it's 
	echo pointing to an invalid path. Please point it at a folder containing config.lua.
	echo -------------------------------------------------------------------------------
	echo.
)

:: run moai
"%MOAI_BIN%/moai" "%MOAI_CONFIG%/config.lua" "%MOAI_SOURCE%/main.lua"

:end
pause