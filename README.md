# tmux-mcp

Docker Swarm stack for [pittcat/tmux-mcp](https://github.com/pittcat/tmux-mcp).

## Architecture

The `tmux-mcp` container mounts the host tmux socket and exposes an HTTP MCP server on port 8090.

### Dynamic UID

`entrypoint.sh` reads `HOST_UID` / `HOST_GID` at startup, creates a user dynamically, then drops privileges via `su-exec`. No image rebuild needed to match any host UID.

## Setup

### 1. Configure environment variables

```bash
cp .env.example .env
# Set HOST_UID / HOST_GID to match the host user running tmux (id -u / id -g)
```

### 2. Deploy

```bash
docker stack deploy -c docker-compose.yml tmux_mcp_stack
```

## Image build

GitHub Actions automatically builds and pushes `ghcr.io/whitehara/tmux-mcp:latest` on pushes to `main` or `v*` tags.

Manual build:
```bash
git submodule update --init --recursive
docker build -t ghcr.io/whitehara/tmux-mcp:latest .
```

## Updating upstream

```bash
cd upstream && git pull origin main && cd ..
git add upstream
git commit -m "chore: bump upstream pittcat/tmux-mcp"
```
