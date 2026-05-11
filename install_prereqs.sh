#!/bin/bash

set -e

echo "======================================"
echo "Installing prerequisites..."
echo "======================================"

sudo apt update

#
# docker compose
#
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    echo "[OK] docker compose already installed"
else
    echo "[INFO] Installing docker compose plugin..."
    sudo apt install -y docker-compose
fi

#
# kubectl
#
if command -v kubectl >/dev/null 2>&1; then
    echo "[OK] kubectl already installed"
else
    echo "[INFO] Installing kubectl..."

    curl -LO "https://dl.k8s.io/release/$(curl -L -s \
    https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
fi

#
# kind
#
if command -v kind >/dev/null 2>&1; then
    echo "[OK] kind already installed"
else
    echo "[INFO] Installing kind..."

    curl -Lo ./_kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

    chmod +x _kind
    sudo mv ./_kind /usr/local/bin/kind
fi

echo
echo "======================================"
echo "Generating data folders"
echo "======================================"
mkdir -p ./data/jenkins
mkdir -p ./data/gitea
mkdir -p ./data/nexus
mkdir -p ./data/sonarqube

sudo chown -R 200:200 ./data/nexus
#sudo chown -R 1000:1000 ./data/jenkins
#sudo chown -R 1000:1000 ./data/sonarqube

echo
echo "======================================"
echo "Installed versions"
echo "======================================"

docker --version || true
docker compose version || true
kubectl version --client || true
kind --version || true
