# CI/CD Lab Setup (WSL + Docker)

This guide walks you through setting up a **production-like CI/CD lab**
on your lab machine using Docker and WSL if the target machine is in Windows. 

Ultimately, the goal here is to be able to design a **language-agnostic CI/CD pipeline** 
which is exactly how mature platforms standardize builds across diverse stacks.

------------------------------------------------------------------------

# Architecture Overview

The lab includes:

-   Jenkins (CI/CD orchestration)
-   Kubernetes cluster with Ingress routing configured
-   Gitea (a lightweight Git server)
-   Nexus (artifact repository)
-   SonarQube (code quality)
-   Nginx (reverse proxy with custom hostnames)

All services run in Docker inside WSL.

------------------------------------------------------------------------

# Prerequisites

-   [Windows 10/11 with WSL2 with Docker](https://gist.github.com/dehsilvadeveloper/c3bdf0f4cdcc5c177e2fe9be671820c7)

Install docker-compose:
``` bash
sudo apt install docker-compose
```

Install **kubectl**
``` bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

Install **kind**
``` bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

chmod +x kind
sudo mv ./kind /usr/local/bin/kind
```

Verify:
``` bash
docker --version
docker compose version
kubectl version --client
```

------------------------------------------------------------------------

# Hostname Configuration (IMPORTANT)

Edit:

    C:\Windows\System32\drivers\etc\hosts

Add:

    127.0.0.1 jenkins.lab
    127.0.0.1 gitea.lab
    127.0.0.1 nexus.lab
    127.0.0.1 sonar.lab

------------------------------------------------------------------------

# Start Services

``` bash
docker-compose up -d
```

Wait a couple of minutes for all services to start. Then take a note of the names of 
the created containers by running:
``` bash
docker ps
```

Create kind cluster.
``` bash
kind create cluster --name cicd-lab --config kind/kind-config.yaml

# Verify:
kubectl get nodes
```

Install ingress.
``` bash
kubectl apply -f \
https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Check:
kubectl get pods -n ingress-nginx
```


------------------------------------------------------------------------

# Access Services

-   http://jenkins.lab
-   http://gitea.lab
-   http://nexus.lab
-   http://sonar.lab

------------------------------------------------------------------------

# Initial Setup Notes

## Jenkins

-   The generated admin password can be copied from the output of command below:

    ``` bash
    docker logs <jenkins-container>
    ```

-   Choose **Select plugins to install**, keep only the defaults for now to make it minimal
    and proceed with the rest of the installation.

-   The last window will prompt for URL, set it to:

        http://jenkins.lab

## Gitea

-   Keep all default installation settings for now and create an admin user.

-   Set:

        ROOT_URL = http://gitea.lab/

## Nexus

-   Default user: `admin`

-   To get its password:

    ``` bash
    docker exec -it <nexus-container> cat /nexus-data/admin.password
    ```

    The password will look like a SW activation key. 

## SonarQube

-   Default login: `admin / admin`

-   Set base URL:

        http://sonar.lab

------------------------------------------------------------------------

# Commands for reference:

``` bash
docker ps -a                        # List all containers, including ones that are not running
docker stop <container_name>        # Stop unused containers (useful for lessen the load usage)
docker start <container_name>
docker remove <container_name>      # Delete the container. (e.g. To start fresh)

# Resetting entire infrastructure
docker-compose down -v --remove-orphans # Removes containers, networks, volume
docker-compose down -v --rmi all        # Removes the downloaded docker images also

kind delete cluster --name cicd-lab || true
```

### WSL Resource advice
WSL can quietly eat RAM. Create this on Windows: **C:\Users\<your-user>\.wslconfig**

Content:
``` bash
[wsl2]
memory=10GB
processors=4
swap=4GB
```

Then restart WSL. Close all WSL windows,
``` bash
# Run in separate powershell window:
wsl --shutdown
```

Relaunch WSL.

### Recommended Laptop Resource Split (16 GB machine)

- WSL memory: 8-10 GB
- Kind nodes: 2 max
- Jenkins: 2 executors
- SonarQube: Run only when needed


# Next Steps

Once this base setup is working, you can extend the lab by adding:

-   Configuration to wire everything together
-   Jenkins Kubernetes agents
-   Multi-repo pipelines
-   Deployment automation


# Summary

You now have a clean, working lab CI/CD lab with:

-   Reverse proxy routing
-   Multiple integrated services
-   Production-like structure

