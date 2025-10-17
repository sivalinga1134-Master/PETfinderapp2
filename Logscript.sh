#!/bin/bash

LOG_FILE="/var/log/petfinder.log"
ALERT_LOG="/var/log/petfinder_alerts.log"
THRESHOLD=5

# Create log files if they don’t exist
touch $LOG_FILE
touch $ALERT_LOG

# Count HTTP 500 errors in the last minute
ERROR_COUNT=$(grep "$(date '+%Y-%m-%d %H:%M')" $LOG_FILE | grep '500' | wc -l)

if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    echo "$(date): ALERT! More than $THRESHOLD HTTP 500 errors in the last minute." >> $ALERT_LOG
fi

# Log rotation: keep last 5 logs
logrotate_conf="/etc/logrotate.d/petfinder"
if [ ! -f "$logrotate_conf" ]; then
    echo "$LOG_FILE {
        size 1M
        rotate 5
        compress
        missingok
        notifempty
    }" | sudo tee $logrotate_conf
fi