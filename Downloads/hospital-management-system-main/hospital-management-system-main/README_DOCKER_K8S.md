# Docker and Kubernetes deployment instructions

This repo now contains Dockerfiles, a docker-compose configuration for local testing, Kubernetes manifests under `k8s/`, and a GitHub Actions workflow to build and push container images to GitHub Container Registry (GHCR).

Files added
- `backend/Dockerfile` — builds the Spring Boot app with Maven and runs the produced JAR.
- `frontend/Dockerfile` — builds the Vite React app and serves it with nginx.
- `frontend/nginx.conf` — nginx configuration to serve a single-page app.
- `docker-compose.yml` — builds and runs backend, frontend and a local MySQL DB for development/testing.
- `.github/workflows/build-and-push.yml` — GH Actions workflow to build & push images to `ghcr.io` and optionally deploy to k8s.
- `k8s/` — Kubernetes manifests for backend/frontend services and an ingress template.

Quick local test (Docker/Compose)

1. From the repo root run (PowerShell):

```powershell
docker compose build
docker compose up
```

2. The frontend will be available at http://localhost:3000 and the backend at http://localhost:8089 (default). The docker-compose sets the backend to use the `db` MySQL container.

Notes on environment variables
- The Spring Boot `application.properties` in this repo currently uses `server.port=8089` and a JDBC URL pointing to `localhost:3306`. When running with Docker Compose the compose file sets `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME` and `SPRING_DATASOURCE_PASSWORD` so the app uses the `db` service.

Publishing images (GitHub Actions)

- The workflow `build-and-push.yml` will build both images and push to GHCR at

  - `ghcr.io/<your-org-or-user>/hospital-management-backend:latest`
  - `ghcr.io/<your-org-or-user>/hospital-management-frontend:latest`

No additional secrets are required to push to GHCR from GitHub Actions — the workflow uses the automatically provided `GITHUB_TOKEN`. If you prefer Docker Hub, replace the login and tags accordingly and add `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` secrets.

Kubernetes deployment

- The `k8s/` manifests contain Deployments and Services for frontend and backend and a simple Ingress. Update the image names in `k8s/*.yaml` to match the registry you push to (for example `ghcr.io/<your-user>/hospital-management-backend:latest`).
- To apply the manifests:

```powershell
# if you use a kubeconfig file
kubectl apply -f k8s/
```

Optional: GitHub Actions can deploy automatically if you add a `KUBE_CONFIG` secret containing your kubeconfig (base64-encoded). The example workflow contains an optional step that will apply `k8s/` when that secret exists.

Next steps / recommended improvements
- Add health/readiness probes to the k8s Deployments.
- Add resource requests/limits and increase replicas for production.
- Move sensitive values (DB password) into Kubernetes Secrets.
- Configure proper domain and TLS for the Ingress (Cert-Manager + ClusterIssuer).
