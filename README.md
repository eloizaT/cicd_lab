# CI/CD Lab Setup (WSL + Docker)

This guide walks you through setting up a **production-like CI/CD lab**
on your lab machine using Docker and WSL if the target machine is in Windows. 

Ultimately, the goal here is to be able to design a **language-agnostic CI/CD pipeline** 
which is exactly how mature platforms standardize builds across diverse stacks.

------------------------------------------------------------------------

# Architecture Overview

The lab includes:

-   Jenkins (CI/CD orchestration)
-   Gitea (a lightweight Git server)
-   Nexus (artifact repository)
-   SonarQube (code quality)
-   Nginx (reverse proxy with custom hostnames)

All services run in Docker inside WSL.

------------------------------------------------------------------------

# Prerequisites

-   Windows 10/11 with WSL2
-   Docker Desktop (WSL integration enabled)

Verify:

``` bash
docker --version
```

Verify:
``` bash
docker compose version
```

If docker-compose is missing, run:
``` bash
sudo apt install docker-compose
```

------------------------------------------------------------------------

# Project Structure

    ci-lab/
     ├── docker-compose.yml
     ├── nginx/
     │    └── nginx.conf

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

# Next Steps

Once this base setup is working, you can extend the lab by adding:

-   Kubernetes (Kind or k3s)
-   Jenkins Kubernetes agents
-   Multi-repo pipelines
-   Deployment automation

------------------------------------------------------------------------

# Summary

You now have a clean, working lab CI/CD lab with:

-   Reverse proxy routing
-   Multiple integrated services
-   Production-like structure

Kubernetes can be added later once the core system is stable.
