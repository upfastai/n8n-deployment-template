#!/bin/bash

if [ -z "$1" ]; then
  echo "❌ Fehler: Bitte SQL-Datei als Parameter übergeben."
  echo "➡ Beispiel: ./restore_postgres.sh backup_2025-01-01.sql"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ Datei nicht gefunden: $BACKUP_FILE"
  exit 1
fi

echo "⚠️ WARNUNG: Diese Aktion überschreibt die aktuelle n8n-Datenbank!"
read -p "Möchtest du fortfahren? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "Abbruch."
  exit 0
fi

cat "$BACKUP_FILE" | docker exec -i root-postgres-1 psql -U n8n n8n

echo "✅ Restore abgeschlossen."
