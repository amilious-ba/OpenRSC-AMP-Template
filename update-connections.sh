#!/bin/bash
# update-connections.sh
set -e

CONF="openrsc/server/connections.conf"
SERVER_DIR="openrsc/server"

DB_TYPE="${db_type:-sqlite}"
DB_HOST="${db_host:-localhost:3306}"
DB_USER="${db_user:-openrsc}"
DB_PASS="${db_pass:-}"
DB_PREFIX="${db_table_prefix:-}"

SSL_CERT="${ssl_server_cert_path:-}"
SSL_KEY="${ssl_server_key_path:-}"

DISCORD_AUCTION="${discord_auction_webhook_url:-null}"
DISCORD_MONITORING="${discord_monitoring_webhook_url:-null}"
DISCORD_REPORT="${discord_report_abuse_webhook_url:-null}"
DISCORD_STAFF="${discord_staff_commands_webhook_url:-null}"
DISCORD_NAUGHTY="${discord_naughty_words_webhook_url:-null}"
DISCORD_GENERAL="${discord_general_webhook_url:-null}"

MONITOR_IP="${monitor_ip:-localhost}"
DISCORD_DOWNTIME="${discord_downtime_report_webhook_url:-null}"

[[ -z "$DISCORD_AUCTION" ]] && DISCORD_AUCTION="null"
[[ -z "$DISCORD_MONITORING" ]] && DISCORD_MONITORING="null"
[[ -z "$DISCORD_REPORT" ]] && DISCORD_REPORT="null"
[[ -z "$DISCORD_STAFF" ]] && DISCORD_STAFF="null"
[[ -z "$DISCORD_NAUGHTY" ]] && DISCORD_NAUGHTY="null"
[[ -z "$DISCORD_GENERAL" ]] && DISCORD_GENERAL="null"
[[ -z "$DISCORD_DOWNTIME" ]] && DISCORD_DOWNTIME="null"

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

echo "Updated $CONF (db_type=${DB_TYPE}, user=${DB_USER})"

cd "$SERVER_DIR"
exec /usr/bin/ant runserver -DconfFile=local
