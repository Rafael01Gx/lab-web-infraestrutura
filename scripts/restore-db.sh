#!/bin/bash

set -e

BACKUP_DIR="/backups/mysql"
CONTAINER_NAME="mysql-nest-lab"
DATABASE_NAME="nestlab"
MYSQL_USER="root"
MYSQL_PASSWORD="root"

# Verificar se foi passado um arquivo de backup
if [ -z "$1" ]; then
    echo "📋 Backups disponíveis:"
    ls -lh "$BACKUP_DIR"/backup_*.sql.gz
    echo ""
    echo "Uso: ./restore-db.sh <arquivo_de_backup>"
    echo "Exemplo: ./restore-db.sh backup_nestlab_20250112_143022.sql.gz"
    exit 1
fi

BACKUP_FILE="$BACKUP_DIR/$1"

# Verificar se o arquivo existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Arquivo não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  ATENÇÃO: Esta operação irá SUBSTITUIR todos os dados do banco!"
echo "📦 Database: $DATABASE_NAME"
echo "📁 Backup: $BACKUP_FILE"
echo ""
read -p "Deseja continuar? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "❌ Operação cancelada."
    exit 1
fi

echo "🔄 Restaurando backup..."

# Descompactar e restaurar
gunzip < "$BACKUP_FILE" | docker exec -i $CONTAINER_NAME mysql \
  -u${MYSQL_USER} \
  -p${MYSQL_PASSWORD} \
  $DATABASE_NAME

echo "✅ Backup restaurado com sucesso!"