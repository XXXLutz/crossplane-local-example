#!/usr/bin/env bash

kubectl apply -f ../providers/github/install.yaml
kubectl wait "provider.pkg.crossplane.io/provider-github" --for=condition=healthy --timeout=600s
kubectl apply -f ../providers/github/provider-secret.yaml
kubectl apply -f ../providers/github/provider-config.yaml
