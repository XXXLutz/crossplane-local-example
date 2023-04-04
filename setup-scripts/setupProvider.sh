#!/usr/bin/env bash

export GH_TOKEN=$(cat ../secret/token)
export GH_OWNER=$(cat ../secret/user)

kubectl apply -f ../providers/github/install.yaml
envsubst <  ../providers/github/provider-secret.yaml | kubectl apply -f -
kubectl apply -f ../providers/github/provider-config.yaml
