Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker was not found. Install Docker Desktop for Windows, then run this script again.'
}

if (-not (Test-Path '.env')) {
    Copy-Item '.env.example' '.env'
    Write-Host 'Created .env from .env.example. Edit .env if you want to change ports, save name, or login settings.'
}

New-Item -ItemType Directory -Force -Path 'data', 'config' | Out-Null

docker compose up -d

Write-Host 'Factorio server is starting. Follow logs with: docker compose logs -f factorio'
