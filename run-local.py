#!/usr/bin/env python3
"""
Local development runner for Agentic RAG Knowledge Graph
Run this script to test the application without Docker
"""

import os
import sys
import subprocess
from pathlib import Path

def check_environment():
    """Check if the environment is properly configured"""
    print("Checking environment configuration...")
    
    # Check for .env file
    if not Path(".env").exists():
        print("❌ .env file not found. Creating from .env.example...")
        subprocess.run(["cp", ".env.example", ".env"])
        print("✅ Created .env file. Please update it with your configuration.")
        return False
    
    # Load environment variables
    from dotenv import load_dotenv
    load_dotenv()
    
    # Check critical environment variables
    required_vars = [
        "DATABASE_URL",
        "NEO4J_URI",
        "LLM_PROVIDER",
        "LLM_API_KEY",
        "EMBEDDING_PROVIDER"
    ]
    
    missing_vars = []
    for var in required_vars:
        if not os.getenv(var):
            missing_vars.append(var)
    
    if missing_vars:
        print(f"❌ Missing required environment variables: {', '.join(missing_vars)}")
        print("Please update your .env file with the required configuration.")
        return False
    
    print("✅ Environment configuration looks good!")
    return True

def check_services():
    """Check if required services are accessible"""
    print("\nChecking service connectivity...")
    
    # Check PostgreSQL
    db_url = os.getenv("DATABASE_URL")
    if db_url:
        try:
            import asyncpg
            import asyncio
            
            async def test_db():
                try:
                    conn = await asyncpg.connect(db_url)
                    await conn.close()
                    return True
                except:
                    return False
            
            if asyncio.run(test_db()):
                print("✅ PostgreSQL connection successful")
            else:
                print("❌ Cannot connect to PostgreSQL. Make sure it's running.")
                return False
        except ImportError:
            print("⚠️  asyncpg not installed, skipping PostgreSQL check")
    
    # Check Neo4j
    neo4j_uri = os.getenv("NEO4J_URI")
    if neo4j_uri:
        try:
            from neo4j import GraphDatabase
            driver = GraphDatabase.driver(
                neo4j_uri,
                auth=(os.getenv("NEO4J_USER"), os.getenv("NEO4J_PASSWORD"))
            )
            driver.verify_connectivity()
            driver.close()
            print("✅ Neo4j connection successful")
        except:
            print("❌ Cannot connect to Neo4j. Make sure it's running.")
            return False
    
    return True

def run_application(mode="api"):
    """Run the application in the specified mode"""
    
    if mode == "api":
        print("\n🚀 Starting API server...")
        print("API will be available at http://localhost:8058")
        print("API documentation: http://localhost:8058/docs")
        print("Press Ctrl+C to stop\n")
        
        subprocess.run([sys.executable, "-m", "agent.api"])
    
    elif mode == "cli":
        print("\n🤖 Starting CLI interface...")
        subprocess.run([sys.executable, "cli.py"])
    
    elif mode == "ingest":
        print("\n📚 Starting document ingestion...")
        subprocess.run([sys.executable, "-m", "ingestion.ingest"])

def main():
    print("=== Agentic RAG Knowledge Graph - Local Runner ===\n")
    
    # Check environment
    if not check_environment():
        print("\n⚠️  Please fix the environment configuration and try again.")
        sys.exit(1)
    
    # Check services
    if not check_services():
        print("\n⚠️  Please make sure all required services are running.")
        print("You can use docker-compose to start them:")
        print("  docker compose up postgres neo4j ollama -d")
        sys.exit(1)
    
    # Ask what to run
    print("\nWhat would you like to run?")
    print("1. API Server (default)")
    print("2. CLI Interface")
    print("3. Document Ingestion")
    print("4. Exit")
    
    choice = input("\nEnter your choice (1-4) [1]: ").strip() or "1"
    
    if choice == "1":
        run_application("api")
    elif choice == "2":
        run_application("cli")
    elif choice == "3":
        run_application("ingest")
    elif choice == "4":
        print("Goodbye!")
        sys.exit(0)
    else:
        print("Invalid choice. Please try again.")
        main()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 Shutting down gracefully...")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)