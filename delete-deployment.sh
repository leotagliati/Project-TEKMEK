#!/bin/bash

echo "=============================="
echo " Iniciando microsserviços...  "
echo "=============================="

# deployments
echo "-> k8s"
for deployment in infra/k8s/*; do
    kubectl delete -f $deployment
done

echo "-> service"
for service in infra/k8s/service/*; do
    kubectl delete -f $service
done
