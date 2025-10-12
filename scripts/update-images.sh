#!/bin/bash

set -e

echo "🔄 Atualizando imagens Docker..."

cd ../docker

# Baixar novas imagens
docker-compose pull api frontend

# Recriar apenas os containers que mudaram
docker-compose up -d api frontend

echo "✅ Imagens atualizadas!"
docker-compose ps api frontend