#!/usr/bin/env bash
set -u pipefail
# Usage: rollback-app.sh [deployment-name] [namespace]
# Requires KUBECONFIG set in CI. Runs kubectl rollout undo for the app deployment.

DEPLOYMENT="${1:-counter-app}"
NAMESPACE="${2:-counter-app}"

kubectl rollout undo "deployment/$DEPLOYMENT" -n "$NAMESPACE"
kubectl rollout status "deployment/$DEPLOYMENT" -n "$NAMESPACE" --timeout=300s
