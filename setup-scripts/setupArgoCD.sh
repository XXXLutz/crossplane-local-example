#!/usr/bin/env bash

kubectl create namespace argocd
kubectl apply -k ../deploy/argocd
echo "Wait for CRDs to be installed."
kubectl wait --for condition=established --timeout=60s crd/applications.argoproj.io --timeout=60s
kubectl apply -k ../deploy/argocd-apps
