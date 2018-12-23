#!/bin/bash

###############################################################################
# This SMON Linux system resources monitor tool is under GPL V3.0 License.
# User could use it monitor the system performance every second.
# If user found any issue during this tool, you can send email to the following
# author or matainer at any time.
#
# Author: Zhou Guojian
# Email: joe_zgj@163.com
#
###############################################################################

#Set a Total Monitor time
Total_Run_Time=200000000

#Prepare the SMON Logs directory and env
TOPDIR=`pwd`
DATE=`date +'%Y%m%d_%H%M%S'`
LOGS_DIR_NAME="${TOPDIR}/Logs/SYS_LOG_${DATE}/"
LOGS_LATEST_LINK="${TOPDIR}/Logs/latest"

if [ -d ${LOGS_DIR_NAME} ];then
  echo "${LOGS_DIR_NAME} has been existed!!"
  sleep 1;
  DATE=`date +'%Y%m%d_%H%M%S'`
  LOGS_DIR_NAME="${TOPDIR}/Logs/SYS_LOG_${DATE}/"
fi
mkdir -p ${LOGS_DIR_NAME}

# Make sure the latest Logs link to Logs dir
# The last link to last time Logs dir
# The old link to before runtime Logs dir
# Such as latest -> Logs_20181222
# last -> Logs_20181221
# old -> Logs_20181220
if [ -L ${LOGS_LATEST_LINK}.last ];then
  mv ${LOGS_LATEST_LINK}.last ${LOGS_LATEST_LINK}.old
fi
if [ -L ${LOGS_LATEST_LINK} ];then
  mv ${LOGS_LATEST_LINK} ${LOGS_LATEST_LINK}.last
fi
ln -sf ${LOGS_DIR_NAME} ${LOGS_LATEST_LINK}

SYSTEM_MONITOR_LOG_NAME="${LOGS_DIR_NAME}/System_Monitor_Info.log"
SYSTEM_MONITOR_ALL_LOGS_NAME="${LOGS_DIR_NAME}/System_Monitor_Info.All.log"

Last_Second=0
Exec_Count=0
while :; do
  if [ $Total_Run_Time -eq $Exec_Count ];then
    echo "The SMON tool has exectued ${Exec_Conut} Seconds"
    break;
  fi
  cat /dev/null > ${SYSTEM_MONITOR_LOG_NAME}
  Latest_Second=`date +'%S'`
  if [ X"$Latest_Second" == X"$Last_Second" ];then
    sleep 0.1
    Last_Second=`date +'%S'`
    while [ X"$Latest_Second" == X"$Last_Second" ]; do
      sleep 0.1
      Last_Second=`date +'%S'`
    done
  else
    Last_Second=${Latest_Second}
  fi
  # Execute some APPs or
  # Use the No 1 PID as example
  MON_PIDS="1"
  for MON_PID in ${MON_PIDS}; do
    MON_PID_INFO=`top -d 0.1 -n 1 -p ${MON_PID} -b | tail -n1 | grep -v "TIME+"`
    if [ X"${MON_PID_INFO}" != X"" ];then
      echo "[`date +'%Y-%m-%d-%H:%M:%S'`] ProcessID : ${MON_PID_INFO}" >> ${SYSTEM_MONITOR_LOG_NAME}
    fi
  done
  cat ${SYSTEM_MONITOR_LOG_NAME} >> ${SYSTEM_MONITOR_ALL_LOGS_NAME}
done
