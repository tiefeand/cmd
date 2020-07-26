@echo off

::------------------------------------------------------------------------------
:: A set of unit tests on the batch functions. You must execute them manually
:: and verify the correctnes by eye.
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:: setup
::------------------------------------------------------------------------------
set $unique_folder=%TEMP%\test%RANDOM%

set $not_existing_path="A:\does\not\exist"

set $not_an_git_co_path="%$unique_folder%\not a git path"
set $valid_git_co_path="%$unique_folder%\git co"
set $invalid_git_url="https://github.com/tiefeand/not-existing-repo.git"
set $valid_accessible_git_url="https://github.com/tiefeand/tetris.git"

rem ping %$valid_accessible_git_url%
ping www.github.com

mkdir -p %$not_an_git_co_path%
git clone %$valid_accessible_git_url% %$valid_git_co_path%

echo created folder %$unique_folder%\
start %$unique_folder%\
echo Before continuing, verify that there are folders 'svn co' and 'git co' 
echo containing checkouts in it. Then press ENTER
pause


::------------------------------------------------------------------------------
:: test
::------------------------------------------------------------------------------

echo ***************************************************************************
echo * canReachRemoteGit
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible git URL 
call gitlib :canReachRemoteGit %$invalid_git_url%
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
call gitlib :canReachRemoteGit %$valid_accessible_git_url%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * isLocalGitRepo
echo ***************************************************************************
rem Test case: path is empty thus current directory and is a git repo
call gitlib :isLocalGitRepo
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path is empty thus current directory and is a git repo
call gitlib :isLocalGitRepo ""
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path may exist but is not a git checkout 
call gitlib :isLocalGitRepo %$not_an_git_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an git checkout 
call gitlib :isLocalGitRepo %$valid_git_co_path%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path does not exists
call gitlib :isLocalGitRepo %$not_existing_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * gitPullOrClone
echo ***************************************************************************
rem Test case: no path provided. Therefore pull the current directory
rem call gitlib :gitPullOrClone 
rem echo ERRORLEVEL: expected: 0 if this is a git repo otherwise 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not an accessible git URL 
call gitlib :gitPullOrClone %$invalid_git_url% 
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
rem call gitlib :gitPullOrClone %$valid_accessible_git_url% 
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path with repository is provided
call gitlib :gitPullOrClone %$valid_git_co_path% 
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not a accessible git URL and path is provided
call gitlib :gitPullOrClone %$invalid_git_url% %$unique_folder%\test_failure_if_this_persists_gitPullOrClone
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL and path is provided
call gitlib :gitPullOrClone %$valid_accessible_git_url% %$unique_folder%\test_gitPullOrClone
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url is empty and path is provided
call gitlib :gitPullOrClone "" %$unique_folder%\test_failure_if_this_persists_gitPullOrClone
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL and path is empty
rem call gitlib :gitPullOrClone %$valid_accessible_git_url% ""
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * gitGracefulClone
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible git URL 
call gitlib :gitGracefulClone %$invalid_git_url% %$unique_folder%\test_failure_if_this_persists_gitGracefulClone
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
call gitlib :gitGracefulClone %$valid_accessible_git_url% %$unique_folder%\test_gitGracefulClone
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * gitGracefulPull
echo ***************************************************************************
rem Test case: path may exist but is not a git checkout 
call gitlib :gitGracefulPull %$not_an_git_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo.


::------------------------------------------------------------------------------
:: teardown
::------------------------------------------------------------------------------
start %$unique_folder%\
echo Verify the check outs in the folder %$unique_folder%\. 
echo When pressing enter they will be removed again
pause
rm -rf %$unique_folder%\
exit 