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

set $not_an_svn_co_path="%$unique_folder%\git co"
set $valid_svn_co_path="%$unique_folder%\svn co"
set $invalid_svn_url="https://ch1svn1/svn/NotExist" 
set $valid_accessible_svn_url="https://ch1svn1/svn/Test"
rem https://ch1svn1/svn/Testing/VAV Labor/Altium Designer

rem ping %$valid_accessible_svn_url%
ping ch1svn1

set $not_an_git_co_path="%$unique_folder%\svn co"
set $valid_git_co_path="%$unique_folder%\git co"
set $invalid_git_url="https://github.com/tiefeand/not-existing-repo.git"
set $valid_accessible_git_url="https://github.com/tiefeand/tetris.git"

rem ping %$valid_accessible_git_url%
ping www.github.com

svn co %$valid_accessible_svn_url% %$valid_svn_co_path%
git clone %$valid_accessible_git_url% %$valid_git_co_path%

echo created folder %$unique_folder%\
start %$unique_folder%\
echo Before continuing, verify that there are folders 'svnco' and 'gitco' 
echo containing checkouts in it. Then press ENTER
pause


::------------------------------------------------------------------------------
:: test
::------------------------------------------------------------------------------
echo ***************************************************************************
echo * isSvnCheckout
echo ***************************************************************************
rem Test case: path is empty thus current directory and is not a svn checkout 
call svnlib :isSvnCheckout
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path is empty thus current directory and is not a svn checkout 
call svnlib :isSvnCheckout ""
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists but is not a svn checkout 
call svnlib :isSvnCheckout %$not_an_svn_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout
call svnlib :isSvnCheckout %$valid_svn_co_path%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path does not exists
call svnlib :isSvnCheckout %$not_existing_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * retrieveSvnRemoteUrl
echo ***************************************************************************
rem Test case: path may exist but is not a svn checkout 
call svnlib :retrieveSvnRemoteUrl %$invalid_svn_url%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout 
call svnlib :retrieveSvnRemoteUrl %$valid_svn_co_path%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path may exist but is not a svn checkout 
setlocal
set $svnurl=
call svnlib :retrieveSvnRemoteUrl %$invalid_svn_url% $svnurl
echo $svnurl: expected: [empty], effective: %$svnurl%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
endlocal
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout 
setlocal
set $svnurl=
call svnlib :retrieveSvnRemoteUrl %$valid_svn_co_path% $svnurl
echo $svnurl: expected: %$valid_accessible_svn_url%, effective: %$svnurl%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
endlocal
echo.


echo ***************************************************************************
echo * svnUpdateOrCheckout
echo ***************************************************************************
rem Test case: no path provided. Therefore update the current directory
rem call svnlib :svnUpdateOrCheckout
rem echo ERRORLEVEL: expected: 1 if this is an svn repo otherwise 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path does not exist or does not contain any svn checkout
call svnlib :svnUpdateOrCheckout %$not_existing_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not a accessible svn URL 
call svnlib :svnUpdateOrCheckout %$invalid_svn_url% 
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL 
rem call svnlib :svnUpdateOrCheckout %$valid_accessible_svn_url% 
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path with repository is provided
call svnlib :svnUpdateOrCheckout %$valid_svn_co_path% 
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not a accessible svn URL and path is provided
call svnlib :svnUpdateOrCheckout %$invalid_svn_url% %$unique_folder%\test_failure_if_this_persists_svnUpdateOrCheckout
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL and path is provided
call svnlib :svnUpdateOrCheckout %$valid_accessible_svn_url% %$unique_folder%\test_svnUpdateOrCheckout
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path is provided and svn checkout exists
call svnlib :svnUpdateOrCheckout %$unique_folder%\test_svnUpdateOrCheckout
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url is empty and path is provided
call svnlib :svnUpdateOrCheckout "" %$unique_folder%\test_failure_if_this_persists_svnUpdateOrCheckout
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL and path is empty
rem call svnlib :svnUpdateOrCheckout %$valid_accessible_svn_url% ""
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * svnGracefulCheckout
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible svn URL 
call svnlib :svnGracefulCheckout %$invalid_svn_url% %$unique_folder%\test_failure_if_this_persists_svnGracefulCheckout
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL 
call svnlib :svnGracefulCheckout %$valid_accessible_svn_url% %$unique_folder%\test_svnGracefulCheckout
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * svnGracefulCleanup
echo ***************************************************************************
rem Test case: path may exist but is not a svn checkout 
call svnlib :svnGracefulCleanup %$not_an_svn_co_path% 
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout 
call svnlib :svnGracefulCleanup %$valid_svn_co_path%  
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


echo ***************************************************************************
echo * svnGracefulUpdate
echo ***************************************************************************
rem Test case: path may exist but is not a svn checkout 
call svnlib :svnGracefulUpdate %$not_an_svn_co_path% 
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout 
call svnlib :svnGracefulUpdate %$valid_svn_co_path%  
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.


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
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
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