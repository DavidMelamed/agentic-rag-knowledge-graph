FROM mcr.microsoft.com/devcontainers/python:3.11

RUN apt-get update && apt-get install -y \
    git curl vim postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
    && pip install black flake8 pytest ipython

USER vscode