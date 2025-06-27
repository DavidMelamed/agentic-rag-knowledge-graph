#!/bin/bash

echo "=== Testing Docker Permissions ==="
echo ""

# Check if user is in docker group
if groups | grep -q docker; then
    echo "✅ You are in the docker group"
else
    echo "❌ You are NOT in the docker group"
    echo "   Run: sudo usermod -aG docker $USER"
    echo "   Then: newgrp docker (or log out and back in)"
    exit 1
fi

# Test Docker access
echo ""
echo "Testing Docker access..."
if docker ps >/dev/null 2>&1; then
    echo "✅ Docker access successful!"
    echo ""
    echo "You can now run: ./deploy.sh"
else
    echo "❌ Docker access failed"
    echo "   Try: newgrp docker"
    echo "   Or restart your WSL session"
    exit 1
fi