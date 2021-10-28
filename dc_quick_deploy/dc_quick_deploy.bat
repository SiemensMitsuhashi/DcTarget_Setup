@echo off
rem 
rem bcprt
rem This software and related documentation are proprietary to Siemens PLM Software.
rem COPYRIGHT 2019 Siemens PLM Software.  ALL RIGHTS RESERVED
rem ecprt
SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%F IN ("%~dp0") DO SET KIT_DIR=%%~sF


IF DEFINED "%JAVA_HOME%" (
	set JAVA_HOME=%JAVA_HOME:"=%
)

set KIT_DIR=%KIT_DIR:"=%

rem call the windows_shortpath_checker bat file and check if 8dot3name is enabled.
call "%KIT_DIR%\windows_shortpath_checker.bat" "%KIT_DIR%" "%JAVA_HOME%"

if "!errorlevel!"=="1" ( 
	exit /b 1
)

IF "%JAVA_HOME%"=="" (
echo The environment variable 'JAVA_HOME' is NOT defined. Java Runtime Environment is required to execute this utility. Install Java and set 'JAVA_HOME' environment variable to that location.  
exit /b 1
)

set JAVA_COMMAND=%JAVA_HOME%\bin\java.exe

if not exist "%JAVA_COMMAND%" (
echo Unable to locate Java at "%JAVA_COMMAND%". Java Runtime Environment is required to execute this utility. Install Java and set 'JAVA_HOME' environment variable to that location. 
exit /b 1
)

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set currentDateTime=%%j
set currentDateTime=%currentDateTime:~0,4%-%currentDateTime:~4,2%-%currentDateTime:~6,2%_%currentDateTime:~8,2%_%currentDateTime:~10,2%_%currentDateTime:~12,6%

"%JAVA_COMMAND%" -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.log.org.apache.http=ERROR -Dlog4j.configurationFile=%KIT_DIR%jar/log4j2_quick_deploy.xml -DUTILITY_DIR=%KIT_DIR% -DLOGTIME=%currentDateTime% -cp "%KIT_DIR%;%KIT_DIR%jar\*" -Xmx512M com.siemens.deploymentcenter.quickdeploy.cli.DcQuickDeploy %*

