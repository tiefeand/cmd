# Guidance for scripting windows batch files

## See also:
- [https://ss64.com/nt/](https://ss64.com/nt/)
- [https://www.dostips.com/](https://www.dostips.com/)

---

## Basic language paradigms

### set

#### List existing variables
- To reveal all currently set environmnet variables, simply type:
``` cmd
    SET
```
- To reveal a subset such as all variables starting with P use
``` cmd
    SET P
```

#### Definition
It is good practice to add a dollar sign `$` to distinguish variables from keywords and standard build in environment variables. There are various ways how environment varibles can be set. Use the appropriate form:

- In case you use a variable name with special characters (not recommended) such as 
delimiters put the entire expression in quotation marks
``` cmd
    "SET $var,1=" : 
```
- The set command is not forgiving with spaces as they become part of the content.
To avoid issues do not use spaces around the assingment. Thus don't do 
``` cmd
    SET $alpha = $beta
```
but do 
``` cmd
    SET $alpha=$beta
```
- If you have strings with spaces you do not need quotation marks. You can use:
``` cmd
    SET $var=one two three
```
- However when you have special characters use quotation marks

- Put them around the entire expression in order to not include them in the actual content
``` cmd
    SET "$var=one & two"
```
- Put them around the value in order to include them in the actual content
``` cmd
    SET $var="one & two"
```
- Use quotes whenever specifing a non-defined variable in order to avoid the bug of assinging it to a whitespace:
``` cmd
    SET "$var="
```
- Use the following form to do basic integer arithmetic
``` cmd
    SET /a $x=20
    SET /a $x=3*$x
```
- Use the following in order to set a variable equal to a user input. Then text 
written will be shown as prompt string before user input
``` cmd
    SET /p $var=Please enter some text
```
Example:
``` cmd
    SET /P $dept=Please enter Department || SET $dept=NothingChosen
    If "%$dept%"=="NothingChosen" GOTO sub_error
    If /i "%$dept%"=="finance" GOTO sub_finance
    If /i "%$dept%"=="hr" GOTO sub_hr
    GOTO :EOF
```
- If a variable is set to nothing in which case it will be considered as not defined
``` cmd
    SET "$var="
    IF NOT DEFINED $var (ECHO "not defined")
```

#### expand and use variable content
- To expand variable into literals use the `%` around the corresponding variable
``` cmd
    %var%
```
- Reveal the content of a variable like this
``` cmd
    ECHO %$var%
```
- Parameters that were passed to a batch script or a goto section can be revealed like this:
``` cmd
    %1
    %2
```
Note: 
- There is only one `%` in front of the number and none at the end of it. 
- The number is the position behind the called item at which they are passed
- The file location `%0` is the location of the current batch script being called


#### manipulate the expansion
- To remove the quotation marks of a variables content after expansion use the `~`
``` cmd
    SET "$var=Some string with quotation markes"
    echo %~$var%
```
- Similar you can do with arguments that were passed
``` cmd
    %~0
    %~1
    %~2
```
- To make sure a string has quotation marks but not doublicating them either do
``` cmd
    "%~$var%"
```
or 
``` cmd
    "%~1"
```

#### manipulate the expansion of file paths
Special (magic) expansions for file like variables (only when using batch files)

    %0 : full path including the filename
    %~f0 : full path of the running batch file ('this file')
    %~d0 : drive of the running batch file
    %~p0 : path of the running batch file (without drive)
    %~n0 : name of the running batch file
    %~x0 : extension of the running batch file
    %~dp0 : folder (drive and path) in which the current batch file resides
    %~nx0 : file name and extension of the running batch file
    %~fs0 : full path name with short names only of the running batch file
    %~t0 : time stamp of of the running batch file
    %~z0 : size of of the running batch file
    %~a0 : attributes of the running batch file

Instead of 0 it could be any variable holding a path as long as using it within a 
for loop:

    FOR /f %%i IN ("%0") DO SET $current_path=%%~dpi 
    FOR %%* IN (.) DO SET $current_path=%%~nx*
    FOR %%i in (%CD%\.git) DO IF EXIST %%~si\NUL SET $is_repo="y"
---

### `For`-loops 

#### The classic way
``` cmd
    FOR %variable IN (SET) DO command [command-parameters]
```

whereas:
* `%variable` : Specifies a single letter replaceable parameter.
* `set` : A set of one or more files (file1,file2)
* `command` : command to carry out
* `command-parameter`: 

To use the FOR command in a batch program, specify `%%i` instead
of `%i`.  Variable names are case sensitive.

Example: Copy a single file
``` cmd
    FOR %%g IN (MyFile.txt) DO COPY %%g d:\backups\
```

#### The extended way
Consider using other forms of for loops:

    FOR - Loop commands.
    FOR /R - Loop through files (recurse subfolders).
    FOR /D - Loop through several folders.
    FOR /L - Loop through a range of numbers.
    FOR /F - Loop through items in a text file.
    FOR /F - Loop through the output of a command.

See also:
[https://ss64.com/nt/for.html](https://ss64.com/nt/for.html)
[https://ss64.com/nt/for_f.html](https://ss64.com/nt/for_f.html)
[https://ss64.com/nt/for_cmd.html](https://ss64.com/nt/for_cmd.html)

---

### Use For-loops to forward content of the stdin/stdout to another command
You may use for loops to forward pass `stdout` to the input of another command

Example: forward a string to echo
``` cmd
    FOR %%g IN ("Hello World") DO ECHO %%g
```

Example: forward stdout of a command to a write to a variable
``` cmd
    FOR /f "tokens=*" %%a in (svn info "%~1") DO SET "URL=%%~fa"
```

Example: list the contents of `c:\demo` with the full path of each file
``` cmd
    FOR %%A IN ("c:\demo\*") DO ECHO %%~fA
```

---

## Use execution sections like functions

### Define a "function"
``` cmd
    :someFunction
    <some function body>
    GOTO :EOF
```

---

### Call a function
``` cmd
    CALL :someFunction 100,200
    CALL :someFunction 100 200
    CALL :someFunction 100 "a string with spaces"
```

---

### Local namespaces for variables in code sections
Create local namespaces for functions do not operate in a global name space. 
Use `SETLOCAL` and `ENDLOCAL`
``` cmd
    :someFunction
    SETLOCAL
    <some function body>
    ENDLOCAL
    GOTO :EOF
```

---

### Pass variable by reference
To pass a variable by reference pass the variable name wihout expanding it. Thus
Use `$var` not `%$var%`
``` cmd
    "SET $var="
    CALL :someFunction var
```
To retrive and write into passed-by-reference-variables use the parameter referencing mechanism `%~1`, `%~2`, ...
To write into `%~1` as long as a variable was passed by the caller:

#### If you like updating a variable `%~1` no matter whether it previously was full or empty:

##### function definition
``` cmd
    :someFunction
    SETLOCAL
    "SET $some_result="
    <some function body>
    (ENDLOCAL & REM return values
        IF "%~1" NEQ "" SET %~1=%$some_result%
    )
    GOTO :EOF
```

##### function call
``` cmd
    SET $result=
    ::write to $result
    CALL :someFunction $result  

    ::do not write to $result
    CALL :someFunction
```

#### To write into variable `%~1` only if as long as a variable was passed by the caller and it was not empty:

##### function definition
``` cmd
    :someFunction
    SETLOCAL
    "SET $some_result="
    <some function body>
    (ENDLOCAL & REM return values
        IF DEFINED "%~1" SET %~1=%$some_result%
    )
    GOTO :EOF
```

#### To pass it on to the `stdout` in the alternative case when there is no variable defined to write in

##### function definition
``` cmd
    :someFunction
    SETLOCAL
    "SET $some_result="
    <some function body>
    (ENDLOCAL & REM return values
        IF DEFINED "%~1" (SET %~1=%$some_result%) ELSE (echo.%$some_result%)
    )
    GOTO :EOF
```

---

### Use the `ERRORLEVEL` to pass failures to the calling function
Do not create additional variable just to steer the control flow in case the failure case. This unnecessarily bloats the script with overhead that is difficult to read and interpret

##### Don't
``` cmd
    :someFunction
    SETLOCAL
    SET $register_error=false
    <some function body>
    IF %ERRORLEVEL% NEQ 0 SET $register_error=true
    (ENDLOCAL & REM return values
        IF "%~1" NEQ "" SET %~1=%$register_error%
    )
    GOTO :EOF

    set $var=
    CALL :someFunction $var
    IF "%$var%" EQU "true" 
    ...
```

##### Do
Use the `ERRORLEVEL` instead directly
``` cmd
    :someFunction
    SETLOCAL
    <some function body>
    IF %ERRORLEVEL% EQU 0 (
        <do something>
    )
    ENDLOCAL
    GOTO :EOF

    SET $var=
    CALL :someFunction $var
    IF %ERRORLEVEL EQU 0 
    ...
```

#### In order to provoke `ERRORLEVEL` to raise 1
``` cmd
    SET=2>NUL
```

#### In order to provoke `ERRORLEVEL` to raise 0
``` cmd
    EXIT /b 0
```
Thus use exit to leave a subroutine explicitely and at the same time set the `ERRORLEVEL`
``` cmd
    EXIT /B [exit code number]
```
Example:
``` cmd
    EXIT /b 0 (no error)
    EXIT /b 1 (error)
    EXIT /B 2 (some other error)
```

---

## Library files
Use batch scripts like libraries by formatting it in the following form:
As a header before a set of functions being used like a library use:
``` cmd
    @echo off

    CALL:%*
    GOTO:EOF
```
`%*` refers to all passed arguments. `%1`, `%2`, ...



