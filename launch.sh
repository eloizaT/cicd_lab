#!/bin/bash

set -e

echo "======================================"
echo "Stopping and removing containers..."
echo "======================================"

docker-compose down -v --remove-orphans

echo ""
echo "======================================"
echo "Removing dangling Docker resources..."
echo "======================================"

docker system prune -f

echo ""
echo "======================================"
echo "Removing KIND cluster..."
echo "======================================"

kind delete cluster --name cicd-lab || true

echo ""
echo "======================================"
echo "Recreating KIND cluster..."
echo "======================================"

kind create cluster --name cicd-lab --config kind/kind_config.yaml
kubectl apply -f kube_test/deployment.yaml
kubectl apply -f kube_test/service.yaml
kubectl apply -f kube_test/ingress.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=200s

kubectl get pods -n ingress-nginx

kubectl apply -f kind/jenkins_sa.yaml

echo ""
echo "======================================"
echo "Starting CI/CD lab..."
echo "======================================"

docker-compose up -d
#docker stop cicd_lab_sonarqube_1

echo ""
echo "======================================"
echo "Done!"
echo "======================================"

echo ""
echo "Services:"
echo "  Jenkins    -> http://jenkins.lab"
echo "  Gitea      -> http://gitea.lab"
echo "  Nexus      -> http://nexus.lab"
echo "  Kebernetes -> http://kube.test:8088"
echo "  SonarQube  -> http://sonar.lab"

#ip route | grep default

