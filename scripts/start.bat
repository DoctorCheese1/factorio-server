@echo off
setlocal

cd /d "%~dp0.."

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker was not found. Install Docker Desktop for Windows, start Docker Desktop, then run this script again.
  exit /b 1
)

if not exist .env (
  copy .env.example .env >nul
  echo Created .env from .env.example. Edit .env if you want to change ports, save name, or login settings.
)

if not exist data mkdir data
if not exist config mkdir config

docker compose up -d
if errorlevel 1 exit /b %errorlevel%

echo Factorio server is starting. Follow logs with: docker compose logs -f factorio
