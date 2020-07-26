@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library extends the git utility with additional convenience functions.
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
:: Elevates error level if url is not reachable, hence when server connection is
:: down
::
::     call gitlib :canReachRemoteGit %U%  
::
:: U: a url
::
:: Examples:
::     call gitlib :canReachRemoteGit "https://github.com/tiefeand/remote"

setlocal
git ls-remote -h %1
endlocal
goto :EOF


::------------------------------------------------------------------------------
:isLocalGitRepo
:: Elevates ERRORLEVEL if path %P% is not a git repo. Note that the ERRORLEVEL
:: is 0 even if a connection to the server is down. If no path %P% is provided
:: the current directory %CD% is used.
::
::     call gitlib :isLocalGitRepo 
::     call gitlib :isLocalGitRepo %P%  
::
:: P: an accessible path
::
:: Examples:
::     call gitlib :isLocalGitRepo
::     call gitlib :isLocalGitRepo "C:\Repo\local"

setlocal
if "%~1" EQU "" (set folderpath=%CD%) else (set folderpath=%~1)
for %%i in ("%folderpath%\.git") do if not exist %%~si\NUL (call base :false) else (call base :true)
rem if %ERRORLEVEL% NEQ 0 (echo."ERROR: Not a git repository")
endlocal
goto :EOF


::------------------------------------------------------------------------------
:isUpToDate
:: Elevates ERRORLEVEL if repository path %L% is not uptodate compared to its 
:: remote. %R% may be a remote URL or a remote name such as registered. If not 
:: provided the default (origin) will be taken. 'git remote -v'.
::
::     call gitlib :isUpToDate 
::     call gitlib :isUpToDate %L% 
::     call gitlib :isUpToDate %L% %R%
::     call gitlib :isUpToDate %R%
::
:: L: the local repository path
:: R: an accessible url or an accessable remote path containing a remote repository
::
::     call gitlib :isUpToDate
::     call gitlib :isUpToDate "C:\Repo\local"
::     call gitlib :isUpToDate "C:\Repo\local" "https://github.com/tiefeand/remote"
::     call gitlib :isUpToDate "https://github.com/tiefeand/remote"

setlocal

endlocal
goto :EOF


::------------------------------------------------------------------------------
:hasNewerTag
:: Elevates ERRORLEVEL if repository path %L% has newer tag on its remote. %R% 
:: may be a remote URL or a remote name such as registered 'git remote -v'.
::
::     call gitlib :hasNewerTag 
::     call gitlib :hasNewerTag %L% 
::     call gitlib :hasNewerTag %L% %R%
::     call gitlib :hasNewerTag %R%
::
:: L: the local repository path
:: R: an accessible url or an accessable remote path containing a remote repository
::
:: Examples:
::     call gitlib :hasNewerTag
::     call gitlib :hasNewerTag "C:\Repo\local"
::     call gitlib :hasNewerTag "C:\Repo\local" "https://github.com/tiefeand/remote"
::     call gitlib :hasNewerTag "https://github.com/tiefeand/remote"

setlocal

endlocal
goto :EOF


::------------------------------------------------------------------------------
:gitPullOrClone
:: Pulls in latest changes on a local repository. However there can be no pull if the 
:: histories don't match or if the provided destination path does not contain any 
:: repository yet. When the pull was unsuccessful and the destination path is empty
:: and the remote url is valid and accessible, a clone will be performed. 
:: Consider various use cases with using either or both of the below parameters:
::
:: R: an accessible url or an accessable remote path containing a remote repository
:: L: the local repository path
::
:: 1.
::     call gitlib :gitPullOrClone
::
:: If the current path contains a repository, this scenario pulls from an implicite 
:: remote repository to the current directory.(%CD%)
::
:: 2.
::     call gitlib :gitPullOrClone %L%
::
:: If the destination path %P% contains a repository, this scenario pulls from an implicite 
:: remote repository to the current directory.(%CD%).
::
:: 3.
::     call gitlib :gitPullOrClone %R%
::     call gitlib :gitPullOrClone %R% %L%
::
:: %R% may be a remote URL or a remote name such as registered. If not provided the 
:: default (origin) will be taken. A pull will be performed if there is a local clone. 
:: Otherwise it will create a new clone from the respective remote repository. 
:: 
:: If neither a pull nor a clone was successful on behalf of any of the above 
:: scenarios, the %ERRORLEVEL% is raised and the local disk state remains unmodified.
::
:: Examples:
::     call gitlib :gitPullOrClone 
::     call gitlib :gitPullOrClone ["https://github.com/tiefeand/remote" | "C:\Repo\remote"]
::     call gitlib :gitPullOrClone ["https://github.com/tiefeand/remote" | "C:\Repo\remote"] "C:\Repo\local"

setlocal
if "%~1" EQU "" (set "$first=") else (set $first=%1)
if "%~2" EQU "" (set "$second=") else (set $second=%2)
call gitlib :isLocalGitRepo "%~1"
if %ERRORLEVEL% EQU 0 (
    if defined $first (set $wd=-C %$first%) else (set "$wd=")
    rem :gitPullOrClone
    rem :gitPullOrClone %L%
    rem :gitPullOrClone %L% %R%
    git %$wd% pull %$second%
) else (
    call gitlib :isLocalGitRepo "%~2"
    if %ERRORLEVEL% EQU 0 (
        rem :gitPullOrClone %R%
        rem :gitPullOrClone %R% %L%
        if defined $second (set $wd=-C %$second%) else (set "$wd=")
        git %$wd% pull %$first%
    ) else (
        rem :gitPullOrClone %R% %L%
        git clone %$first% %$second%
    )
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
::     call gitlib :gitGracefulClone "https://github.com/tiefeand/remote"
::     call gitlib :gitGracefulClone "https://github.com/tiefeand/remote" "C:\Repo\destination"

setlocal
call gitlib :canReachRemoteGit "%~1"
if %ERRORLEVEL% EQU 0 (
    git clone %1 %2
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
::     call gitlib :gitGracefulPull "C:\Repo\destination"

setlocal
call gitlib :canReachRemoteGit "%~1"
call gitlib :isLocalGitRepo "%~1"
if %ERRORLEVEL% EQU 0 (
    git pull %1
)
endlocal
goto :EOF



