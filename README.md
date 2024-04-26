# Andrew k8s cluster

This repository contains a terraform code to describe the Andrew infrastructure. 
This does not set up the kubernetes cluster but rather describe the different configuration for the services deployed.
Variables values are encrypted and kept locally a secret.tfvars file is referencing secrets variables values for the cluster.

## Quick start

```bash
# create a file to store the secret values
touch secret.tfvars
# inialize terraform 
terraform init
# refresh terraform state
terraform refresh 
# plan terraform required operations to achieve desired state
terraform plan
# apply the changes
terraform apply -var-file="secret.tfvars"
```