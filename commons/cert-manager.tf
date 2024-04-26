resource "kubectl_manifest" "cert_manager_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: cert-manager
  YAML
}



resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.12.0"
  namespace        = "cert-manager"
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }
}