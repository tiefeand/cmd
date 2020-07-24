@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library extends the git utility with additional convinience functions.
:: For bare git functionality use git command line directly. 
:: Type 'git --help' for more information
::------------------------------------------------------------------------------


::------------------------------------------------------------------------------
::   Function section 
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:isGitInstalled
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:downloadGit
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:installGit
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:canReachRemoteGit
:: Elevates error level if url is not reachable as e.g. your device is offline. 
::
::     call gitlib :canReachRemoteGit %U%  
::
:: U: a url
::
:: Examples:
::     call gitlib :canReachRemoteGit "https://github.com/tiefeand/cmd"

setlocal
git ls-remote -h %~1
endlocal
goto :EOF


::------------------------------------------------------------------------------
:isLocalGitRepo
:: Elevates ERRORLEVEL if path is not a git repo. Note that unlike
:: :canReachRemoteGit this will also return ERRORLEVEL = 0 if machine is offline
::
::     call gitlib :isLocalGitRepo %P%  
::
:: P: an accessible path
::
:: Examples:
::     call gitlib :isLocalGitRepo "C:\Repo\cmd"

setlocal
for %%i in ("%~1\.git") do if not exist %%~si\NUL (call base :false) else (call base :true)
rem if %ERRORLEVEL% NEQ 0 (echo."ERROR: Not a git repository")
endlocal
goto :EOF


::------------------------------------------------------------------------------
:gitPullOrClone
:: Clones if there is no working copy otherwise pulls latest changes on the working copy
::
::     call gitlib :gitPullOrClone %U% %P%
::
:: U: an accessible url
:: P: the local path to which to check out
::
:: Examples:
::     call gitlib :gitPullOrClone "https://github.com/tiefeand/cmd"
::     call gitlib :gitPullOrClone "https://github.com/tiefeand/cmd" "C:\Repo\subpath"
:gitPullOrClone
setlocal
set $gitLocalPath=%~2
call gitlib :isLocalGitRepo "%$gitLocalPath%" 
if %ERRORLEVEL% EQU 0 (
	git pull %$gitLocalPath%
) else (
    git clone %~1 %$gitLocalPath%
)
endlocal
goto :EOF


::------------------------------------------------------------------------------
:gitGracefulClone
:: Clones a git repo
:: Use gits's native 'git clone' command in case sanity check are not required.
::
::     call gitlib :gitGracefulClone %U% %P%
::
:: U: an accessible url
:: P: an accessible path
::
:: Examples:
::     call gitlib :gitGracefulClone "https://github.com/tiefeand/cmd"
::     call gitlib :gitGracefulClone "https://github.com/tiefeand/cmd" "C:\Repo\cmd"

setlocal
call gitlib :canReachRemoteGit "%~1"
if %ERRORLEVEL% EQU 0 (
    git clone %~1 %~2
)
endlocal
goto :EOF


::------------------------------------------------------------------------------
:gitGracefulPull
:: Pulls from a remote git repo
:: Use gits's native 'git pull' command in case sanity check are not required.
::
::     call gitlib :gitGracefulPull %P%
::
:: P: an accessible path
::
:: Examples:
::     call gitlib :gitGracefulPull "C:\Repo\cmd"

setlocal
call gitlib :canReachRemoteGit "%~1"
call gitlib :isLocalGitRepo "%~1"
if %ERRORLEVEL% EQU 0 (
    git pull %~1
)
endlocal
goto :EOF



