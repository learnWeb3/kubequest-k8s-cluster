resource "kubectl_manifest" "kubequest_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: kubequest
  YAML
}

resource "kubectl_manifest" "kubequest_cert_manager_issuer" {
  depends_on = [kubectl_manifest.kubequest_namespace]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: kubequest
  namespace: kubequest
spec:
  acme:
    email: antoine.le-guillou@epitech.eu
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: kubequest-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
  YAML
}