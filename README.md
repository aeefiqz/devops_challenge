# devops_challenge

My solution to devops challenge.

## CI/CD (GitLab)

Pipeline stages: **build** → **deploy** → **rollback**.

- **Build**: Go build, Docker build & push to GitLab Container Registry.
- **Deploy**:  
  - **Infrastructure**: Terraform apply for dev (auto on `main`), staging/uat/prod (manual).  
  - **Application**: Deploy to EKS via `k8s/` manifests; dev auto, others manual.
- **Rollback**: Manual jobs to undo app (`kubectl rollout undo`) or infra (Terraform apply from previous commit).

### Required CI/CD variables

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` for Terraform

### design
