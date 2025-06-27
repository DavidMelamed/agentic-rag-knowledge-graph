@echo off
echo === Agentic RAG Knowledge Graph Deployment (Windows) ===
echo.

cd /d "%~dp0"

echo 1. Building and starting Docker containers...
docker compose up -d --build

echo.
echo 2. Waiting for services to be ready...
timeout /t 20 /nobreak >nul

echo.
echo 3. Initializing Ollama models...
docker exec agentic-rag-ollama ollama pull qwen2.5:14b-instruct
docker exec agentic-rag-ollama ollama pull qwen2.5:3b-instruct
docker exec agentic-rag-ollama ollama pull nomic-embed-text

echo.
echo 4. Creating documents directory...
if not exist "documents" mkdir documents

echo.
echo === Deployment Complete ===
echo.
echo Services:
echo - PostgreSQL: localhost:5432 (user: raguser, password: ragpass123)
echo - Neo4j Browser: http://localhost:7474 (user: neo4j, password: password123)
echo - Ollama: http://localhost:11434
echo - API: http://localhost:8058
echo - API Docs: http://localhost:8058/docs
echo.
echo Next steps:
echo 1. Copy your markdown documents to the 'documents' folder
echo 2. Run ingestion: docker exec agentic-rag-app python -m ingestion.ingest
echo 3. Start using the CLI: docker exec -it agentic-rag-app python cli.py
echo.
pause