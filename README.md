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

### WSL Resource advice
WSL can quietly eat RAM. Create a **.wslconfig** file under your user dir in Windows.

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

Relaunch WSL and run this script to install docker-compose, kubectl, and Kind
``` bash
./install_prereqs.sh
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
    127.0.0.1 kube.test

------------------------------------------------------------------------

# Start Services

``` bash
./launch.sh
```

Wait a couple of minutes for all services to start. 

Open each in a browser to test:
-   http://jenkins.lab
-   http://gitea.lab
-   http://nexus.lab
-   http://sonar.lab
-   http://kube.test:8088

------------------------------------------------------------------------

# Initial Setup Notes

### Jenkins

-   The generated admin password can be copied from the output of command below:

    ``` bash
    docker logs <jenkins-container>
    ```

-   Choose **Select plugins to install**, keep only the defaults for now to make it minimal
    and proceed with the rest of the installation.

-   The last window will prompt for URL, set it to:

        http://jenkins.lab

### Gitea

-   Keep all default installation settings for now and create an admin user.

-   Set:

        ROOT_URL = http://gitea.lab/

### Nexus

-   Default user: `admin`

-   To get its password:

    ``` bash
    docker exec -it <nexus-container> cat /nexus-data/admin.password
    ```

    The password will look like a SW activation key. 

### SonarQube

-   Default login: `admin / admin`

-   Set base URL:

        http://sonar.lab

------------------------------------------------------------------------

# Some commands for reference:

``` bash
docker ps -a                        # List all containers, including ones that are not running
docker stop <container_name>        # Stop unused containers (useful for lessen the load usage)
docker start <container_name>
docker remove <container_name>      # Delete the container. (e.g. To start fresh)

# Resetting entire infrastructure
docker-compose down -v --remove-orphans # Removes containers, networks, volume
docker-compose down -v --rmi all        # Removes the downloaded docker images also

# Delete entire cluster
kind delete cluster --name cicd-lab || true

# Reloading Nginx
docker compose restart nginx
```

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

