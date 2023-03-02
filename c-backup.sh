#!/bin/bash

# Check that both arguments are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <syncing_directory> <backup_directory>"
  exit 1
fi

SYNC_DIR=$1
BACKUP_DIR=$2
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it does not exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
fi

# Create backup archive
tar czf "$BACKUP_DIR/backup_$DATE.tar.gz" "$SYNC_DIR"

# Write log entry for backup creation
echo "$(date '+%Y-%m-%d %H:%M:%S') - Created backup archive $BACKUP_DIR/backup_$DATE.tar.gz" >> backup.log
