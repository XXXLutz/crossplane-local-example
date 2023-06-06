#!/usr/bin/env bash

kind create cluster --name crossplane-test

kubectl create namespace crossplane-system
helm install crossplane https://charts.crossplane.io/stable/crossplane-1.12.1.tgz --namespace crossplane-system --wait

helm list -n crossplane-system
kubectl get all -n crossplane-system
