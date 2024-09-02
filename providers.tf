terraform {
  backend "gcs" {
    # bucket = "t-clo-902-terraform-bucket"
    bucket = "kubequest-terraform"
    prefix = "k8s/"
  }
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.1"
    }
  }
}

provider "kubectl" {
  token                  = base64decode(var.K8S_TOKEN)
  cluster_ca_certificate = base64decode(var.K8S_CACERT)
  host                   = var.K8S_HOST
  load_config_file       = false
}

provider "kubernetes" {
  token                  = base64decode(var.K8S_TOKEN)
  cluster_ca_certificate = base64decode(var.K8S_CACERT)
  host                   = var.K8S_HOST
}

provider "helm" {
  kubernetes {
    token                  = base64decode(var.K8S_TOKEN)
    cluster_ca_certificate = base64decode(var.K8S_CACERT)
    host                   = var.K8S_HOST
  }
}
