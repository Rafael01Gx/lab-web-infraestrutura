<div align="center">

# 🚀 Lab Infrastructure

### Infraestrutura e Deployment Automatizado
**Backend NestJS + Frontend Angular + MySQL**

[![Docker](https://img.shields.io/badge/Docker-24+-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker_Compose-2.20+-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Nginx](https://img.shields.io/badge/Nginx-1.25-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)

[Quick Start](#-quick-start) • [Arquitetura](#-arquitetura) • [Serviços](#-serviços) • [Scripts](#-scripts-úteis) • [Backup](#-backup-automático)

</div>

---

## 📋 Índice

- [Pré-requisitos](#-pré-requisitos)
- [Quick Start](#-quick-start)
- [Arquitetura](#-arquitetura)
- [Serviços](#-serviços)
- [Variáveis de Ambiente](#-variáveis-de-ambiente)
- [Scripts Úteis](#-scripts-úteis)
- [Backup Automático](#-backup-automático)
- [Monitoramento](#-monitoramento)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

| Ferramenta | Versão Mínima | Download |
|------------|---------------|----------|
| 🐳 **Docker** | 24.0+ | [docker.com](https://www.docker.com/get-started) |
| 🐙 **Docker Compose** | 2.20+ | [docs.docker.com](https://docs.docker.com/compose/install/) |
| 🔑 **Docker Hub Account** | - | [hub.docker.com](https://hub.docker.com/) |

### Verificar instalação:

```bash
docker --version          # Docker version 24.0.0+
docker-compose --version  # Docker Compose version v2.20.0+
```

---

## ⚡ Quick Start

### 1️⃣ Clone o Repositório

```bash
git clone https://github.com/seu-usuario/lab-infrastructure.git
cd lab-infrastructure
```

### 2️⃣ Configure as Variáveis de Ambiente

```bash
cp .env.example .env
nano .env  # ou use seu editor preferido
```

> ⚠️ **Importante**: Altere os valores padrão, especialmente `JWT_SECRET` e senhas do banco de dados!

### 3️⃣ Inicie os Serviços

```bash
docker-compose up -d
```

### 4️⃣ Verifique o Status

```bash
docker-compose ps
```

### 5️⃣ Acesse a Aplicação

| Serviço | URL | Descrição |
|---------|-----|-----------|
| 🌐 **Frontend** | [http://localhost](http://localhost) | Aplicação Angular SSR |
| 🔧 **API** | [http://localhost/api](http://localhost/api) | Backend NestJS |
| 🗄️ **phpMyAdmin** | [http://localhost:8844](http://localhost:8844) | Administração do banco |

---

## 🏗️ Arquitetura

```mermaid
graph TB
    Client[👤 Cliente/Browser]
    
    subgraph Docker Network
        Nginx[🌐 Nginx<br/>Proxy Reverso<br/>:80, :443]
        Frontend[⚛️ Angular SSR<br/>:4000]
        API[🚀 NestJS API<br/>:3000]
        DB[(🗄️ MySQL<br/>:3306)]
        Backup[💾 Backup<br/>Automático]
        PHPMyAdmin[🔧 phpMyAdmin<br/>:8844]  #Opcional
    end
    
    Client -->|HTTP/HTTPS| Nginx
    Nginx -->|Proxy| Frontend
    Nginx -->|Proxy /api| API
    API -->|Queries| DB
    Frontend -->|API Calls| API
    Backup -.->|Backup Diário| DB
    PHPMyAdmin -->|Admin| DB
    
    style Client fill:#e1f5ff
    style Nginx fill:#90EE90
    style Frontend fill:#FFD700
    style API fill:#FF6347
    style DB fill:#4169E1
    style Backup fill:#9370DB
    style PHPMyAdmin fill:#FFA500
```

### 🔒 Segurança da Rede

- ✅ **API e Frontend**: Isolados, acessíveis apenas via Nginx
- ✅ **Banco de Dados**: Não exposto publicamente
- ✅ **Nginx**: Único ponto de entrada público
- ✅ **Backup**: Automático e versionado

---

## 🐳 Serviços

### 1. 🌐 Nginx - Proxy Reverso

**Responsabilidades:**
- Roteamento de requisições
- SSL/TLS termination
- Load balancing
- Logs centralizados

**Portas:** `80` (HTTP), `443` (HTTPS)

---

### 2. ⚛️ Frontend - Angular SSR

**Tecnologias:**
- Angular 18+
- Server-Side Rendering
- Node.js 22

**Imagem:** `xrafaelgx/angular-lab-web:latest`

**Porta Interna:** `4000` (não exposta)

---

### 3. 🚀 Backend - NestJS API

**Tecnologias:**
- NestJS
- Prisma ORM
- TypeScript
- Node.js 22

**Imagem:** `xrafaelgx/nest-lab-api:developer`

**Porta Interna:** `3000` (não exposta)

---

### 4. 🗄️ MySQL Database

**Versão:** 8.0

**Features:**
- Persistência via Docker volumes
- Health checks automáticos
- Backup automático diário

**Porta Interna:** `3306` (não exposta)

---

### 5. 💾 Backup Automático

**Container:** `fradelg/mysql-cron-backup`

**Configuração:**
- ⏰ **Agendamento**: Diário às 2h da manhã
- 📦 **Retenção**: 7 dias
- 🗜️ **Compressão**: GZIP nível 9
- 💾 **Destino**: `./backups/`

---

### 6. 🔧 phpMyAdmin

**Acesso:** [http://localhost:8844](http://localhost:8844)

**Credenciais:**
- **Servidor**: `db`
- **Usuário**: `user`
- **Senha**: `password`

---

## 🔧 Variáveis de Ambiente

### 📝 Arquivo .env.example

```bash
# ==============================================
# LAB INFRAESTRUTURA - VARIÁVEIS AMBIENTAIS
# ==============================================

# Aplicação
NODE_ENV=production
PORT=3000

# CORS
CORS_ORIGINS=http://localhost,https://seu-dominio.com

# Database
DATABASE_URL=mysql://user:password@db:3306/nestlab
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=nestlab
MYSQL_USER=user
MYSQL_PASSWORD=password

# JWT
JWT_SECRET=CHANGE-THIS-IN-PRODUCTION-use-strong-random-string
JWT_TOKEN_ISSUER=nest-lab-api
JWT_TTL=86400

# Email
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USER=seu-email@gmail.com
MAIL_PASS=sua-senha-de-app
MAIL_FROM=noreply@nestlab.com

# Docker Hub
DOCKER_USERNAME=seu-usuario
DOCKER_REGISTRY=docker.io
```

### 🔐 Variáveis Críticas

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `JWT_SECRET` | Chave secreta para tokens JWT | Use 32+ caracteres aleatórios |
| `DATABASE_URL` | Connection string do MySQL | `mysql://user:pass@db:3306/nestlab` |
| `MYSQL_ROOT_PASSWORD` | Senha do root do MySQL | Senha forte |
| `MAIL_PASS` | Senha de app do Gmail | Gerar em configurações do Gmail |

> 💡 **Dica**: Use um gerador de senhas forte para produção!

---

## 🛠️ Scripts Úteis

### 🚀 Deploy Completo

Faz o deploy completo da aplicação:

```bash
./scripts/deploy.sh
```

**O que faz:**
1. Baixa imagens mais recentes
2. Para containers antigos
3. Remove containers órfãos
4. Inicia novos containers
5. Verifica saúde dos serviços

---

### 🔄 Atualizar Imagens

Atualiza apenas as imagens do Docker Hub:

```bash
./scripts/update-images.sh
```

---

### 💾 Backup Manual

Força um backup imediato:

```bash
docker-compose exec backup /backup.sh
```

---

### 📋 Listar Backups

```bash
ls -lh backups/
```

**Saída esperada:**
```
-rw-r--r-- 1 user user 2.3M Jan 12 02:00 backup_nestlab_20250112_020000.sql.gz
-rw-r--r-- 1 user user 2.4M Jan 13 02:00 backup_nestlab_20250113_020000.sql.gz
-rw-r--r-- 1 user user 2.5M Jan 14 02:00 backup_nestlab_20250114_020000.sql.gz
```

---

### 🔙 Restaurar Backup

```bash
./scripts/restore-backup.sh backup_nestlab_20250112_020000.sql.gz
```

> ⚠️ **Atenção**: Isso substituirá todos os dados do banco atual!

---

### 📊 Ver Logs

```bash
# Todos os serviços
docker-compose logs -f

# Serviço específico
docker-compose logs -f api
docker-compose logs -f frontend
docker-compose logs -f backup

# Últimas 100 linhas
docker-compose logs --tail=100 api
```

---

### 🔍 Status dos Containers

```bash
docker-compose ps
```

---

### 🛑 Parar Serviços

```bash
# Parar todos
docker-compose down

# Parar e remover volumes (⚠️ apaga dados!)
docker-compose down -v
```

---

## 💾 Backup Automático

### ⚙️ Configuração

O sistema de backup está configurado para:

| Configuração | Valor |
|--------------|-------|
| 📅 **Frequência** | Diário às 2h da manhã |
| 🗓️ **Retenção** | 7 dias (últimos 7 backups) |
| 🗜️ **Compressão** | GZIP nível 9 (máxima) |
| 📁 **Destino** | `./backups/` |
| 🚀 **Backup Inicial** | Sim (ao iniciar container) |

### 📁 Estrutura de Backups

```
backups/
├── backup_nestlab_20250112_020000.sql.gz
├── backup_nestlab_20250113_020000.sql.gz
├── backup_nestlab_20250114_020000.sql.gz
└── ...
```

### 🔄 Personalizar Agendamento

Edite no `docker-compose.yml`:

```yaml
backup:
  environment:
    - CRON_TIME=0 2 * * *  # Modifique aqui
```

**Exemplos:**

| Agendamento | Cron Expression |
|-------------|-----------------|
| A cada 6 horas | `0 */6 * * *` |
| Duas vezes ao dia (6h e 18h) | `0 6,18 * * *` |
| Apenas domingos às 3h | `0 3 * * 0` |
| A cada 12 horas | `0 */12 * * *` |

### ☁️ Backup em Nuvem (Opcional)

Para sincronizar backups com a nuvem, veja a [documentação de backup em nuvem](docs/cloud-backup.md).

---

## 📊 Monitoramento

### 🏥 Health Checks

Todos os serviços têm health checks automáticos:

```bash
# Ver status de saúde
docker-compose ps

# Exemplo de saída:
# NAME              STATUS                    PORTS
# nest-lab-api      Up (healthy)              
# angular-lab-web   Up (healthy)              
# mysql-nest-lab    Up (healthy)              
```

### 🔗 Endpoints de Saúde

| Serviço | Endpoint | Resposta Esperada |
|---------|----------|-------------------|
| API | `http://localhost/api/health` | `200 OK` |
| Frontend | `http://localhost/` | `200 OK` |
| Nginx | `http://localhost/` | `200 OK` |

---

## 🆘 Troubleshooting

### ❌ Container não inicia

**Problema**: Container fica reiniciando constantemente

**Solução**:
```bash
# Ver logs do container
docker-compose logs nome-do-container

# Verificar se há erros de configuração
docker-compose config
```

---

### 🔌 Erro de conexão com banco de dados

**Problema**: API não consegue conectar ao MySQL

**Checklist**:
1. ✅ Verificar `DATABASE_URL` no `.env`
2. ✅ Confirmar que o container MySQL está healthy
3. ✅ Verificar credenciais do banco

```bash
# Testar conexão
docker-compose exec db mysql -uuser -ppassword -e "SELECT 1"
```

---

### 🐌 Containers lentos após iniciar

**Problema**: Aplicação demora muito para responder

**Causa**: Health checks e inicialização

**Solução**: Aguarde 30-60 segundos após `docker-compose up -d`

```bash
# Monitorar inicialização
docker-compose logs -f api frontend
```

---

### 💾 Backup não está sendo criado

**Checklist**:
1. ✅ Container de backup está rodando?
```bash
docker-compose ps backup
```

2. ✅ Ver logs do backup:
```bash
docker-compose logs backup
```

3. ✅ Verificar permissões da pasta `./backups/`:
```bash
ls -la backups/
```

---

### 🔄 Aplicação não atualiza após deploy

**Problema**: Mudanças não aparecem

**Solução**:
```bash
# Forçar pull de novas imagens
docker-compose pull

# Recriar containers
docker-compose up -d --force-recreate
```

---

### 🗑️ Limpar espaço em disco

```bash
# Remover containers parados
docker container prune -f

# Remover imagens não utilizadas
docker image prune -a -f

# Remover volumes órfãos
docker volume prune -f

# Limpeza completa (⚠️ cuidado!)
docker system prune -a --volumes -f
```

---

## 📁 Estrutura do Projeto

```
lab-infrastructure/
├── 📄 docker-compose.yml      # Configuração principal
├── 📄 .env                    # Variáveis de ambiente (não commitado)
├── 📄 .env.example            # Template de variáveis
├── 📄 .gitignore              # Arquivos ignorados pelo Git
├── 📄 README.md               # Este arquivo
│
├── 📁 nginx/                  # Configurações do Nginx
│   ├── conf.d/
│   │   └── default.conf       # Configuração do proxy reverso
│   ├── certs/                 # Certificados SSL
│   └── logs/                  # Logs do Nginx
│
├── 📁 backups/                # Backups do banco de dados
│   └── .gitkeep
│
├── 📁 scripts/                # Scripts de automação
│   ├── deploy.sh              # Deploy completo
│   ├── update-images.sh       # Atualizar imagens
│   ├── restore-db.sh          # Restaurar backup
│
└── 📁 docs/                   # Documentação adicional
    ├── architecture.md        # Detalhes da arquitetura
    ├── deployment.md          # Guia de deployment
    └── cloud-backup.md        # Configuração de backup em nuvem
```

---
