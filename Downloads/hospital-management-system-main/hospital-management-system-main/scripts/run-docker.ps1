param(
  [switch]$Detached
)

Write-Host "Building docker images and starting containers..."
docker compose build

if ($Detached) {
    docker compose up -d
    Write-Host "Containers started in detached mode. To tail logs: docker compose logs -f"
} else {
    docker compose up
}
