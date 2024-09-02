resource "kubectl_manifest" "cert_manager_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: cert-manager
  YAML
}

resource "helm_release" "cert_manager" {
  depends_on       = [kubectl_manifest.cert_manager_namespace]
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.15.1"
  namespace        = "cert-manager"
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubectl_manifest" "ingress_nginx_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: ingress-nginx
  YAML
}

resource "helm_release" "ingress_nginx" {
  depends_on = [kubectl_manifest.ingress_nginx_namespace]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"
  namespace  = "ingress-nginx"
  values = [templatefile("${path.module}/ingress-nginx.values.yaml", {
  })]
  create_namespace = false
}
