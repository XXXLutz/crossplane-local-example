#!/usr/bin/env bash

kubectl wait deployment -n argocd argocd-server --for condition=Available=True --timeout=90s
echo "Initial admin password: $(kubectl get secret -n argocd argocd-initial-admin-secret -o yaml | grep "password:" | sed 's/  password: //' | base64 -d)"
kubectl -n argocd port-forward service/argocd-server 8080:80
