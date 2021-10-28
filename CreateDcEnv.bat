@echo off

SET DC_HOSTNAME=172.16.1.29
SET SYS_USER=%USERNAME%
SET SYS_PASS=UGSplm99
SET STD_PASS=infodba
SET TARGET_MACHINE=%COMPUTERNAME%
SET ENV_NAME=%TARGET_MACHINE%_Env

dir C:\Apps\Setup\quick_deploy_build\template

SET INPUT_FILE=
set /P INPUT_FILE="Teamcenter Config File?: "


net use z: \\%DC_HOSTNAME%\repository

call ant -f quick_deploy_build\build.xml -Dtarget.environment=%ENV_NAME% -Djdk.home=%JAVA_HOME% -Dtarget.machine=%TARGET_MACHINE% -Dsystem.name=%SYS_USER% -Dsystem.passwd=%SYS_PASS% -Dtarget.passwd=%STD_PASS% -Dtemplate.file=%INPUT_FILE%

dc_quick_deploy\dc_quick_deploy.bat -dcusername=dcadmin -dcpassword=dcadmin -dcurl=http://%DC_HOSTNAME%:8080/deploymentcenter -environment=%ENV_NAME% -inputFile=quick_deploy_build\created\%ENV_NAME%.xml

