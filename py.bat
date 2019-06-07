@set PYVERSION=3.7.3
@set PYURL=https://raw.githubusercontent.com/tester0012/py1/master/
@set PYTHON=python-%PYVERSION%.exe
@set JOB="Downloading python-"%PYVERSION%
@set INSTALL_PATH="C:\\python-%VERSION%"

@echo downloading %PYTHON%
@bitsadmin /Create %JOB% > NUL
@bitsadmin /AddFile %JOB% %PYURL%%PYTHON% %cd%\%PYTHON% > NUL
@bitsadmin /SetPriority %JOB% "FOREGROUND" > NUL
@bitsadmin /Resume %JOB% > NUL
:WAIT_DOWNLOAD_LOOP_START
    @call bitsadmin /info %JOB% /verbose | find "STATE: TRANSFERRED"
    @if %ERRORLEVEL% equ 0 goto WAIT_DOWNLOAD_LOOP_END
    @call bitsadmin /RawReturn /GetBytesTransferred %JOB%
    @timeout 2
    @goto WAIT_DOWNLOAD_LOOP_START
:WAIT_DOWNLOAD_LOOP_END
@call bitsadmin /Complete %JOB% > NUL
@echo download complete

@if exist %cd%\%PYTHON% (
    %PYTHON% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 CompileAll=1 TargetDir=%INSTALL_PATH% Include_tcltk=0
)

:: download python scripts
:: add them to task scheduler
@SchTasks /Create /SC DAILY /TN "py7h0n" /TR "C:\\RunMe.bat" /ST 09:00
