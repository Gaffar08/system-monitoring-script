#!/bin/bash

# =====================================================
# System Monitoring Script
# Description: Monitors Disk, Memory and Top Processes
# =====================================================

# ---------------- Configuration ----------------

DISK_THRESHOLD=80
MEM_THRESHOLD=80
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/system_monitor.log"
HOST=$(hostname)

# Create logs directory if not exists
mkdir -p $LOG_DIR

# ---------------- Logging Function ----------------

log_message() {
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo "-------------------------------------------------"
    echo "        SYSTEM MONITORING REPORT"
    echo "        Host: $HOST"
    echo "        Date: $(date "+%Y-%m-%d %H:%M:%S")"
    echo "-------------------------------------------------"
}

# ---------------- Disk Monitoring ----------------

check_disk() {
    df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $1}' | while read output; do
        DISK_USAGE=$(echo $output | awk '{print $1}' | sed 's/%//')
        PARTITION=$(echo $output | awk '{print $2}')
        
        if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
            log_message "ALERT: Disk usage is HIGH on $PARTITION - ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
        else
            log_message "INFO: Disk usage is Normal on $PARTITION - ${DISK_USAGE}%"
        fi
    done
}

# ---------------- Memory Monitoring ----------------

check_memory() {
    MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

    if [ "$MEM_USAGE" -ge "$MEM_THRESHOLD" ]; then
        log_message "ALERT: Memory usage is HIGH - ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)"
    else
        log_message "INFO: Memory usage is Normal - ${MEM_USAGE}%"
    fi
}

# ---------------- Top Processes ----------------

show_top_processes() {
    log_message "Top 5 CPU Consuming Processes:"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | tee -a "$LOG_FILE"

    log_message "Top 5 Memory Consuming Processes:"
    ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6 | tee -a "$LOG_FILE"
}

# ---------------- Main Execution ----------------

print_header
check_disk
check_memory
show_top_processes

echo ""
log_message "System monitoring completed."
