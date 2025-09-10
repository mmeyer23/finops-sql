#!/usr/bin/env bash
set -euo pipefail

CONTAINER=${1:-cloud_cost_sql_db}
DB=${2:-cloudcost}
USER=${3:-cloud}

echo "Applying views to container '$CONTAINER' database '$DB'..."
docker exec -i "$CONTAINER" psql -U "$USER" -d "$DB" -f /docker-entrypoint-initdb.d/02_views.sql
echo "Done."
