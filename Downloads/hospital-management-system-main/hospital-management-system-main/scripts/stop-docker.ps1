Write-Host "Stopping and removing docker-compose containers and volumes..."
docker compose down --volumes --remove-orphans
Write-Host "Stopped and removed containers."
