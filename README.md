# devops_challenge

My solution to devops challenge.

## CI/CD (GitLab)

Pipeline stages: **build** → **test** → **deploy** → **rollback**.

- **Build**: Go build, Docker build & push to GitLab Container Registry.
- **Test**: `go vet` / `go test`, Docker build check, `docker-compose` smoke test, Terraform validate & plan (dev).
- **Deploy**:  
  - **Infrastructure**: Terraform apply for dev (auto on `main`), staging/uat/prod (manual).  
  - **Application**: Deploy to EKS via `k8s/` manifests; dev auto, others manual.
- **Rollback**: Manual jobs to undo app (`kubectl rollout undo`) or infra (Terraform apply from previous commit).

### Required CI/CD variables

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (masked) for Terraform and EKS `kubeconfig`.

### Notes

- Use **remote Terraform backend** (e.g. S3) for deploy/rollback; local state is lost between CI runs.
- Optional `ROLLBACK_COMMIT` for infra rollback; defaults to `CI_COMMIT_BEFORE_SHA`.
- Run `terraform plan` for dev in test stage; artifact `eks-cluster/tfplan-dev` kept for 1 week.
