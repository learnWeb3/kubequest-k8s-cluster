terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.1"
    }
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
  config_context = "cluster-coezrkrs46q"
  load_config_file = false
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}