@echo off


echo ***************************************************************************
echo * isSvnCheckout
echo ***************************************************************************
call svnlib :isSvnCheckout "C:\Users\tiefenan\Repositories\cmd\"
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call svnlib :isSvnCheckout "C:\Users\tiefenan\Repositories\Dokumente\"
echo %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * retrieveSvnRemoteUrl
echo ***************************************************************************
call svnlib :retrieveSvnRemoteUrl "C:\Users\tiefenan\Repositories\cmd\" 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call svnlib :retrieveSvnRemoteUrl "C:\Users\tiefenan\Repositories\Dokumente\"  
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
set svnurl=
call svnlib :retrieveSvnRemoteUrl "C:\Users\tiefenan\Repositories\cmd\" svnurl
echo %svnurl%
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
set svnurl=
call svnlib :retrieveSvnRemoteUrl "C:\Users\tiefenan\Repositories\Dokumente\" svnurl
echo %svnurl%
echo %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * svnGracefulCheckout
echo ***************************************************************************
rem call svnlib :svnGracefulCheckout "https://ch1svn1/svn/NotExist" co1
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
rem call svnlib :svnGracefulCheckout "https://ch1svn1/svn/Dokumente" co2 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
echo.

echo ***************************************************************************
echo * svnGracefulCleanup
echo ***************************************************************************
call svnlib :svnGracefulCleanup "C:\Users\tiefenan\Repositories\cmd\" 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call svnlib :svnGracefulCleanup "C:\Users\tiefenan\Repositories\Dokumente\"  
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
echo.

echo ***************************************************************************
echo * svnGracefulUpdate
echo ***************************************************************************
call svnlib :svnGracefulUpdate "C:\Users\tiefenan\Repositories\cmd\" 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call svnlib :svnGracefulUpdate "C:\Users\tiefenan\Repositories\Dokumente\"  
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
echo.



echo ***************************************************************************
echo * canReachRemoteGit
echo ***************************************************************************
call gitlib :canReachRemoteGit "https://github.com/tiefeand/cmd"
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call gitlib :canReachRemoteGit "https://github.com/tiefeand/Dokumente"
echo %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * isLocalGitRepo
echo ***************************************************************************
call gitlib :isLocalGitRepo "C:\Users\tiefenan\Repositories\cmd\"
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call gitlib :isLocalGitRepo "C:\Users\tiefenan\Repositories\Dokumente\"
echo %ERRORLEVEL%
echo.

echo ***************************************************************************
echo * gitGracefulClone
echo ***************************************************************************
call gitlib :gitGracefulClone "https://github.com/tiefeand/cmd" co3
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call gitlib :gitGracefulClone "https://github.com/tiefeand/Dokumente" co4 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
echo.

echo ***************************************************************************
echo * gitGracefulPull
echo ***************************************************************************
call gitlib :gitGracefulPull "C:\Users\tiefenan\Repositories\cmd\" 
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
call gitlib :gitGracefulPull "C:\Users\tiefenan\Repositories\Dokumente\"  
echo %ERRORLEVEL%
echo ---------------------------------------------------------------------------
echo.
pause