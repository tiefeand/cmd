@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library hosts various useful functions that are useful in the area of 
:: filesystem, path manipulations, etc.
::------------------------------------------------------------------------------


::------------------------------------------------------------------------------
::   Function section 
::------------------------------------------------------------------------------


:currentfoldername


:currentpath


:isOlderThan


:isAbsPath


:toAbsPath              
::                      -- makes a file name absolute considering a base path
::                      -- file [in,out] - variable with file name to be converted, or file name itself for result in stdout
::                      -- base [in,opt] - base path, leave blank for current directory
SETLOCAL ENABLEDELAYEDEXPANSION
set "src=%~1"
if defined %1 set "src=!%~1!"
set "bas=%~2"
if not defined bas set "bas=%cd%"
for /f "tokens=*" %%a in ("%bas%.\%src%") do set "src=%%~fa"
rem if %1 is a defined environment variable (not a string nor "set a=" but e.g. "set a=abc")
( ENDLOCAL & REM RETURN VALUES
    IF defined %1 (SET %~1=%src%) ELSE ECHO.%src%
)
EXIT /b


:isRelPath
:freeKiloBytes


:getDriveInfo
