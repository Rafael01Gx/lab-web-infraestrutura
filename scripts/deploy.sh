#!/bin/bash

set -e

echo "🚀 Iniciando deploy..."

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Carregar variáveis de ambiente
if [ -f ../.env ]; then
    export $(cat ../.env | grep -v '#' | xargs)
fi

echo -e "${YELLOW}📥 Baixando imagens mais recentes...${NC}"
cd ../docker
docker-compose pull

echo -e "${YELLOW}🛑 Parando containers antigos...${NC}"
docker-compose down

echo -e "${YELLOW}🗑️  Removendo containers e volumes órfãos...${NC}"
docker system prune -f

echo -e "${YELLOW}🚀 Iniciando novos containers...${NC}"
docker-compose up -d

echo -e "${YELLOW}⏳ Aguardando containers ficarem saudáveis...${NC}"
sleep 10

echo -e "${YELLOW}📊 Status dos containers:${NC}"
docker-compose ps

echo -e "${GREEN}✅ Deploy concluído com sucesso!${NC}"
echo -e "${GREEN}🌐 Aplicação disponível em: http://localhost${NC}"
echo -e "${GREEN}📝 Logs: docker-compose logs -f${NC}"