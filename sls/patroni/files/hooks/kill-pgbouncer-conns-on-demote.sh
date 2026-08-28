#!/bin/bash

EVENT_TYPE=$1
EVENT_ACTION=$2
ROLE=$3

# Only run the command on specific events and if the role is replica.
# TODO: more complex logic for running on master restart and role change?
if [[ "$EVENT_TYPE" == "on_reload" || "$EVENT_TYPE" == "on_restart" || "$EVENT_TYPE" == "on_role_change" ]]; then
    if [[ "$ROLE" == "replica" ]]; then

        # Instantly drops all active client and server connections forcing clean reconnects.
        pgbouncer_cmd="KILL;"

        # Closes server-side connections but preserves client sessions if they route elsewhere.
        # pgbouncer_cmd="RECONNECT;"

        # Execute command via PgBouncer administrative console
        psql -h /run/postgresql -p 6432 -U postgres -d pgbouncer -c "${pgbouncer_cmd}"
    fi
fi
