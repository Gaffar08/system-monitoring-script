# system-monitoring-script
Production-ready Linux system monitoring script using Bash with threshold-based alerts, logging, and process monitoring.

## 📌 Project Overview

The **System Monitoring Script** is a lightweight Bash-based monitoring tool designed to track critical system resources in a Linux environment.

This script helps identify potential system performance issues by monitoring:

- Disk usage
- Memory utilization
- Top CPU-consuming processes
- Top memory-consuming processes

It generates clear alert messages when defined thresholds are exceeded and optionally logs results to a file for audit and troubleshooting purposes.

---

## 🏗️ Project Structure

system-monitoring-script/
│
├── system_monitor.sh
├── README.md
└── logs/
    └── system_monitor.log

---

## ⚙️ Configuration

Threshold values can be modified inside the script:

