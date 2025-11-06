# Hospital Management System — Deployment Guide

This repository contains a fullstack Hospital Management System (backend + frontend) with Docker, Docker Compose, and Kubernetes manifests plus GitHub Actions to build container images.

Contents added by automation
- `backend/Dockerfile` — multi-stage Dockerfile (Maven build + OpenJDK runtime)
- `frontend/Dockerfile` — Node build + nginx static server
- `frontend/nginx.conf` — nginx config for SPA
- `docker-compose.yml` — local development stack (backend, frontend, MySQL)
- `k8s/` — Kubernetes manifests (deployments, services, ingress, MySQL PVC/deployment)
- `.github/workflows/build-and-push.yml` — CI to build & push images to GHCR and optionally deploy to k8s
- `.github/workflows/diagnostics.yml` — manual workflow to collect build logs
- `scripts/` — helper PowerShell scripts to run/stop docker-compose

Quick start (local Docker Compose)

1. From the repo root run (PowerShell):

```powershell
Set-Location .\hospital-management-system-main
powershell -ExecutionPolicy Bypass -File .\scripts\run-docker.ps1   # or: docker compose up --build
```

2. Services (default):
- Frontend: http://localhost:3000
- Backend: http://localhost:8089
- MySQL: 3306 (inside compose named `db`)

Stopping the stack

```powershell
.\scripts\stop-docker.ps1
```

CI / Image publishing

- On push to `main`, the workflow `build-and-push.yml` will build and push images to GitHub Container Registry (GHCR) under your account:
  - `ghcr.io/eswarvempali/hospital-management-backend:latest`
  - `ghcr.io/eswarvempali/hospital-management-frontend:latest`
- If you want automatic k8s deployment from Actions, add a repo secret named `KUBE_CONFIG` containing your base64-encoded kubeconfig.

Kubernetes deployment

1. Update the image names in `k8s/*.yaml` if you publish to a registry other than GHCR.
2. Apply manifests:

```powershell
kubectl apply -f k8s/
kubectl get pods,svc,deployments
kubectl port-forward svc/hospital-frontend 8080:80
```

Notes and recommended improvements
- Move DB credentials into Kubernetes Secrets for production.
- Add liveness/readiness probes, resource requests/limits, and configure TLS for the Ingress.
- Consider adding Spring Boot Actuator for health checks.

If you want, I can update the Dockerfile base image tags (some images required alternative tags on certain networks) or create a Helm chart for easier k8s deployment.

---
Created and updated files can be committed and pushed with:

```powershell
git add README.md
git commit -m "Add deployment README"
git push
```
