@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library extends the svn utility with additional convinience functions.
:: For bare gsvnit functionality use svn command line directly. 
:: Type 'svn --help' for more information
::------------------------------------------------------------------------------


::------------------------------------------------------------------------------
::   Function section 
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:isSvnInstalled
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:downloadSvn
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:installSvn
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:canReachRemoteSvn
:: Elevates error level if url is not reachable as e.g. your device is offline. 
::
::     call svnlib :canReachRemoteSvn %U%  
::
:: U: a url
::
:: Examples:
::     call svnlib :canReachRemoteSvn "https://github.com/tiefeand/cmd"

:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:isSvnCheckout
:: Elevates ERRORLEVEL if path is not an svn checkout. Note that unlike
:: :canReachRemoteSvn this will also return ERRORLEVEL = 0 if machine is offline
::
::     call svnlib :isSvnCheckout %P%  
::
:: P: an accessible path
::
:: Examples:
::     call svnlib :isSvnCheckout "C:\Repo\cmd"

setlocal
for %%i in ("%~1\.svn") do if not exist %%~si\NUL (call base :false) else (call base :true)
if %ERRORLEVEL% NEQ 0 (echo."ERROR: Not an svn checkout")

:: ALTERNATIVELY -----------------------------------------------
:: check by accessing server information 
rem svn info --non-interactive --trust-server-cert %~1 1>NUL

:: check by accessing server information via retrieving the URL
rem set URL=
rem call :retrieveSvnRemoteUrl "%~1" URL
rem if defined URL (call base :true) else (call base :false)

endlocal
goto :EOF


::------------------------------------------------------------------------------
:retrieveSvnRemoteUrl
:: Elevates ERRORLEVEL if url is not found. 
::
::     call svnlib :retrieveSvnRemoteUrl %U% VAR
::
:: U: an accessible url or path
:: VAR: a variable name passed by reference in order to be written on
::
:: Examples:
::     set "URL=
::     call svnlib :retrieveSvnRemoteUrl "C:\Repo\cmd" URL

setlocal
for /f "tokens=*" %%a in ('svn info --show-item repos-root-url %~1') do set "svnurl=%%~a"

if defined svnurl (call base :true) else (call base :false)
if not defined svnurl (echo."ERROR: Not an svn repo or checkout")

(endlocal & rem return values
    if "%~2" NEQ "" (set %~2=%svnurl%) else (echo.%svnurl%)
)
goto :EOF


::------------------------------------------------------------------------------
:svnGracefulCheckout
:: Checks out an svn repo. 
:: Use svn's native 'svn co' command in case sanity check are not required.
::
::     call svnlib :svnGracefulCheckout %U% %P%
::
:: U: an accessible url
:: P: an accessible path
::
:: Examples:
::     call svnlib :svnGracefulCheckout "https://svn/cmd"
::     call svnlib :svnGracefulCheckout "https://svn/cmd" "C:\Repo\cmd"

setlocal
call svnlib :canReachRemoteSvn "%~1"
if %ERRORLEVEL% EQU 0 (
    svn co %~1 %~2
)
endlocal
goto :EOF


::------------------------------------------------------------------------------
:svnGracefulCleanup
:: Cleans up a check out
:: Use svn's native 'svn cleanup' command in case sanity check are not required.
::
::     call svnlib :svnGracefulCleanup %P%
::
:: P: an accessible path
::
:: Examples:
::     call svnlib :svnGracefulCleanup "C:\Repo\cmd"

setlocal
call svnlib :canReachRemoteSvn "%~1"
call svnlib :isSvnCheckout "%~1"
if %ERRORLEVEL% EQU 0 (
    svn cleanup %~1
)
endlocal
goto :EOF


::------------------------------------------------------------------------------
:svnGracefulUpdate
:: Updates a check out
:: Use svn's native 'svn update' command in case sanity check are not required.
::
::     call svnlib :svnGracefulUpdate %P%
::
:: P: an accessible path
::
:: Examples:
::     call svnlib :svnGracefulUpdate "C:\Repo\cmd"

setlocal
call svnlib :canReachRemoteSvn "%~1"
call svnlib :isSvnCheckout "%~1"
if %ERRORLEVEL% EQU 0 (
    svn update %~1
)
endlocal
goto :EOF