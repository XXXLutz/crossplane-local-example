#!/usr/bin/env bash

kind create cluster --name crossplane-test
kubectl cluster-info --context crossplane-test

kubectl create namespace crossplane-system
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane --namespace crossplane-system crossplane-stable/crossplane

helm list -n crossplane-system

kubectl get all -n crossplane-system
