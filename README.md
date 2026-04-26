# Cloud Native DevOps & AIOps Platform

This repository contains a comprehensive, production-grade E-Commerce Microservices platform designed for Cloud Native deployment using DevOps and AIOps best practices.

## 🚀 Project Overview

The platform is a boutique e-commerce application consisting of 7 distinct microservices, a central PostgreSQL database, and a full observability stack (Prometheus, Grafana). It is designed to be deployed both locally for development and to AWS EKS for production.

### Key Features
- **Microservices Architecture**: 7 Decoupled services (Auth, Product, Order, User, Gateway, Order-Management, Orders).
- **Frontend**: Modern React application with a luxury fashion aesthetic.
- **Infrastructure as Code**: Fully automated EKS cluster provisioning using Terraform.
- **GitOps**: Automated deployments and synchronization using ArgoCD (provisioned via Helm).
- **CI/CD Pipeline**: GitHub Actions workflow for automated Docker builds, ECR pushing, and K8s manifest updates.
- **Observability**: Real-time metrics collection with Prometheus and visualization with Grafana.
- **Asset Rebranding**: High-resolution, AI-generated men's luxury fashion catalog.

## 📂 Project Structure

```text
.
├── platform/
│   ├── ecommerce-microservices/  # Application source code & Docker Compose
│   └── Infrastructure/           # Terraform modules (EKS, VPC, ECR, ArgoCD)
├── gitops/                       # Kubernetes manifests (Kustomize) & ArgoCD Apps
├── .github/workflows/            # GitHub Actions CI/CD Pipeline
└── Issues.md                     # Comprehensive Troubleshooting Guide
```

## 🛠️ Quick Start

### Local Development (Docker Compose)
1. Navigate to the microservices directory:
   ```bash
   cd platform/ecommerce-microservices
   ```
2. Build and start the environment:
   ```bash
   docker-compose up -d --build
   ```
3. Access the application:
   - Frontend: `http://localhost:3000`
   - Gateway API: `http://localhost:3001`
   - Prometheus: `http://localhost:9090`
   - Grafana: `http://localhost:3007` (admin/admin)

### Cloud Deployment (AWS EKS)
The project is configured for a full GitOps flow on AWS EKS. Detailed instructions for provisioning infrastructure and deploying via ArgoCD can be found in [platform/README.md](platform/README.md).

## 📊 CI/CD Flow
1. **Developer pushes code** to `main`.
2. **GitHub Actions** triggers a multi-service build.
3. **Docker Images** are pushed to Amazon ECR with the commit SHA as the tag.
4. **Manifests Update**: The CI job automatically updates `gitops/k8s/` manifests with the new image tags.
5. **ArgoCD** detects the change in Git and synchronizes the EKS cluster to the new version.
