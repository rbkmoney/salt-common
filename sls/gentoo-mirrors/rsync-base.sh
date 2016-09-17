#!/bin/bash

RSYNC="/usr/bin/rsync"
LOGDIR="/var/log"
bname="$(basename ${0})"
base="${bname%.*}"
if [ "${base}" == "rsync-base" ]; then
    exit 0
fi
source "/etc/rsync/${base}.conf"

echo "Started update at" `date` >> "${LOGDIR}/${base}.log" 2>&1
logger -t rsync "re-rsyncing the gentoo-amd64-packages"
${RSYNC} ${OPTS} ${SRC} ${DST} >> "${LOGDIR}/${base}.log" 2>&1

echo "End: "`date` >> "${LOGDIR}/${base}.log" 2>&1
