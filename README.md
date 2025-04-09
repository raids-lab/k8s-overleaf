# Overleaf inside Kubernetes

## Installation of Overleaf

Refer to the Helm and Kubernetes scripts provided by [abompotas/k8s-overleaf](https://github.com/abompotas/k8s-overleaf) for installation.

Simply run the [deploy.sh](/deployment/deploy.sh) script. 

Example:
```
cd deployment
./deploy.sh
```

### Key Modifications:

1. Replace the image addresses in the Bitnami images, as they are inaccessible within Chinese mainland.
2. Modify the Service name of Overleaf. For details, refer to the first point in the Issue Log.

---

## Local Usage of Overleaf

### 1. Creating an Administrator User

> [!NOTE]
> [Creating and managing users](https://github.com/overleaf/overleaf/wiki/Creating-and-managing-users)

There are two methods:

1. Access [RAIDS Lab Overleaf, Online LaTeX Editor](https://overleaf.crater.act.buaa.edu.cn/launchpad) and create the first user.
2. Run commands manually inside the container.

---

## Issue Log

### 1. Overleaf Error: ShareLaTeX Environment Variables Detected

> [!NOTE] 
> [Configuring Overleaf](https://github.com/overleaf/overleaf/wiki/Configuring-Overleaf)

The Pod failed to start and did not execute initialization operations such as Migrate. The error message is as follows:

```shell
Warning: Use tokens from the TokenRequest API or manually created secret-based tokens instead of auto-generated secret-based tokens.
*** Running /etc/my_init.d/000_check_for_old_bind_mounts_5.sh...
*** Running /etc/my_init.d/000_check_for_old_env_vars_5.sh...
------------------------------------------------------------------------

                   ShareLaTeX to Overleaf rebranding
                   ---------------------------------

  Starting with version 5.0, ShareLaTeX branded variables are no
   longer supported as we are migrating to the Overleaf brand.

  Your configuration still uses 8 ShareLaTeX environment variables:
      - SHARELATEX_SERVICE_PORT_80
      - SHARELATEX_SERVICE_HOST
      - SHARELATEX_PORT_80_TCP
      - SHARELATEX_PORT_80_TCP_ADDR
      - SHARELATEX_PORT
      - SHARELATEX_SERVICE_PORT
      - SHARELATEX_PORT_80_TCP_PROTO
      - SHARELATEX_PORT_80_TCP_PORT

  Please either replace them with the "OVERLEAF_" prefix,
   e.g. SHARELATEX_MONGO_URL -> OVERLEAF_MONGO_URL, or
   remove old entries from your configuration.

  You can use the following script for migrating your config.

  Overleaf toolkit setups:

    github.com/overleaf/toolkit$ bin/upgrade
    github.com/overleaf/toolkit$ bin/rename-env-vars-5-0.sh


  Legacy docker compose setups/Horizontal scaling setups:

    github.com/overleaf/overleaf$ git pull
    github.com/overleaf/overleaf$ server-ce/bin/rename-env-vars-5-0.sh

    # When using a docker-compose.override.yml file (or other file name):
    github.com/overleaf/overleaf$ server-ce/bin/rename-env-vars-5-0.sh docker-compose.override.yml


  Other deployment methods:

    Try using the docker compose script or get in touch with support.


  Refusing to startup, exiting in 10s.

------------------------------------------------------------------------
*** /etc/my_init.d/000_check_for_old_env_vars_5.sh failed with status 101

*** Killing all processes...
```

It was puzzling that these environment variables were not explicitly set during the configuration process.

Upon investigation, it was determined that this issue arises due to Kubernetes automatically injecting Service-related environment variables. To resolve this, the service name should be changed from "sharelatex" to "overleaf". This ensures that Kubernetes generates environment variables with the `OVERLEAF` prefix instead of the `SHARELATEX` prefix.

---

### 2. Overleaf Compilation Error: `LaTeX Error: File ctexart.cls not found`

After switching to the XeLaTeX compiler, it was determined that the `ctex` package was not installed. To address this, all TeX Live packages were installed as follows:

```dockerfile
FROM sharelatex/sharelatex:5.4.0

RUN tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet && \
    tlmgr install scheme-full && \
    tlmgr install fandol
```

Subsequently, update the image reference in the Deployment configuration.