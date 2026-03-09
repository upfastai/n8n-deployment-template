#!/bin/bash
set -e

BACKUP_DIR="/root/n8n-template/backups"
DATE=$(date +%F_%H-%M-%S)

mkdir -p "$BACKUP_DIR"

echo "Starte PostgreSQL Backup..."

docker exec root-postgres-1 pg_dump -U n8n n8n | gzip > "$BACKUP_DIR/backup_${DATE}.sql.gz"

echo "Backup erstellt: $BACKUP_DIR/backup_${DATE}.sql.gz"

# Alte Backups löschen (älter als 7 Tage)
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +7 -delete

echo "Alte Backups bereinigt (älter als 7 Tage)"
