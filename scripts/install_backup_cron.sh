#!/bin/bash
set -e

CRON_FILE="/etc/cron.d/n8n-postgres-backup"
SCRIPT_PATH="/opt/n8n/scripts/backup_postgres.sh"

echo "🗄️ Installing PostgreSQL backup cronjob..."

cat <<EOF | tee "$CRON_FILE" > /dev/null
# n8n PostgreSQL daily backup
30 2 * * * root $SCRIPT_PATH >> /var/log/n8n-postgres-backup.log 2>&1
EOF

chmod 644 "$CRON_FILE"

echo "✅ Cronjob installed:"
cat "$CRON_FILE"
