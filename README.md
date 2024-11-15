# k8s-overleaf

Overleaf deployment for kubernetes environment. 

This deployment has been tested for a microk8s cluster with NFS for permanent storage. 

## Deployment

### Requirements:

- K8s cluster
- Kubectl
- Helm

### Build the Docker image (optional)

A version of the modified [Overleaf](https://github.com/overleaf/overleaf) image that is required for this deployment
has been uploaded to [Docker Hub](https://hub.docker.com/r/abompotas/overleaf).
However, you can build you own image using the Dockerfile in the [overleaf directory](/overleaf). 
In this case, don't forget to push the new image to a registry edit the 
[overleaf-deployment.yaml](/deployment/overleaf/overleaf-deployment.yaml) to point the correct image.

Example:
```
# Build and tag the image
docker build -t abompotas/k8s-overleaf:5 ./deployment
# Push the image to Docker Hub
docker push abompotas/k8s-overleaf:5
```

### Deploy the application

Simply run the [deploy.sh](/deployment/deploy.sh) script. 

Example:
```
cd deployment
./deploy.sh
```

### Install LaTeX packages (Optional)

Overleaf's default installation is missing some of the most common packages. These can installed by modifying the 
post-installation scripts of the sharelatex image or by executing commands directly inside the container.

Example:
```
tlmgr install collection-latexrecommended
tlmgr install collection-fontsrecommended
tlmgr install collection-latexextra
tlmgr install algorithms
tlmgr install algorithmicx
```