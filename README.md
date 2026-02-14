# Datavisyn DevOps Challenge

A production-grade Kubernetes deployment featuring GitOps, SSO authentication, and encrypted secrets management.

## Architecture

```
User → NGINX Ingress (TLS) → OAuth2-Proxy → Keycloak OIDC
                                    ↓
                            Modern Webapp
                         ┌────────┴────────┐
                     Frontend (NGINX)   Backend (FastAPI)
                     Glassmorphism UI    Identity API
```

## Tech Stack

| Component         | Technology                          |
|-------------------|-------------------------------------|
| Infrastructure    | Terraform (EKS) / Ansible (RHEL9)  |
| Container Orchestration | Kubernetes (EKS / kubeadm)    |
| GitOps            | ArgoCD                              |
| Identity Provider | Keycloak (Bitnami)                  |
| Auth Proxy        | OAuth2-Proxy                        |
| Secrets           | SOPS + Age (helm-secrets)           |
| TLS               | Self-Signed Certificates            |
| Ingress           | NGINX Ingress Controller            |
| Frontend          | NGINX + Vanilla JS (Glassmorphism)  |
| Backend           | Python 3.11 + FastAPI               |

## Repository Structure

```
datavisyn-challenge/
├── infrastructure/
│   ├── ansible/          # Local RHEL9 cluster provisioning
│   ├── terraform-eks/    # AWS EKS cluster (VPC, IAM, EKS)
│   └── scripts/          # Helper scripts (Helm, Age, Ingress)
│
├── charts/
│   ├── webapp/           # Original Helm chart (whoami + NGINX)
│   └── modern-webapp/    # Modern chart (FastAPI + Premium UI)
│
├── argocd/
│   ├── webapp-application.yaml          # ArgoCD App (original)
│   └── modern-webapp-application.yaml   # ArgoCD App (modern)
│
├── helm-values/
│   ├── argocd/           # ArgoCD Helm values (secure + EKS)
│   └── keycloak/         # Keycloak Helm values
│
├── kubernetes/
│   ├── storage/          # GP3 StorageClass
│   ├── dns/              # CoreDNS patches
│   └── network/          # Network fix jobs
│
├── secrets/
│   ├── .sops.yaml        # SOPS configuration
│   ├── ca.crt            # CA certificate
│   └── tls.crt           # TLS certificate
│
└── docs/
    ├── challenge-brief.pdf
    ├── argocd-deploy.md
    ├── keycloak-deploy.md
    ├── oauth2-deploy.md
    ├── webapp-deploy.md
    └── gitops-deploy.md
```

## Deployment Order

1. **Infrastructure**: Provision cluster via Ansible (local) or Terraform (EKS)
2. **Storage & Networking**: Apply GP3 StorageClass + NGINX Ingress Controller
3. **TLS**: Create self-signed certificate secret
4. **Keycloak**: Deploy via Helm with `helm-values/keycloak/`
5. **ArgoCD**: Deploy via Helm with `helm-values/argocd/` + create `sops-key` secret
6. **Webapp**: Apply ArgoCD Application manifest from `argocd/`

## Secrets Management

All sensitive values are encrypted using **SOPS with Age**:

```bash
# Encrypt
sops --encrypt --in-place charts/modern-webapp/values.yaml

# Decrypt
sops --decrypt --in-place charts/modern-webapp/values.yaml
```

Encrypted fields: `apiKey`, `clientSecret`, `cookieSecret`

## Key Domains

| Service    | URL                                        |
|------------|--------------------------------------------|
| Webapp     | `https://webapp.ember-challenge.test`       |
| Keycloak   | `https://keycloak.ember-challenge.test`     |
| ArgoCD     | `https://argocd.ember-challenge.test`       |

## Author

Mohamed Hassan Abdullah
