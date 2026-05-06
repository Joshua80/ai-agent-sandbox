#!/bin/bash
# scripts/run-sandbox.sh

# Disable Git Bash path conversion for this script session
export MSYS_NO_PATHCONV=1

PROJECT=$1

if [ "$PROJECT" == "eshop" ]; then
    echo "🏗️ Starting eShopOnWeb Sandbox..."
    docker compose up -d eshop-db
    
    echo "⏳ Waiting for SQL Server to be healthy..."
    # Note: Using the actual container name from your 'docker ps'
    # and the //opt escape for maximum compatibility
    until docker exec projects-eshop-db-1 //opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "@someThingComplicated1234" \
    -C -Q "SELECT 1" &> /dev/null; do
        echo -n "."
        sleep 2
    done
    echo -e "\n✅ SQL Server is ready."

elif [ "$PROJECT" == "medplum" ]; then
    echo "🏗️ Starting Medplum Sandbox..."
    docker compose up -d medplum-db medplum-cache
    
    echo "⏳ Waiting for PostgreSQL..."
    until docker exec projects-medplum-db-1 pg_isready -U medplum &> /dev/null; do
        echo -n "."
        sleep 2
    done
    echo -e "\n✅ PostgreSQL is ready."
fi