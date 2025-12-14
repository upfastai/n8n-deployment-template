#!/bin/bash

set -e

echo "🚀 UpFastAI – n8n Auto-Installer"
echo "=========================================="

# 1. Docker installieren, falls nicht vorhanden
if ! command -v docker &> /dev/null
then
    echo "🐳 Docker nicht gefunden – Installation läuft..."
    curl -fsSL https://get.docker.com | bash
else
    echo "🐳 Docker ist bereits installiert."
fi

# Docker Compose Plugin installieren (falls nötig)
if ! docker compose version &> /dev/null
then
    echo "🔧 Docker Compose Plugin fehlt – Installation läuft..."
    apt update
    apt install docker-compose-plugin -y
else
    echo "🔧 Docker Compose Plugin vorhanden."
fi

# 2. Repository klonen
echo "📦 Klone Repository..."
mkdir -p /opt/n8n
cd /opt/n8n

if [ ! -d ".git" ]; then
    git clone https://github.com/upfastai/n8n-deployment-template .
else
    echo "📁 Repository existiert – überschreibe nicht."
fi

# 3. Beispiel-ENV kopieren
if [ ! -f ".env" ]; then
    echo "📝 Kopiere .env.example -> .env"
    cp .env.example .env
else
    echo "📝 .env existiert bereits – nichts getan."
fi

# 4. Traefik Ordner vorbereiten
mkdir -p traefik
touch traefik/acme.json
chmod 600 traefik/acme.json

# 5. Tägliche PostgreSQL-Backups aktivieren
echo "🗄️ Richte tägliche PostgreSQL-Backups ein …"

BACKUP_SCRIPT="/opt/n8n/scripts/backup_postgres.sh"
CRON_LINE="30 2 * * * $BACKUP_SCRIPT >> /var/log/n8n-postgres-backup.log 2>&1"

# Backup-Script ausführbar machen
chmod +x "$BACKUP_SCRIPT"

# Bestehende Cronjobs laden
crontab -l 2>/dev/null > /tmp/cron.tmp || true

# Cronjob nur hinzufügen, wenn er noch nicht existiert
if ! grep -q "backup_postgres.sh" /tmp/cron.tmp; then
  echo "$CRON_LINE" >> /tmp/cron.tmp
  crontab /tmp/cron.tmp
  echo "✅ Tägliche Backups aktiviert (02:30 Uhr)."
else
  echo "ℹ️ Backup-Cronjob existiert bereits."
fi

# 6. Info
echo "=========================================="
echo "✨ Installer fertig!"
echo "Bitte jetzt die Datei .env bearbeiten:"
echo "➡ nano /opt/n8n/.env"
echo ""
echo "und dann starten:"
echo "➡ docker compose up -d"
echo ""
echo "UpFastAI – Automating Intelligence"
