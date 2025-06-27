# Fix Docker Permissions in WSL

Run these commands in your WSL terminal:

## Step 1: Add your user to docker group
```bash
sudo usermod -aG docker $USER
```

## Step 2: Apply the group change
You have two options:

### Option A: Quick method (stay in current terminal)
```bash
newgrp docker
```

### Option B: Full refresh (recommended)
Log out of WSL and log back in:
```bash
exit
```
Then open a new WSL terminal.

## Step 3: Verify it worked
```bash
# Check if you're in docker group
groups | grep docker

# Test Docker access
docker ps
```

## Step 4: Deploy the application
Once Docker permissions are fixed:
```bash
cd ~/ottomator-agents/agentic-rag-knowledge-graph
./deploy.sh
```

If you still have issues, you can also try:
- Restart Docker Desktop on Windows
- Restart WSL: `wsl --shutdown` in PowerShell, then reopen WSL