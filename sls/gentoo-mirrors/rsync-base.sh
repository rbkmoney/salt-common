#!/bin/bash

RSYNC="/usr/bin/rsync"
LOGDIR="/var/log"
bname="$(basename ${0})"
base="${bname%.*}"
if [ "${base}" == "rsync-base" ]; then
    exit 0
fi
source "/etc/rsync/${base}.conf"

logger -t rsync "Updating the ${base} from ${SRC} to ${DST}"
COMMAND="${RSYNC} ${OPTS} ${SRC} ${DST}"
echo -e "-=- Started update at $(date --rfc-3339=seconds)\n" \
     "-=- Sync command: ${COMMAND}" \
     >> "${LOGDIR}/${base}.log" 2>&1
${COMMAND} >> "${LOGDIR}/${base}.log" 2>&1
ret=$?
echo "-=- The End: $(date --rfc-3339=seconds)" >> "${LOGDIR}/${base}.log" 2>&1
if [ $ret == 0 ]; then
    logger -t rsync "Successfully updated the ${base}"
else
    logger -t rsync "Failed to update the ${base}, return code: ${ret}"
fi
exit $ret

