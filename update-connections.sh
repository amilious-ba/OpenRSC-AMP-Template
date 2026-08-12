cd ~/openrsc-amp-template

cat > update-connections.sh << 'EOF'
#!/bin/bash
set -e

CONF="openrsc/server/connections.conf"
SERVER_DIR="openrsc/server"

# Arguments from AMP CommandLineArgs
DB_TYPE="${1:-sqlite}"
DB_HOST="${2:-localhost:3306}"
DB_USER="${3:-openrsc}"
DB_PASS="${4:-}"
DB_PREFIX="${5:-}"

clean() {
  local v="$1"
  local default="$2"
  if [[ -z "$v" || "$v" == *'$'* || "$v" == *'{'* ]]; then
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

cat > "$CONF" << EOC
db_type: ${DB_TYPE}

mysql:
        db_host: ${DB_HOST}
        db_user: ${DB_USER}
        db_pass: ${DB_PASS}
        db_table_prefix: ${DB_PREFIX}

ssl:
        ssl_server_cert_path:
        ssl_server_key_path:

discord:
        discord_auction_webhook_url: null
        discord_monitoring_webhook_url: null
        discord_report_abuse_webhook_url: null
        discord_staff_commands_webhook_url: null
        discord_naughty_words_webhook_url: null
        discord_general_webhook_url: null

monitor:
        monitor_ip: localhost
        discord_downtime_report_webhook_url: null
EOC

echo "Updated $CONF → db_type=${DB_TYPE}, user=${DB_USER}, host=${DB_HOST}, pass_len=${#DB_PASS}"

cd "$SERVER_DIR"
exec /usr/bin/ant runserver -DconfFile=local
EOF
