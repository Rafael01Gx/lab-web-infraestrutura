#!/bin/bash

set -e

# Configurações
BACKUP_DIR="/backups/mysql"
CONTAINER_NAME="mysql-nest-lab"
DATABASE_NAME="nestlab"
MYSQL_USER="root"
MYSQL_PASSWORD="root"
RETENTION_DAYS=7  # Manter backups dos últimos 7 dias

# Criar diretório se não existir
mkdir -p "$BACKUP_DIR"

# Nome do arquivo com timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_${DATABASE_NAME}_${TIMESTAMP}.sql.gz"

echo "🗄️  Iniciando backup do banco de dados..."
echo "📦 Database: $DATABASE_NAME"
echo "📁 Destino: $BACKUP_FILE"

# Fazer backup comprimido
docker exec $CONTAINER_NAME mysqldump \
  -u${MYSQL_USER} \
  -p${MYSQL_PASSWORD} \
  --single-transaction \
  --quick \
  --lock-tables=false \
  --routines \
  --triggers \
  --events \
  $DATABASE_NAME | gzip > "$BACKUP_FILE"

# Verificar se o backup foi criado
if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup criado com sucesso! Tamanho: $SIZE"
else
    echo "❌ Erro ao criar backup!"
    exit 1
fi

# Limpar backups antigos
echo "🧹 Limpando backups antigos (mantendo últimos $RETENTION_DAYS dias)..."
find "$BACKUP_DIR" -name "backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Listar backups existentes
echo ""
echo "📋 Backups disponíveis:"
ls -lh "$BACKUP_DIR"/backup_*.sql.gz 2>/dev/null || echo "Nenhum backup encontrado"

echo ""
echo "✅ Processo de backup concluído!"