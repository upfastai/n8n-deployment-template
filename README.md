https://chatgpt.com/c/693addc6-ebec-8326-9a89-7f4293c01846

# 📘 n8n Deployment Template

**Automated, secure, production-ready n8n stack (Traefik + PostgreSQL + Task Runners).**

Dieses Repository stellt ein wiederverwendbares Deployment-Template bereit, um n8n auf jedem VPS (Hostinger, Hetzner, Netcup, AWS usw.) in wenigen Minuten auszurollen.

Ideal für **Beratung**, **Kundenprojekte**, **schnelle Deployments** und **skalierbare digitale Fachkräfte**.

---

## 🚀 Features

* **n8n 1.x** (Production Mode)
* **PostgreSQL 16** als externe, persistente Datenbank
* **Traefik Reverse Proxy** mit automatischen SSL-Zertifikaten
* **Interne Task Runners** (fast, stabil, zero-config)
* **Persistente Logs & Workflows**
* **Execution Retention: 1.5 Jahre**
* **DNS + HTTPS out-of-the-box**
* Vollständig über **docker-compose** gesteuert

---

# 📦 Inhalte

```
n8n-deployment-template/
│
├── docker-compose.yml        # Main deployment stack
├── .env.example              # Vorlage für Kundendaten & Secrets
└── README.md                 # Diese Anleitung
```

---

# 💾 Voraussetzungen

* VPS mit Ubuntu 22.04 oder 24.04
* Domain oder Subdomain (z. B. `n8n.example.com`)
* Docker + Docker Compose installiert

Falls Docker fehlt:

```bash
curl -fsSL https://get.docker.com | bash
```

---

# 🛠 1. Repository klonen

```bash
git clone https://github.com/upfastai/n8n-deployment-template
cd n8n-deployment-template
```

---

# 🧩 2. `.env` Datei erstellen

Aus der Vorlage kopieren:

```bash
cp .env.example .env
nano .env
```

Werte eintragen:

| Variable             | Bedeutung                                 |
| -------------------- | ----------------------------------------- |
| `DOMAIN_NAME`        | Hauptdomain, z. B. `example.com`          |
| `SUBDOMAIN`          | Subdomain, z. B. `n8n`                    |
| `GENERIC_TIMEZONE`   | z. B. `Europe/Berlin`                     |
| `POSTGRES_USER`      | PostgreSQL-Benutzer                       |
| `POSTGRES_PASSWORD`  | PostgreSQL-Passwort                       |
| `POSTGRES_DB`        | PostgreSQL-Datenbank                      |
| `N8N_ENCRYPTION_KEY` | **WICHTIG: sicher generierter Schlüssel** |
| `RUNNERS_AUTH_TOKEN` | Token für Task Runners (intern)           |

Encryption Key generieren:

```bash
openssl rand -hex 24
```

---

# 🚀 3. Deployment starten

```bash
docker compose up -d
```

Nach wenigen Sekunden ist n8n erreichbar:

```
https://SUBDOMAIN.DOMAIN_NAME
```

Beispiel:

```
https://n8n.example.com
```

---

# 🧪 4. Health Check

Alle Container prüfen:

```bash
docker ps
```

n8n-Logs ansehen:

```bash
docker logs root-n8n-1 --tail=50
```

Wenn du diese Zeilen siehst, läuft alles korrekt:

```
n8n ready on ::, port 5678
n8n Task Broker ready on 127.0.0.1, port 5679
Registered runner "JS Task Runner"
Editor is now accessible via: https://n8n.example.com
```

---

# ⚙️ Komponenten

## 🧠 n8n

* läuft im Production Mode
* nutzt PostgreSQL als DB
* interne Task Runners aktiviert
* geschrieben in Node.js + TypeScript
* Workflows, Credentials, Logs → persistiert

---

## 🗄 PostgreSQL 16

Daten bleiben erhalten, selbst wenn Container gelöscht werden:

Volume:

```
postgres_data:/var/lib/postgresql/data
```

---

## 🔐 Traefik Reverse Proxy

* automatische SSL-Zertifikate (Let's Encrypt)
* HTTP → HTTPS Redirect
* saubere Routing-Definition

---

## ⚡ Execution Retention (1.5 Jahre)

Eingestellt über diese Variablen in `docker-compose.yml`:

```
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=13140   # ~ 1,5 Jahre
EXECUTIONS_DATA_PRUNE_MAX_COUNT=0
```
---

## 🗄️ Automatische PostgreSQL-Backups (Standard)

Dieses Deployment richtet **automatisch tägliche PostgreSQL-Backups** ein, sobald der Auto-Installer ausgeführt wird.

**Zeitpunkt:** täglich um **02:30 Uhr**  
**Ablage:** `backups/`  
**Logfile:** `/var/log/n8n-postgres-backup.log`

Die Backups werden während der Installation konfiguriert – **kein manuelles Cron-Setup erforderlich**.

> Hinweis: Das Setup ist idempotent. Bei erneuter Ausführung des Installers wird kein doppelter Cronjob angelegt.

---

# 🔄 Update n8n Version

Per CLI:

```bash
docker compose pull
docker compose up -d
```

---

# 🧹 Entfernen (Cleanup)

Stoppen:

```bash
docker compose down
```

Daten löschen:

```bash
docker volume rm root_n8n_data root_postgres_data
```

---

# 📦 Backup & Restore (optional)

Backup:

```bash
docker exec root-postgres-1 pg_dump -U n8n n8n > backup.sql
```

Restore:

```bash
cat backup.sql | docker exec -i root-postgres-1 psql -U n8n n8n
```

---

# 👨‍🔧 Support / Weiterentwicklung

Dieses Template stammt aus **UpFastAI – Automating Intelligence**
und wird aktiv genutzt für:

* Digitale Fachkräfte
* OCR & KI-Agenten
* Prozessautomatisierung
* wiederverwendbare Deployments bei Kunden

---

# 🎉 Fertig!

Dieses Template ermöglicht dir:

* schnelle Wiederverwendbarkeit bei Kunden
* stabilen Betrieb (Postgres + HTTPS + Runner)
* sicheres Deployment
* einfache Wartung und Updates

---

````markdown
## 🚀 Schnellinstallation (Auto-Installer)

Mit diesem Befehl kannst du n8n auf einem neuen Ubuntu-Server in unter 60 Sekunden installieren:

```bash
curl -fsSL https://raw.githubusercontent.com/upfastai/n8n-deployment-template/main/scripts/install.sh | bash
````

Der Installer übernimmt automatisch:

* Installation von Docker & Docker Compose
* Klonen des Deployment-Repositories
* Initialisierung der Traefik-ACME-Datei
* Erstellen einer `.env` Vorlage
* Vorbereitung des Systems für den ersten Start

Nach der Installation:

```bash
nano /opt/n8n/.env
docker compose up -d
```

Fertig — n8n läuft mit PostgreSQL, Traefik, HTTPS und aktiviertem Task Runner.

## Persistence Model

This deployment uses PostgreSQL as the single source of truth.

The `.n8n` directory is **not persisted by design** to avoid state divergence
between filesystem and database, which can otherwise lead to outdated or
inconsistent workflows after updates or restores.

All workflows, credentials and execution data are stored exclusively in PostgreSQL.

```
