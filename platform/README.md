# Platform & Infrastructure

This directory contains the core application stack and the Infrastructure as Code (IaC) required to provision its cloud environment.

## 🏗️ Microservices Architecture

```mermaid
graph TD
    Client([Web Client])
    
    subgraph "Kubernetes Cluster / Docker Compose"
        Nginx[Frontend Nginx / React]
        Gateway[API Gateway :3001]
        
        subgraph "Backend Microservices"
            Auth[Auth Service]
            Product[Product Service]
            Order[Order Service]
            OrdersMgmt[Orders Management]
            User[User Service]
        end
        
        subgraph "PostgreSQL"
            DB[(PostgreSQL 15)]
            db1[(auth_db)]
            db2[(products_db)]
            db3[(orders_db)]
            db4[(users_db)]
            DB --- db1 & db2 & db3 & db4
        end
    end

    Client -->|Static Assets| Nginx
    Client -->|API Requests| Gateway
    
    Gateway -->|/api/auth| Auth
    Gateway -->|/api/products| Product
    Gateway -->|/api/orders| Order
    Gateway -->|/api/users| User
    
    Auth --> db1
    Product --> db2
    Order --> db3
    Order --> Auth
    Order --> Product
    OrdersMgmt --> db3
    User --> db4
```

## Directory Structure

### 1. `ecommerce-microservices/`
The full-stack e-commerce application.
- **Backend Services**: A Node.js/Express microservices architecture.
- **Frontend**: A React SPA served by Nginx.
- **Database**: PostgreSQL (handling logical isolation).
- **Observability**: Custom metrics exposed via `prom-client` middleware.

### Service Registry & Ports

| Service | Port | Role |
|---------|------|------|
| Frontend | 3000 | React UI |
| Gateway | 3001 | Routes all client requests to backend services |
| Auth | 3002 | Login and registration |
| Product Service | 3003 | Product catalog and inventory |
| Order Service | 3004 | Cart and checkout |
| Orders | 3005 | Order history and management |
| User Service | 3006 | User profiles and account management |
| PostgreSQL | 5432 | Stores auth_db, products_db, orders_db, users_db |
| Prometheus | 9090 | Metrics collection |
| Grafana | 8080 | Metrics dashboards |

**Local Development**:
```bash
cd ecommerce-microservices
docker-compose up -d
```

### 2. `Infrastructure/`
Terraform configurations for provisioning the AWS cloud environment.
- **VPC (`modules/vpc`)**: Custom network topology.
- **EKS (`modules/eks`)**: Elastic Kubernetes Service cluster.
- **ECR (`modules/ecr`)**: Container registries.
- **ArgoCD & Monitoring Bootstrap (`modules/argocd`)**: Automatically deploys ArgoCD and `kube-prometheus-stack`.

**Provisioning Infrastructure**:
```bash
cd Infrastructure
terraform init
terraform apply
```
