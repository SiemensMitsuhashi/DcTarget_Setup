#!/bin/sh
#
# This software and related documentation are proprietary to Siemens PLM Software.
# COPYRIGHT 2019 Siemens PLM Software.  ALL RIGHTS RESERVED

#below changes allows send_configuration_todc to be executed from anywhere
SCRIPT_LOCATION="`which $0`";
KIT_DIR="`dirname $SCRIPT_LOCATION`";

if [ -z "$JAVA_HOME" ]
then
	echo "The environment variable 'JAVA_HOME' is NOT defined. Java Runtime Environment is required to execute this utility. Install Java and set 'JAVA_HOME' environment variable to that location.";
	exit 1;
fi

JAVA_EXE=$JAVA_HOME/bin/java

if [ ! -r "$JAVA_EXE" ]
         then
                echo "Unable to locate Java at "$JAVA_EXE". Java Runtime Environment is required to execute this utility. Install Java and set 'JAVA_HOME' environment variable to that location.";
                exit 1;
fi


CLASS_PATH=$KIT_DIR:$KIT_DIR/jar/*:"$CLASS_PATH"; export CLASS_PATH
currentDateTime=`date +"%F_%H_%M_%S.%3N"`; export currentDateTime

$JAVA_EXE -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.SimpleLog -Dorg.apache.commons.logging.simplelog.log.org.apache.http=ERROR -Dlog4j.configurationFile=$KIT_DIR/jar/log4j2_quick_deploy.xml -DUTILITY_DIR=$KIT_DIR -DLOGTIME=$currentDateTime  -cp $CLASS_PATH -Xmx512M com.siemens.deploymentcenter.quickdeploy.cli.DcQuickDeploy "$@"