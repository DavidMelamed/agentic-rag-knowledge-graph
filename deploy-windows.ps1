# PowerShell deployment script for Windows
Write-Host "=== Agentic RAG Knowledge Graph Deployment (Windows) ===" -ForegroundColor Cyan
Write-Host ""

# Navigate to project directory
Set-Location $PSScriptRoot

# Build and start containers
Write-Host "1. Building and starting Docker containers..." -ForegroundColor Yellow
docker compose up -d --build

Write-Host ""
Write-Host "2. Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

Write-Host ""
Write-Host "3. Initializing Ollama models..." -ForegroundColor Yellow
docker exec agentic-rag-ollama ollama pull qwen2.5:14b-instruct
docker exec agentic-rag-ollama ollama pull qwen2.5:3b-instruct
docker exec agentic-rag-ollama ollama pull nomic-embed-text

Write-Host ""
Write-Host "4. Creating documents directory..." -ForegroundColor Yellow
if (!(Test-Path "documents")) {
    New-Item -ItemType Directory -Path "documents"
}

Write-Host ""
Write-Host "=== Deployment Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
Write-Host "- PostgreSQL: localhost:5432 (user: raguser, password: ragpass123)"
Write-Host "- Neo4j Browser: http://localhost:7474 (user: neo4j, password: password123)"
Write-Host "- Ollama: http://localhost:11434"
Write-Host "- API: http://localhost:8058"
Write-Host "- API Docs: http://localhost:8058/docs"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Copy your markdown documents to the 'documents' folder"
Write-Host "2. Run ingestion: docker exec agentic-rag-app python -m ingestion.ingest"
Write-Host "3. Start using the CLI: docker exec -it agentic-rag-app python cli.py"
Write-Host ""
Write-Host "To view logs: docker compose logs -f"
Write-Host "To stop: docker compose down"
Write-Host "To stop and remove data: docker compose down -v"