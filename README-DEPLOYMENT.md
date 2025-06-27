# Agentic RAG Knowledge Graph - Deployment Guide

## Prerequisites
- Docker and Docker Compose installed
- At least 8GB of RAM available
- 20GB of free disk space

## Quick Deployment

1. **Start Docker** on your system

2. **Deploy the application**:
   ```bash
   cd ottomator-agents/agentic-rag-knowledge-graph
   ./deploy.sh
   ```

## Manual Deployment Steps

If the automatic deployment doesn't work, follow these steps:

### 1. Start the services
```bash
docker compose up -d --build
```

### 2. Initialize Ollama models (after containers are running)
```bash
./init-ollama.sh
```

### 3. Verify services are running
```bash
# Check PostgreSQL
docker exec agentic-rag-postgres pg_isready -U raguser

# Check Neo4j (wait for it to be ready)
curl http://localhost:7474

# Check Ollama
curl http://localhost:11434

# Check API
curl http://localhost:8058/health
```

### 4. Prepare documents for ingestion
```bash
# Create documents directory if not exists
mkdir -p documents

# Copy sample documents (optional)
cp -r big_tech_docs/* documents/
```

### 5. Run ingestion
```bash
docker exec agentic-rag-app python -m ingestion.ingest
```

### 6. Use the application

#### Via CLI:
```bash
docker exec -it agentic-rag-app python cli.py
```

#### Via API:
- API endpoint: http://localhost:8058
- API documentation: http://localhost:8058/docs

## Service URLs
- **PostgreSQL**: localhost:5432
  - User: raguser
  - Password: ragpass123
  - Database: agentic_rag_db

- **Neo4j Browser**: http://localhost:7474
  - User: neo4j
  - Password: password123

- **Ollama**: http://localhost:11434

- **Application API**: http://localhost:8058

## Troubleshooting

### Docker not running
Make sure Docker Desktop is running on your system.

### Port conflicts
If you get port binding errors, modify the ports in docker-compose.yml

### Memory issues
Increase Docker's memory allocation in Docker Desktop settings (recommended: 8GB+)

### Ollama GPU support
The current setup includes GPU support for Nvidia. If you don't have a GPU, remove the deploy section from the ollama service in docker-compose.yml

## Useful Commands

```bash
# View logs
docker compose logs -f

# View specific service logs
docker compose logs -f app
docker compose logs -f postgres
docker compose logs -f neo4j
docker compose logs -f ollama

# Stop all services
docker compose down

# Stop and remove all data
docker compose down -v

# Restart a specific service
docker compose restart app

# Enter app container shell
docker exec -it agentic-rag-app bash

# Check database tables
docker exec -it agentic-rag-postgres psql -U raguser -d agentic_rag_db -c "\dt"
```

## Configuration

All configuration is in the `.env` file. Key settings:
- `LLM_PROVIDER`: Set to 'ollama' for local deployment
- `LLM_CHOICE`: Current model is qwen2.5:14b-instruct
- `EMBEDDING_MODEL`: nomic-embed-text
- `VECTOR_DIMENSION`: 768 (for nomic-embed-text)

To use OpenAI instead of Ollama:
1. Update `.env` file with your OpenAI API key
2. Change `LLM_PROVIDER` to 'openai'
3. Change `LLM_CHOICE` to 'gpt-4-mini'
4. Change `EMBEDDING_PROVIDER` to 'openai'
5. Change `EMBEDDING_MODEL` to 'text-embedding-3-small'
6. Change `VECTOR_DIMENSION` to 1536
7. Update sql/schema.sql vector dimensions to 1536
8. Rebuild and restart