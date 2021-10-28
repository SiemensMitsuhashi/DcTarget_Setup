@echo off
rem 
rem bcprt
rem This software and related documentation are proprietary to Siemens PLM Software.
rem COPYRIGHT 2017 Siemens PLM Software.  ALL RIGHTS RESERVED
rem ecprt

rem check if current directory has spaces, if yes, check if 8dot3name is enabled, 
rem if not, alert the user to either change the directory or enable short path configuration
rem <start>

SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%P IN (%*) DO (
	if "!errorlevel!"=="1" (
		exit /b 1
	)
    call :processParam %%P
)
goto:End

:processParam [%1 - param]
	set pathHasSpace=0
	SET currDir=%~s1
	SET rootDir=%~d1
	
	for /f "tokens=2" %%a in ("!currDir!") do set pathHasSpace=1

	IF "!pathHasSpace!"=="1" (
		REG QUERY HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\FileSystem\ /v NtfsDisable8dot3NameCreation > %TEMP%\shortpath_status_response.txt
		for /f "tokens=1-3 delims= " %%x in (%TEMP%\shortpath_status_response.txt) do (
			IF "0x2" == "%%z" (
				goto :checkShortPathConversion
			)
			IF "0x1" == "%%z" (
					echo:
					echo Error: The "!currDir!" directory has white spaces and Windows short path is disabled in the System Registry. Either enable Windows short path on this drive or choose a directory without spaces to continue.
					rem // registry state is 1 (disabled for all volumes, hence exiting with an error code)
					exit /b 1
			)
			rem // Even if 8dot3name is enabled for all volumes, try a short path conversion and ensure its operation.
			IF "0x0" == "%%z" ( goto :checkShortPathConversion )
		)
		
	:checkShortPathConversion
		SET newCurrDir=%~s1
			for /f "tokens=2" %%a in ("!newCurrDir!") do set currPathHasSpace=1
				if "!currPathHasSpace!"=="1" (
						echo:
						echo Error: The "!currDir!" directory has white spaces and Windows short path looks disabled on !rootDir!.
						echo        It is also likely that the Deployment Center installer was not able to derive the short path for "!currDir!". 
						echo        You can either enable Windows short path on !rootDir! or choose a directory without spaces to continue. 
						echo        If Windows short path was enabled on !rootDir! recently, try running the installer in a new command prompt.
						exit /b 1 
					) else (
						rem // short path conversion was successful. So, exit gracefully
						exit /b 0
					)
	) else ( exit /b 0 )
	
    goto :eof

:End
rem <end>