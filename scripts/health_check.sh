#!/bin/bash

echo "🔍 n8n Deployment – Health Check"
echo "=================================="

# 1. Docker-Status
echo "🐳 Container Status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
echo ""

# 2. n8n Log Check
echo "📘 Letzte 10 Zeilen von n8n:"
docker logs root-n8n-1 --tail=10
echo ""

# 3. PostgreSQL Check
echo "🗄 PostgreSQL Status:"
docker exec root-postgres-1 pg_isready -U n8n
echo ""

# 4. HTTPS Check
echo "🌍 Prüfe HTTPS Erreichbarkeit:"
curl -I https://$SUBDOMAIN.$DOMAIN_NAME 2>/dev/null | head -n 5
echo ""

# 5. Task Runner Check
echo "⚙️ Task Runner Status (aus Logs):"
docker logs root-n8n-1 2>/dev/null | grep -i "Registered runner" | tail -n 3
echo ""

echo "=================================="
echo "🧪 Health Check abgeschlossen."
