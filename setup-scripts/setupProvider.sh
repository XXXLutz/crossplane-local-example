#!/usr/bin/env bash

kubectl apply -f ../providers/github/install.yaml
kubectl apply -f ../providers/github/provider-secret.yaml
kubectl apply -f ../providers/github/provider-config.yaml
