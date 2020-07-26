@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library extends the docker utility with additional convenience functions.
:: For bare docker functionality use docker command line directly. 
:: Type 'docker --help' for more information
::------------------------------------------------------------------------------


::------------------------------------------------------------------------------
::   Function section 
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:isDockerInstalled
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:downloadDocker
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:installDocker
:: NOT IMPLEMENTED
goto :EOF


::------------------------------------------------------------------------------
:isLocalImage
:: Elevates error level if image does not exist on your device 
::
::     call dockerlib :dockerImageExist %T%  
::
:: T: image tag
::
:: Examples:
::     call dockerlib :dockerImageExist "alpine:latest"

setlocal
docker inspect --type=image "%~1"
endlocal
goto :EOF


::------------------------------------------------------------------------------
:dockerPullOrBuild
:: Pulls a remote docker image, if it already exists it is updated. If that was
:: not successful it tries to build it from local resources using the image name
:: and if given a path of a Dockerfile or per default takes the Dockerfile in the
:: current directory.
::
:: This works with either order of the inputs.
:: If all of it fails the %ERRORLEVEL% is raised.
::
::     call dockerlib :dockerPullOrBuild %N%
::     call dockerlib :dockerPullOrBuild %P%
::     call dockerlib :dockerPullOrBuild %N% %P%
::     call dockerlib :dockerPullOrBuild %P% %N%
::
:: T: a name:tag of an image
:: P: the local path or a remote url containing a dockerfile
::
:: Examples:
::     call dockerlib :dockerPullOrBuild "alpine:latest"
::     call dockerlib :dockerPullOrBuild "https://github.com/tiefeand/cmd"
::     call dockerlib :dockerPullOrBuild "alpine:latest" "https://github.com/tiefeand/cmd"
::     call dockerlib :dockerPullOrBuild "https://github.com/tiefeand/cmd" "alpine:latest"

setlocal
rem call dockerlib :dockerImageExist "%~1" 
rem if %ERRORLEVEL% EQU 0 (
rem	    docker pull "%~1"
rem )
docker pull "%~1"
if %ERRORLEVEL% NEQ 0 (
    docker build "%~1" "%~2"
)
if %ERRORLEVEL% NEQ 0 (
    docker build "%~2" "%~1"
)
endlocal
goto :EOF




