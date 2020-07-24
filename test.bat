@echo off

::------------------------------------------------------------------------------
:: A set of unit tests on the batch functions. You must execute them manually
:: and verify the correctnes by eye.
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:: setup
::------------------------------------------------------------------------------
set $unique_folder=%TEMP%\test%RANDOM%

set $not_an_svn_co_path=%$unique_folder%\gitco
set $valid_svn_co_path=%$unique_folder%\svnco
set $invalid_svn_url="https://ch1svn1/svn/NotExist" 
set $valid_accessible_svn_url="https://ch1svn1/svn/Test"

ping $valid_accessible_svn_url


set $not_an_git_co_path=%$unique_folder%\svnco
set $valid_git_co_path=%$unique_folder%\gitco
set $invalid_git_url="https://github.com/tiefeand/notExist" 
set $valid_accessible_git_url="https://github.com/tiefeand/cmd"

ping %$valid_accessible_git_url%

svn co %$valid_accessible_svn_url% %$valid_svn_co_path%
git clone %$valid_accessible_git_url% %$valid_git_co_path%

start %$unique_folder%\
echo Before continuing, verify that there are folders 'svnco' and 'gitco' with checkouts in it. Then press ENTER
pause

::------------------------------------------------------------------------------
:: test
::------------------------------------------------------------------------------
echo ***************************************************************************
echo * isSvnCheckout
echo ***************************************************************************
rem Test case: path may exist but is not a svn checkout 
call svnlib :isSvnCheckout %$not_an_svn_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an svn checkout
call svnlib :isSvnCheckout %$valid_svn_co_path%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
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
rem Test case: url does not exists or is not a accessible svn URL 
call svnlib :svnUpdateOrCheckout %$invalid_svn_url% 
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL 
rem call svnlib :svnUpdateOrCheckout %$valid_accessible_svn_url% 
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not a accessible svn URL 
setlocal
set $svnurl=
call svnlib :svnUpdateOrCheckout %$invalid_svn_url% %$unique_folder%\should_not_persist10
echo $svnurl: expected: [empty], effective: %$svnurl%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
endlocal
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL 
setlocal
set $svnurl=
call svnlib :svnUpdateOrCheckout %$valid_accessible_svn_url% %$unique_folder%\test11
echo $svnurl: expected: %$valid_accessible_svn_url%, effective: %$svnurl%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
endlocal
echo.

echo ***************************************************************************
echo * svnGracefulCheckout
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible svn URL 
call svnlib :svnGracefulCheckout %$invalid_svn_url% %$unique_folder%\should_not_persist12
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible svn URL 
call svnlib :svnGracefulCheckout %$valid_accessible_svn_url% %$unique_folder%\test13
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
rem Test case: path may exist but is not a git checkout 
call gitlib :isLocalGitRepo %$not_an_git_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an git checkout 
call gitlib :isLocalGitRepo %$valid_git_co_path%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * gitPullOrClone
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible git URL 
call gitlib :gitPullOrClone %$invalid_git_url% 
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
rem call gitlib :gitPullOrClone %$valid_accessible_git_url% 
rem echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url does not exists or is not a accessible git URL 
setlocal
set $giturl=
call gitlib :gitPullOrClone %$invalid_git_url% %$unique_folder%\should_not_persist20
echo $giturl: expected: [empty], effective: %$giturl%
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
endlocal
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
setlocal
set $giturl=
call gitlib :gitPullOrClone %$valid_accessible_git_url% %$unique_folder%\test21
echo $giturl: expected: %$valid_accessible_git_url%, effective: %$giturl%
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
endlocal
echo.

echo ***************************************************************************
echo * gitGracefulClone
echo ***************************************************************************
rem Test case: url does not exists or is not a accessible git URL 
call gitlib :gitGracefulClone %$invalid_git_url% %$unique_folder%\should_not_persist22
echo ERRORLEVEL: expected: 128, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: url exists and is a valid accessible git URL 
call gitlib :gitGracefulClone %$valid_accessible_git_url% %$unique_folder%\test23
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * gitGracefulPull
echo ***************************************************************************
rem Test case: path may exist but is not a git checkout 
call gitlib :gitGracefulPull %$not_an_git_co_path%
echo ERRORLEVEL: expected: 1, effective: %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem Test case: path exists and is an git checkout 
call gitlib :gitGracefulPull %$valid_git_co_path% 
echo ERRORLEVEL: expected: 0, effective: %ERRORLEVEL%
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