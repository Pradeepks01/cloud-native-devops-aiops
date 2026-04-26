# E-Commerce Microservices Platform

This directory contains the core implementation of the microservices platform, including the application source code, database configuration, and local orchestration.

## 🏗️ Architecture & Flow

```text
                                    ┌─────────────┐
                                    │   Frontend  │
                                    │ (Port 3000) │
                                    └──────┬──────┘
                                           │
                                    ┌──────▼──────┐
                                    │   Gateway   │
                                    │ (Port 3001) │
                                    └──────┬──────┘
                                           │
            ┌──────────────────────────────┼──────────────────────────────┐
            │                              │                              │
     ┌──────▼──────┐              ┌────────▼──────┐             ┌────────▼──────┐
     │    Auth     │              │Product Service│             │  User Service │
     │ (Port 3002) │              │  (Port 3003)  │             │  (Port 3006)  │
     └──────┬──────┘              └───────┬───────┘             └───────┬───────┘
            │                             │
     ┌──────▼──────┐              ┌───────▼───────┐
     │Order Service│              │    Orders     │
     │ (Port 3004) │              │  (Port 3005)  │
     └──────┬──────┘              └───────────────┘
            │
     ┌──────▼──────┐
     │  PostgreSQL │
     │ (Port 5432) │
     └─────────────┘

┌──────────────────────────────────────────────────┐
│                 Monitoring Stack                 │
│   Prometheus (9090) ◄──── Grafana (3007)         │
└──────────────────────────────────────────────────┘
```

## 📦 Cloud Infrastructure (AWS EKS)

### Deployment Workflow
1. **Initialize Terraform**:
   ```bash
   cd platform/Infrastructure
   terraform init
   ```
2. **Review & Apply**:
   ```bash
   terraform plan
   terraform apply --auto-approve
   ```
   *Note: Provisioning takes ~15-20 minutes. Terraform will output the ECR URLs for your services upon completion.*

3. **Configure Access**:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name eks-cluster
   kubectl get nodes
   ```

## 🚀 From Docker to Kubernetes

Each service in `platform/ecommerce-microservices/` is containerized. When moving to Kubernetes, the following mapping applies:

| Docker Compose Concept | Kubernetes Equivalent |
|-------------------------|-----------------------|
| `image:` in compose | ECR Image URI in Deployment manifest |
| `ports:` | containerPort + Service resource |
| `environment:` | `env:` or `secretKeyRef` in Pod spec |
| `depends_on:` | Services retry/health checks (K8s starts all pods) |
| `volumes:` (Postgres) | PersistentVolumeClaim via EBS CSI driver |

## 📂 Manifest Structure

The `gitops/` directory contains the source of truth for the cluster state:
- **argo-cd.yml**: Registers this repository as an ArgoCD Application.
- **kustomization.yml**: The entry point for Kustomize (manages overlays).
- **namespace.yml**: Provisions the isolated namespace for the platform.
- **secrets.yml**: Securely stores DB connection strings.
- **k8s/**:
    - `backend/`: One Deployment + Service per microservice.
    - `frontend/`: Nginx-based frontend deployment.
    - `database/`: PostgreSQL StatefulSet and persistent storage.
    - `grafana-dashboard.yml`: Pre-configured dashboard as a ConfigMap.

## 📊 Monitoring & Metrics

The platform is pre-configured with a Prometheus/Grafana stack:
- **Prometheus**: Scrapes metrics from `/metrics` endpoints.
- **Grafana**: Access at `http://localhost:3007` (admin/admin).
