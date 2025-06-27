#!/bin/bash

echo "Waiting for Ollama to start..."
sleep 10

echo "Pulling required models..."
docker exec agentic-rag-ollama ollama pull qwen2.5:14b-instruct
docker exec agentic-rag-ollama ollama pull qwen2.5:3b-instruct
docker exec agentic-rag-ollama ollama pull nomic-embed-text

echo "Models downloaded successfully!"