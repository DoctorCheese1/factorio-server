# Factorio Dedicated Server Starter

A small Docker Compose starter for running a dedicated Factorio server with persistent saves, editable server settings, and simple start/stop scripts.

## Requirements

- Windows 10/11 or Windows Server with Docker Desktop or Docker Engine installed
- Docker Compose v2 (`docker compose`)
- PowerShell 5.1+ or PowerShell 7+
- UDP port `34197` allowed through Windows Defender Firewall and forwarded on your router for internet play
- Optional: TCP port `27015` allowed if you plan to use RCON


## Windows Docker setup for beginners

If you have not used Docker before, use Docker Desktop. Docker is the program that runs the Factorio server in a small isolated container so you do not have to manually install the Factorio headless server files.

1. Install Docker Desktop for Windows from <https://www.docker.com/products/docker-desktop/>.
2. Restart Windows if the installer asks you to.
3. Open Docker Desktop from the Start menu and wait until it says the Docker engine is running.
4. Open PowerShell in this project folder. In File Explorer, you can open the folder, click the address bar, type `powershell`, and press Enter.
5. Run `docker --version` to confirm Docker is installed.
6. Run `docker compose version` to confirm Docker Compose is installed.
7. Run `Copy-Item .env.example .env` once, then run `.\scripts\start.ps1`.

After the first start, Docker downloads the Factorio server image. That first download can take a few minutes. When it finishes, the server keeps running in the background until you stop it.

## Quick start

```powershell
Copy-Item .env.example .env
.\scripts\start.ps1
```

The server stores saves, mods, and runtime state in `./data`, which is mounted into the container as `/factorio`.

## Configuration

Edit `.env` to change the container name, Factorio image tag, game port, RCON port, save name, and mod update behavior.

Edit `config/server-settings.json` to change the server name, visibility, passwords, autosave policy, upload limits, and pause behavior. The default configuration is LAN-visible and not publicly listed.

Edit `config/map-gen-settings.json` and `config/map-settings.json` before the first save is generated to customize map generation and gameplay defaults.

For a public listed server, set `visibility.public` to `true` in `config/server-settings.json` and provide your Factorio account username/token in `.env` or directly in the server settings file.

## Windows commands

Run these from PowerShell in this repository folder:

```powershell
# Start or update the server
.\scripts\start.ps1

# Watch logs
docker compose logs -f factorio

# Stop the server
.\scripts\stop.ps1

# Restart after config changes
docker compose restart factorio
```

If PowerShell blocks local scripts, run this once for your user account and then retry the start command:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## Windows firewall

For internet play, allow inbound UDP traffic on the configured Factorio port, which defaults to `34197`. In an elevated PowerShell window you can add a Windows Defender Firewall rule with:

```powershell
New-NetFirewallRule -DisplayName "Factorio Server UDP 34197" -Direction Inbound -Protocol UDP -LocalPort 34197 -Action Allow
```

If players connect over the internet, also forward UDP `34197` from your router to the Windows host running Docker. Only open TCP `27015` if you need RCON.

## Linux/macOS commands

The Bash scripts are still included for non-Windows hosts:

```bash
./scripts/start.sh
./scripts/stop.sh
```

## Docker Desktop basics

- **Container**: the running Factorio server. This starter names it `factorio-server` by default.
- **Image**: the downloaded Factorio server package Docker uses to create the container.
- **Volume/bind mount**: the `./data` folder on your Windows host. This keeps saves and mods even if the container is recreated.
- **Compose file**: `docker-compose.yml`, which tells Docker which image, ports, settings, and folders to use.

Useful Docker commands:

```powershell
# See whether the server container is running
docker ps

# Start the server
.\scripts\start.ps1

# Watch live server logs
docker compose logs -f factorio

# Stop the server
.\scripts\stop.ps1

# Pull a newer Factorio image after changing FACTORIO_VERSION or updating later
docker compose pull
.\scripts\start.ps1
```

## Troubleshooting

- If `docker` is not recognized, install Docker Desktop, restart PowerShell, and try again.
- If Docker Desktop says WSL 2 is missing, follow the WSL 2 prompt in Docker Desktop, restart Windows, and reopen Docker Desktop.
- If `.\scripts\start.ps1` is blocked by execution policy, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once in PowerShell.
- If friends cannot connect, confirm Windows Defender Firewall allows UDP `34197` and your router forwards UDP `34197` to the Windows computer hosting Docker.
- If you change `FACTORIO_PORT` in `.env`, update your Windows firewall rule and router port forward to match.

## Backups

Stop the server or wait for an autosave, then copy the `data/saves` directory to backup storage:

```powershell
New-Item -ItemType Directory -Force backups
Copy-Item -Recurse data\saves ("backups\saves-{0}" -f (Get-Date -Format yyyyMMdd-HHmmss))
```
