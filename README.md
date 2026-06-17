# Factorio Dedicated Server Starter

A small Docker Compose starter for running a dedicated Factorio server with persistent saves, editable server settings, and simple start/stop scripts.

## Requirements

- Windows 10/11 or Windows Server with Docker Desktop or Docker Engine installed
- Docker Compose v2 (`docker compose`)
- PowerShell 5.1+ or PowerShell 7+
- UDP port `34197` allowed through Windows Defender Firewall and forwarded on your router for internet play
- Optional: TCP port `27015` allowed if you plan to use RCON

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

## Backups

Stop the server or wait for an autosave, then copy the `data/saves` directory to backup storage:

```powershell
New-Item -ItemType Directory -Force backups
Copy-Item -Recurse data\saves ("backups\saves-{0}" -f (Get-Date -Format yyyyMMdd-HHmmss))
```
