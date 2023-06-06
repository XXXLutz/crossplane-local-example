#!/usr/bin/env bash

kubectl apply -f ../providers/github/install.yaml
echo "Wait for Crossplane Github provider to be installed."
kubectl wait "provider.pkg.crossplane.io/provider-github" --for=condition=healthy --timeout=60s
kubectl apply -f ../providers/github/provider-secret.yaml
kubectl apply -f ../providers/github/provider-config.yaml
