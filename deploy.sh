#!/bin/bash

echo "=== Agentic RAG Knowledge Graph Deployment ==="
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "1. Building and starting Docker containers..."
docker compose up -d --build

echo ""
echo "2. Waiting for services to be ready..."
sleep 20

echo ""
echo "3. Checking service health..."
echo -n "PostgreSQL: "
docker exec agentic-rag-postgres pg_isready -U raguser && echo "Ready" || echo "Not ready"

echo -n "Neo4j: "
curl -s http://localhost:7474 >/dev/null && echo "Ready" || echo "Not ready"

echo -n "Ollama: "
curl -s http://localhost:11434 >/dev/null && echo "Ready" || echo "Not ready"

echo ""
echo "4. Initializing Ollama models..."
./init-ollama.sh

echo ""
echo "5. Creating documents directory..."
mkdir -p documents

echo ""
echo "6. Application status:"
echo -n "API: "
curl -s http://localhost:8058/health >/dev/null && echo "Ready" || echo "Starting..."

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "Services:"
echo "- PostgreSQL: localhost:5432 (user: raguser, password: ragpass123)"
echo "- Neo4j Browser: http://localhost:7474 (user: neo4j, password: password123)"
echo "- Ollama: http://localhost:11434"
echo "- API: http://localhost:8058"
echo "- API Docs: http://localhost:8058/docs"
echo ""
echo "Next steps:"
echo "1. Copy your markdown documents to the 'documents' folder"
echo "2. Run ingestion: docker exec agentic-rag-app python -m ingestion.ingest"
echo "3. Start using the CLI: docker exec -it agentic-rag-app python cli.py"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
echo "To stop and remove data: docker compose down -v"