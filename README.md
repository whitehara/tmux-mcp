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

## Known limitations

### `execute-command` and interactive applications (upstream issue)

By default, `execute-command` wraps commands with shell markers for exit-code tracking:

```
echo "TMUX_MCP_START"; <command>; echo "TMUX_MCP_DONE_$?"
```

When the target pane is running an interactive application (Claude Code, vim, htop, etc.) instead of a plain shell, this wrapper is sent as raw input and appears verbatim in the application's input area.

**Workaround**: pass `rawMode: true` to send keystrokes without the wrapper:

```json
{ "paneId": "%1", "command": "your message", "rawMode": true }
```

Note: `rawMode` disables exit-code tracking, so use `capture-pane` to verify results.

## Updating upstream

```bash
cd upstream && git pull origin main && cd ..
git add upstream
git commit -m "chore: bump upstream pittcat/tmux-mcp"
```
