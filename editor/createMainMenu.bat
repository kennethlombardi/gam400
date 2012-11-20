::----------------------------------------------------------------::
:: Copyright (c) 2010-2011 Zipline Games, Inc.
:: All Rights Reserved.
:: http://getmoai.com
::----------------------------------------------------------------::

@echo off

:: run moai
"C:\cygwin\home\Kenneth\github\gam400\hosts\win32\moai" "%MOAI_CONFIG%\config.lua" "createMainMenu.lua"
copy .\generated\mainMenu.lua C:\cygwin\home\Kenneth\github\gam400\resources\layers
:end
pause