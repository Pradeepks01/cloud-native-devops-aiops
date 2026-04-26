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

3. **Configure Access**:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name eks-cluster
   kubectl get nodes
   ```

## 🚀 From Docker to Kubernetes

| Docker Compose Concept | Kubernetes Equivalent |
|-------------------------|-----------------------|
| `image:` in compose | ECR Image URI in Deployment manifest |
| `ports:` | containerPort + Service resource |
| `environment:` | `env:` or `secretKeyRef` in Pod spec |
| `depends_on:` | Services retry/health checks (K8s starts all pods) |
| `volumes:` (Postgres) | PersistentVolumeClaim via EBS CSI driver |

## 📂 Manifest Structure

- **argo-cd.yml**: ArgoCD Application registration.
- **kustomization.yml**: Kustomize entry point.
- **namespace.yml**: Provisions isolated namespace.
- **secrets.yml**: Stores DB connection strings.
- **k8s/**: backend, frontend, database manifests and Grafana dashboards.

## 📊 Monitoring & Metrics
- **Prometheus**: `http://localhost:9090`
- **Grafana**: `http://localhost:3007` (admin/admin)
