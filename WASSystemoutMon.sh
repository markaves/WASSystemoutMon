#!/usr/bin/ksh
#Title: WebSphere Systemout Monitor
#Date: 2015/08/07
#Author: Mark Aves

##Variables
LOGDIR=/usr/IBM/WebSphere/AppServer/profiles/Custom01/logs/<wasAppServer>
LOGFILE=$LOGDIR/SystemOut.log

WRKDIR=/usr/IBM/scripts/WASSystemoutMon
LOGLINECntFile=$WRKDIR/LOGLINECnt.txt
TEMPFile=$WRKDIR/temp.txt

now=`date '+%y%m%d%H%M'`

##Main
LOGLINECnt=`wc -l $LOGFILE | tr -s ' ' | cut -d" " -f2`
LOGLINECntOld=`cat $LOGLINECntFile`
echo $LOGLINECnt > $LOGLINECntFile

if [ $LOGLINECnt -gt $LOGLINECntOld ]
then
        lineStart=$(($LOGLINECntOld+1))
elif [ $LOGLINECnt -eq $LOGLINECntOld ]
then
        exit 0
else
        lineStart=1
fi

tail +$lineStart $LOGFILE | grep J2CA0045E > $TEMPFile
if [ $? -eq 0 ]
then
        entryCount=`wc -l $TEMPFile | tr -s ' '|  cut -d" " -f2`
        echo "$now WebSphere JDBC error J2CA0045E found.  Contact Support." >> /usr/IBM/scripts/listener_monitoring/listener.log
fi

