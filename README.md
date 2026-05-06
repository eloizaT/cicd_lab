# CI/CD Lab Setup (WSL + Docker)

This guide walks you through setting up a **production-like CI/CD lab**
on your lab machine using WSL and Docker.

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

Wait a couple of minutes for all services to start.

------------------------------------------------------------------------

# Access Services

-   http://jenkins.lab
-   http://gitea.lab
-   http://nexus.lab
-   http://sonar.lab

------------------------------------------------------------------------

# Initial Setup Notes

## Jenkins

-   Unlock using:

    ``` bash
    docker logs <jenkins-container>
    ```

-   Set URL:

        http://jenkins.lab

## Gitea

-   Create admin user

-   Set:

        ROOT_URL = http://gitea.lab/

## Nexus

-   Default user: `admin`

-   Get password:

    ``` bash
    docker exec -it <nexus-container> cat /nexus-data/admin.password
    ```

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
