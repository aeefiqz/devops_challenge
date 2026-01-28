#!/usr/bin/env bash
set -u pipefail
# Usage: deploy-app.sh <image>
# Requires KUBECONFIG set in CI. Uses CI_REGISTRY, CI_REGISTRY_USER, CI_REGISTRY_PASSWORD
# when set to create imagePullSecrets for GitLab Container Registry.

IMAGE="${1:?image required}"
export IMAGE
REGISTRY="${CI_REGISTRY:-}"
REGISTRY_USER="${CI_REGISTRY_USER:-}"
REGISTRY_PASS="${CI_REGISTRY_PASSWORD:-}"

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/redis-deployment.yaml
kubectl apply -f k8s/redis-service.yaml

if [[ -n "$REGISTRY" && -n "$REGISTRY_USER" && -n "$REGISTRY_PASS" ]]; then
  kubectl create secret docker-registry gitlab-registry \
    --docker-server="$REGISTRY" \
    --docker-username="$REGISTRY_USER" \
    --docker-password="$REGISTRY_PASS" \
    -n counter-app \
    --dry-run=client -o yaml | kubectl apply -f -
fi

envsubst '${IMAGE}' < k8s/app-deployment.yaml | kubectl apply -f -
kubectl apply -f k8s/app-service.yaml

kubectl rollout status deployment/redis -n counter-app --timeout=120s
kubectl rollout status deployment/counter-app -n counter-app --timeout=300s
