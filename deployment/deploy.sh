#!/bin/bash

cd "$(dirname "$0")"

kubectl create namespace overleaf

helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami

helm install mongo bitnami/mongodb --namespace overleaf --values ./mongo/values.yaml
helm install redis bitnami/redis --namespace overleaf --values ./redis/values.yaml

kubectl apply -n overleaf -f ./overleaf/overleaf-pvc.yaml -f ./overleaf/overleaf-variables.yaml -f ./overleaf/overleaf-deployment.yaml -f ./overleaf/overleaf-service.yaml

## Uncomment following ling to expose the application via ingress
#kubectl apply -n overleaf -f ./overleaf/overleaf-ingress.yaml