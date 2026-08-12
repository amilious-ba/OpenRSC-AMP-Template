#!/bin/bash
set -e

CONF="openrsc/server/connections.conf"
SERVER_DIR="openrsc/server"

# --- Read values from environment (AMP should inject these) ---
DB_TYPE="${db_type:-}"
DB_HOST="${db_host:-}"
DB_USER="${db_user:-}"
DB_PASS="${db_pass:-}"
DB_PREFIX="${db_table_prefix:-}"

SSL_CERT="${ssl_server_cert_path:-}"
SSL_KEY="${ssl_server_key_path:-}"

DISCORD_AUCTION="${discord_auction_webhook_url:-}"
DISCORD_MONITORING="${discord_monitoring_webhook_url:-}"
DISCORD_REPORT="${discord_report_abuse_webhook_url:-}"
DISCORD_STAFF="${discord_staff_commands_webhook_url:-}"
DISCORD_NAUGHTY="${discord_naughty_words_webhook_url:-}"
DISCORD_GENERAL="${discord_general_webhook_url:-}"

MONITOR_IP="${monitor_ip:-}"
DISCORD_DOWNTIME="${discord_downtime_report_webhook_url:-}"

# --- Sanitize: never allow literal $placeholder text ---
clean() {
  local v="$1"
  local default="$2"
  # If empty or contains a $, use the default
  if [[ -z "$v" || "$v" == *'$'* ]]; then
    echo "$default"
  else
    echo "$v"
  fi
}

DB_TYPE=$(clean "$DB_TYPE" "sqlite")
DB_HOST=$(clean "$DB_HOST" "localhost:3306")
DB_USER=$(clean "$DB_USER" "openrsc")
DB_PASS=$(clean "$DB_PASS" "")
DB_PREFIX=$(clean "$DB_PREFIX" "")

SSL_CERT=$(clean "$SSL_CERT" "")
SSL_KEY=$(clean "$SSL_KEY" "")

DISCORD_AUCTION=$(clean "$DISCORD_AUCTION" "null")
DISCORD_MONITORING=$(clean "$DISCORD_MONITORING" "null")
DISCORD_REPORT=$(clean "$DISCORD_REPORT" "null")
DISCORD_STAFF=$(clean "$DISCORD_STAFF" "null")
DISCORD_NAUGHTY=$(clean "$DISCORD_NAUGHTY" "null")
DISCORD_GENERAL=$(clean "$DISCORD_GENERAL" "null")

MONITOR_IP=$(clean "$MONITOR_IP" "localhost")
DISCORD_DOWNTIME=$(clean "$DISCORD_DOWNTIME" "null")

# --- Write a clean connections.conf ---
cat > "$CONF" << EOF
db_type: ${DB_TYPE}

mysql:
        db_host: ${DB_HOST}
        db_user: ${DB_USER}
        db_pass: ${DB_PASS}
        db_table_prefix: ${DB_PREFIX}

ssl:
        ssl_server_cert_path: ${SSL_CERT}
        ssl_server_key_path: ${SSL_KEY}

discord:
        discord_auction_webhook_url: ${DISCORD_AUCTION}
        discord_monitoring_webhook_url: ${DISCORD_MONITORING}
        discord_report_abuse_webhook_url: ${DISCORD_REPORT}
        discord_staff_commands_webhook_url: ${DISCORD_STAFF}
        discord_naughty_words_webhook_url: ${DISCORD_NAUGHTY}
        discord_general_webhook_url: ${DISCORD_GENERAL}

monitor:
        monitor_ip: ${MONITOR_IP}
        discord_downtime_report_webhook_url: ${DISCORD_DOWNTIME}
EOF

echo "Updated $CONF → db_type=${DB_TYPE}, user=${DB_USER}, host=${DB_HOST}"

# --- Start the server ---
cd "$SERVER_DIR"
exec /usr/bin/ant runserver -DconfFile=local
