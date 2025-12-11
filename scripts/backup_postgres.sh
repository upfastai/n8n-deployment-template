#!/bin/bash

BACKUP_DIR="/root/n8n-template/backups"
mkdir -p "$BACKUP_DIR"

docker exec root-postgres-1 pg_dump -U n8n n8n > "$BACKUP_DIR/backup_$(date +%F_%H-%M-%S).sql"

echo "Backup erstellt unter: $BACKUP_DIR"
