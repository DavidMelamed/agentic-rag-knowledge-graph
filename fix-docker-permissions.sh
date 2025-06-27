#!/bin/bash

echo "This script will add your user to the docker group to fix permission issues."
echo "You'll need to enter your sudo password."
echo ""

# Add user to docker group
sudo usermod -aG docker $USER

echo ""
echo "✅ Added $USER to docker group"
echo ""
echo "⚠️  IMPORTANT: You need to either:"
echo "1. Log out and log back in"
echo "2. Or run: newgrp docker"
echo ""
echo "After that, try running the deployment again."