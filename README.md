# Agentic RAG with Knowledge Graph 🤖

A powerful AI agent system that combines traditional RAG (Retrieval-Augmented Generation) with knowledge graph capabilities to analyze and provide insights about big tech companies and their AI initiatives.

## 🚀 Features

- **Hybrid Search**: Combines vector similarity search with knowledge graph traversal
- **Temporal Knowledge**: Tracks how information changes over time
- **Multi-LLM Support**: Works with OpenAI, Ollama, Anthropic, Google Gemini, and more
- **Streaming API**: Real-time responses with Server-Sent Events
- **Production Ready**: Comprehensive testing, error handling, and monitoring

## 🛠️ Tech Stack

- **AI Framework**: Pydantic AI
- **Knowledge Graph**: Neo4j + Graphiti
- **Vector Database**: PostgreSQL + pgvector
- **API**: FastAPI
- **LLM**: Configurable (OpenAI, Ollama, etc.)

## 📋 Prerequisites

- Docker and Docker Compose
- 8GB+ RAM
- 20GB free disk space

## 🚀 Quick Start

### 1. Clone and Navigate
```bash
git clone https://github.com/DavidMelamed/agentic-rag-knowledge-graph.git
cd agentic-rag-knowledge-graph
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Deploy with Docker
```bash
# Linux/Mac
./deploy.sh

# Windows PowerShell
.\deploy-windows.ps1

# Windows Command Prompt
deploy-windows.bat
```

### 4. Add Documents
```bash
# Create documents directory
mkdir -p documents

# Copy your markdown files or use samples
cp -r big_tech_docs/* documents/
```

### 5. Run Ingestion
```bash
docker exec agentic-rag-app python -m ingestion.ingest
```

### 6. Start Using
```bash
# CLI Interface
docker exec -it agentic-rag-app python cli.py

# API (http://localhost:8058)
curl http://localhost:8058/health
```

## 🔧 Configuration

The system supports multiple LLM providers:

### OpenAI
```env
LLM_PROVIDER=openai
LLM_API_KEY=sk-your-key
LLM_CHOICE=gpt-4-mini
```

### Ollama (Local)
```env
LLM_PROVIDER=ollama
LLM_BASE_URL=http://ollama:11434/v1
LLM_CHOICE=qwen2.5:14b-instruct
```

### Anthropic (via OpenRouter)
```env
LLM_PROVIDER=openrouter
LLM_API_KEY=your-openrouter-key
LLM_CHOICE=anthropic/claude-3-5-sonnet
```

## 📚 Documentation

- [Deployment Guide](README-DEPLOYMENT.md)
- [API Documentation](http://localhost:8058/docs)
- [Original Project README](README-ORIGINAL.md)

## 🏗️ Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   FastAPI   │────▶│  Pydantic   │────▶│     LLM     │
│   Server    │     │   AI Agent  │     │  Provider   │
└─────────────┘     └─────────────┘     └─────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
        ┌─────────────┐         ┌─────────────┐
        │ PostgreSQL  │         │    Neo4j    │
        │  pgvector   │         │   Graphiti  │
        └─────────────┘         └─────────────┘
```

## 📊 Example Queries

- **Semantic**: "What AI research is Google working on?"
- **Relational**: "How are Microsoft and OpenAI connected?"
- **Temporal**: "Show me the timeline of Meta's AI announcements"
- **Complex**: "Compare AI strategies of FAANG companies"

## 🛠️ Development

### Local Development
```bash
# Install dependencies
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run locally
python run-local.py
```

### Testing
```bash
pytest
pytest --cov=agent --cov=ingestion
```

## 🐛 Troubleshooting

### Docker Issues
- Ensure Docker Desktop is running
- Linux/WSL: Add user to docker group: `sudo usermod -aG docker $USER`

### Port Conflicts
- Modify ports in `docker-compose.yml`

### Memory Issues
- Increase Docker memory allocation (8GB+ recommended)

## 📄 License

This project is based on the [ottomator-agents](https://github.com/coleam00/ottomator-agents) repository.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🌟 Acknowledgments

- Original project by [coleam00](https://github.com/coleam00)
- Built with Pydantic AI, FastAPI, PostgreSQL, and Neo4j