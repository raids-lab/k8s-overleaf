#!/bin/bash

# Function to print usage
usage() {
    echo "Usage: bash create-secret.sh -tls {xxxxx.zip} -host {act.buaa.edu.cn} -n {namespace} {secret_name}"
    exit 1
}

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
    -tls)
        zip_file="$2"
        shift 2
        ;;
    -n)
        namespace="$2"
        shift 2
        ;;
    -host)
        host="$2"
        shift 2
        ;;
    *)
        secret_name="$1"
        shift
        ;;
    esac
done

# Check if mandatory arguments are provided
if [ -z "$zip_file" ] || [ -z "$namespace" ] || [ -z "$secret_name" ]; then
    usage
fi

# Unzip the file to $host
# if the filename ends with .zip
# if the filename ends with .tgz
# if the filename ends with .tar.gz

if [[ "$zip_file" == *.zip ]]; then
    unzip -o "$zip_file"
elif [[ "$zip_file" == *.tgz ]]; then
    tar -xzf "$zip_file"
elif [[ "$zip_file" == *.tar.gz ]]; then
    tar -xzf "$zip_file"
else
    echo "Error: Invalid file format. Please provide a zip, tgz, or tar.gz file."
    exit 1
fi



# Check if necessary files are present
if [ ! -f "$host/$host.key" ] || [ ! -f "$host/fullchain.cer" ]; then
    echo "Error: Required files are missing in the zip file."
    exit 1
fi

# Create the Kubernetes secret in yaml format
kubectl delete secret -n "$namespace" "$secret_name"
kubectl create secret tls "$secret_name" --key $host/$host.key --cert $host/fullchain.cer -n "$namespace"

# Check if secret creation was successful
if [ $? -eq 0 ]; then
    echo "Secret '$secret_name' created successfully in namespace '$namespace'."
else
    echo "Error: Failed to create secret."
    exit 1
fi

# Delete the unzipped files
rm -rf $host
