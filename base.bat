@echo off

call:%*
goto:EOF

::------------------------------------------------------------------------------
:: This library provides low level functionality
::------------------------------------------------------------------------------


::------------------------------------------------------------------------------
::   Function section 
::------------------------------------------------------------------------------

::------------------------------------------------------------------------------
:true -- returns success
:: resets the error level of the caller to 0
exit /b 0
goto :EOF


::------------------------------------------------------------------------------
:false -- returns failure
:: sets the error level for the caller to 1
set=2>NUL
goto :EOF

