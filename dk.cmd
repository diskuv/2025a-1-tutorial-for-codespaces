@ECHO OFF
REM ##########################################################################
REM # File: dkcoder\dk.cmd                                                   #
REM #                                                                        #
REM # Copyright 2023 Diskuv, Inc.                                            #
REM #                                                                        #
REM # Licensed under the Open Software License version 3.0                   #
REM # (the "License"); you may not use this file except in compliance        #
REM # with the License. You may obtain a copy of the License at              #
REM #                                                                        #
REM #     https://opensource.org/license/osl-3-0-php/                        #
REM #                                                                        #
REM ##########################################################################

REM Recommendation: Place this file in source control.

REM The canonical way to run this script is: ./dk
REM That works in Powershell on Windows, and in Unix. Copy-and-paste works!
REM
REM Purpose: Install DkCoder if not present. Then invoke DkCoder.

SETLOCAL ENABLEDELAYEDEXPANSION

REM Coding guidelines
REM 1. Microsoft way of getting around PowerShell permissions:
REM    https://github.com/microsoft/vcpkg/blob/71422c627264daedcbcd46f01f1ed0dcd8460f1b/bootstrap-vcpkg.bat
REM 2. Hygiene: Capitalize keywords, variables, commands, operators and options
REM 3. Detect errors with `%ERRORLEVEL% EQU` (etc). https://ss64.com/nt/errorlevel.html
REM 3. In nested blocks like `IF EXIST xxx ( ... )` use delayed !ERRORLEVEL!. https://stackoverflow.com/a/4368104/21513816
REM 4. Use functions ("subroutines"):
REM    https://learn.openwaterfoundation.org/owf-learn-windows-shell/best-practices/best-practices/#use-functions-to-create-reusable-blocks-of-code
REM 5. Use XCOPY for copying files since it has sane exit codes for scripting (unlike COPY).
REM    Create an intermediate subdirectory if needed since XCOPY only copies directories well.

REM Invoke-WebRequest guidelines
REM 1. Use $ProgressPreference = 'SilentlyContinue' always. Terrible slowdown w/o it.
REM    https://stackoverflow.com/questions/28682642

SET _DK_PROJ_DIR=%~dp0
SET DKCODER_PWD=%CD%

REM Update within dksdk-coder:
REM   f_dk() { jq -r 'def ck(p): .files[] | select(.path == p).checksum.sha256; { majminpat_ver:.listing_unencrypted.version, ck_windows_x86_64:(ck("dist/dk-windows_x86_64.exe") // ""), ck_windows_x86:(ck("dist/dk-windows_x86.exe") // ""), fn:input_filename } | "REM "+.fn+"\n"+"SET DK_VER="+.majminpat_ver+"\n"+"SET DK_CKSUM_WINDOWS_X86="+.ck_windows_x86+"\n"+"SET DK_CKSUM_WINDOWS_X86_64="+.ck_windows_x86_64 ' $1 }
REM   eval $(awk '$2=="f_dk()" {$1=""; print}' dk-new.cmd | tr -d '\r') # avoids typing the line above
REM   f_dk packaging/specs/2.3.202505280211.json
REM
REM   Empty value if the architecture is not supported.
REM
REM packaging/specs/2.3.202505280211.json
SET DK_VER=2.3.202505280211
SET DK_CKSUM_WINDOWS_X86=
SET DK_CKSUM_WINDOWS_X86_64=db6484a9a456cb9dfc2172bfcff3414ea92a2732d0e24e9ee013bd9962818651

REM --------- Quiet and Away Detection ---------
REM Enabled? If suffix of the first argument is "Quiet" or "Away"
REM Example: DkRun_Project.RunQuiet
REM Example: DkRun_Project.RunAway

SET DK_ARG1=%1
SET DK_QUIET=0
SET DK_AWAY=0
IF "%DK_ARG1:~-5%" == "Quiet" SET DK_QUIET=1
IF "%DK_ARG1:~-4%" == "Away" SET DK_AWAY=1
SET DK_ARG1=

REM --------- Data Home ---------

IF "%DKCODER_DATA_HOME%" == "" (
    SET DK_DATA_HOME=%LOCALAPPDATA%\Programs\DkCoder
) ELSE (
    SET DK_DATA_HOME=%DKCODER_DATA_HOME%
)

REM -------------- dk executable --------------

REM Download dk.exe
REM     Use subdir of %TEMP% since XCOPY does not work changing basenames during copy.
IF "%PROGRAMFILES(x86)%" == "" (
    REM 32-bit Windows
    IF "%DK_CKSUM_WINDOWS_X86%" == "" (
        ECHO.Windows 32-bit PCs are not supported as host machines.
        ECHO.Instead develop on a 64-bit PC and cross-compile with StdStd_Std.Exe to 32-bit Windows target PCs.
        EXIT /B 1
    )
    SET "DK_EXEDIR=%DK_DATA_HOME%\dkexe-%DK_VER%-windows_x86"
    IF NOT EXIST "!DK_EXEDIR!" MKDIR "!DK_EXEDIR!"
    SET "DK_EXE=!DK_EXEDIR!\dk.exe"
    IF NOT EXIST "!DK_EXE!" (
        IF %DK_QUIET% EQU 0 ECHO.dk executable:
        IF NOT EXIST "%TEMP%\%DK_CKSUM_WINDOWS_X86%" MKDIR "%TEMP%\%DK_CKSUM_WINDOWS_X86%"
        CALL :downloadFile ^
            dk ^
            "dk %DK_VER% 32-bit" ^
            "https://diskuv.com/a/dk-distribution/%DK_VER%/dist/dk-windows_x86.exe" ^
            %DK_CKSUM_WINDOWS_X86%\dk.exe ^
            %DK_CKSUM_WINDOWS_X86%
        REM On error the error message was already displayed.
        IF !ERRORLEVEL! NEQ 0 EXIT /B !ERRORLEVEL!
        XCOPY /v /g /i /r /n /y /j "%TEMP%\%DK_CKSUM_WINDOWS_X86%\dk.exe" "!DK_EXEDIR!"
        IF !ERRORLEVEL! NEQ 0 EXIT /B !ERRORLEVEL!
        REM It is okay if the temp dir is not cleaned up. No error checking.
        IF NOT "%DK_CKSUM_WINDOWS_X86%" == "" RD "%TEMP%\%DK_CKSUM_WINDOWS_X86%" /s /q
    )
) ELSE (
    SET "DK_EXEDIR=%DK_DATA_HOME%\dkexe-%DK_VER%-windows_x86"
    IF NOT EXIST "!DK_EXEDIR!" MKDIR "!DK_EXEDIR!"
    SET "DK_EXE=!DK_EXEDIR!\dk.exe"
    IF NOT EXIST "!DK_EXE!" (
        IF %DK_QUIET% EQU 0 ECHO.dk executable:
        IF NOT EXIST "%TEMP%\%DK_CKSUM_WINDOWS_X86_64%" MKDIR "%TEMP%\%DK_CKSUM_WINDOWS_X86_64%"
        CALL :downloadFile ^
            dk ^
            "dk %DK_VER% 64-bit" ^
            "https://diskuv.com/a/dk-distribution/%DK_VER%/dist/dk-windows_x86_64.exe" ^
            %DK_CKSUM_WINDOWS_X86_64%\dk.exe ^
            %DK_CKSUM_WINDOWS_X86_64%
        REM On error the error message was already displayed.
        IF !ERRORLEVEL! NEQ 0 EXIT /B !ERRORLEVEL!
        XCOPY /v /g /i /r /n /y /j "%TEMP%\%DK_CKSUM_WINDOWS_X86_64%\dk.exe" "!DK_EXEDIR!"
        IF !ERRORLEVEL! NEQ 0 EXIT /B !ERRORLEVEL!
        REM It is okay if the temp dir is not cleaned up. No error checking.
        IF NOT "%DK_CKSUM_WINDOWS_X86_64%" == "" RD "%TEMP%\%DK_CKSUM_WINDOWS_X86_64%" /s /q
    )
)
SET DK_EXEDIR=

REM -------------- DkML PATH ---------
REM We get "git-sh-setup: file not found" in Git for Windows because
REM Command Prompt has the "Path" environment variable, while PowerShell
REM and `with-dkml` use the PATH environment variable. Sadly both
REM can be present in Command Prompt at the same time. Git for Windows
REM (called by FetchContent in CMake) does not comport with what Command
REM Prompt is using. So we let Command Prompt be the source of truth by
REM removing any duplicated PATH twice and resetting to what Command Prompt
REM thinks the PATH is.

SET _DK_PATH=%PATH%
SET PATH=
SET PATH=
SET PATH=%_DK_PATH%
SET "_DK_PATH="

REM -------------- Clear environment -------

SET "DK_QUIET="

REM --------------- Console ----------------
REM Until https://github.com/ocaml/ocaml/pull/1408 fixed
REM Confer: https://stackoverflow.com/a/52139735
2>NUL >NUL TIMEOUT /T 0 && (
  REM stdin not redirected or piped
  CHCP 65001 >NUL
  SET DKCODER_TTY=1
) || (
  REM stdin has been redirected or is receiving piped input
  SET DKCODER_TTY=0
)

REM -------------- Run dk executable --------------

SET DKCODER_ARG0=%0

IF %DK_AWAY% EQU 0 CD /D "%_DK_PROJ_DIR%"
REM     Unset local variables
SET "DK_DATA_HOME="
SET "DK_AWAY="
SET "DK_QUIET="
SET "_DK_PATH="
REM     Then run dk.exe. TODO: Use environment variable not --project-dir so quotes aren't needed
"%DK_EXE%" --project-dir %_DK_PROJ_DIR% %*
EXIT /B %ERRORLEVEL%

REM ------ SUBROUTINE [downloadFile]
REM Usage: downloadFile ID "FILE DESCRIPTION" "URL" FILENAME SHA256
REM
REM Procedure:
REM   1. Download from <quoted> URL ARG3 (example: "https://github.com/ninja-build/ninja/releases/download/v%DK_VER%/dk.exe")
REM      to the temp directory with filename ARG4 (example: something-x64.zip)
REM   2. SHA-256 integrity check from ARG5 (example: 524b344a1a9a55005eaf868d991e090ab8ce07fa109f1820d40e74642e289abc)
REM
REM Error codes:
REM   1 - Can't download from the URL.
REM   2 - SHA-256 verification failed.

:downloadFile

REM Replace "DESTINATION" double quotes with single quotes
SET DK_DOWNLOAD_URL=%3
SET DK_DOWNLOAD_URL=%DK_DOWNLOAD_URL:"='%

REM 1. Download from <quoted> URL ARG3 (example: "https://github.com/ninja-build/ninja/releases/download/v%DK_VER%/dk.exe")
REM    to the temp directory with filename ARG4 (example: something-x64.zip)
IF %DK_QUIET% EQU 0 ECHO.  Downloading %3
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest %DK_DOWNLOAD_URL% -OutFile '%TEMP%\%4'" >NUL
IF %ERRORLEVEL% NEQ 0 (
    REM Fallback to BITSADMIN because sometimes corporate policy does not allow executing PowerShell.
    REM BITSADMIN overwhelms the console so user-friendly to do PowerShell then BITSADMIN.
    IF %DK_QUIET% EQU 0 (
        BITSADMIN /TRANSFER dkcoder-%1 /DOWNLOAD /PRIORITY FOREGROUND ^
            %3 "%TEMP%\%4"
    ) ELSE (
        BITSADMIN /TRANSFER dkcoder-%1 /DOWNLOAD /PRIORITY FOREGROUND ^
            %3 "%TEMP%\%4" >NUL
    )
    REM Short-circuit return with error code from function if can't download.
    IF !ERRORLEVEL! NEQ 0 (
        ECHO.
        ECHO.Could not download %2.
        ECHO.
        EXIT /B 1
    )
)

REM 2. SHA-256 integrity check from ARG5 (example: 524b344a1a9a55005eaf868d991e090ab8ce07fa109f1820d40e74642e289abc)
IF %DK_QUIET% EQU 0 ECHO.  Performing SHA-256 validation of %4
FOR /F "tokens=* usebackq" %%F IN (`certutil -hashfile "%TEMP%\%4" sha256 ^| findstr /v hash`) DO (
    SET "DK_CKSUM_WINDOWS_X86_64_ACTUAL=%%F"
)
IF /I NOT "%DK_CKSUM_WINDOWS_X86_64_ACTUAL%" == "%5" (
    ECHO.
    ECHO.Could not verify the integrity of %2.
    ECHO.Expected SHA-256 %5
    ECHO.but received %DK_CKSUM_WINDOWS_X86_64_ACTUAL%.
    ECHO.Make sure that you can access the Internet, and there is nothing
    ECHO.intercepting network traffic.
    ECHO.
    EXIT /B 2
)

REM Return from [downloadFile]
EXIT /B 0
