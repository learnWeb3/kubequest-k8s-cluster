resource "kubectl_manifest" "kubernetes_dashboard_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: kubernetes-dashboard
  YAML
}


resource "helm_release" "kubernetes_dashboard" {
  depends_on       = [kubectl_manifest.kubernetes_dashboard_namespace]
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  version          = "7.5.0"
  namespace        = "kubernetes-dashboard"
  create_namespace = false
  values = [templatefile("${path.module}/kubernetes-dashboard.values.yaml", {
  })]
}
