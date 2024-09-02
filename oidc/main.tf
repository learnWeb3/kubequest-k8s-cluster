resource "kubectl_manifest" "keycloak_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: keycloak
  YAML
}


resource "kubectl_manifest" "keycloak_admin_secret" {
  depends_on = [kubectl_manifest.keycloak_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: keycloak-admin-secret
  namespace: keycloak
data:
  admin-password: ${var.KEYCLOAK_UI_ADMIN_PASSWORD}
  YAML
}

resource "kubectl_manifest" "keycloak_postgres_secret" {
  depends_on = [kubectl_manifest.keycloak_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: keycloak-postgres-secret
  namespace: keycloak
data:
  postgres-password: ${var.KEYCLOAK_PG_ROOT_PASSWORD}
  password: ${var.KEYCLOAK_PG_USER_PASSWORD}
  replication-password: ${var.KEYCLOAK_PG_REPLICATION_PASSWORD}
  YAML
}

data "local_file" "keycloak_config_file" {
  filename = "${path.module}/keycloak_realms.json"
}


resource "kubectl_manifest" "keycloak_realms_import" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: realms-import
  namespace: keycloak
data: 
  config.json: | 
      ${jsonencode(jsondecode(data.local_file.keycloak_config_file.content))}
  YAML
}

resource "kubectl_manifest" "keycloak_cert_manager_issuer" {
  depends_on = [kubectl_manifest.keycloak_namespace]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: keycloak
  namespace: keycloak
spec:
  acme:
    email: antoine.le-guillou@epitech.eu
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: keycloak-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
  YAML
}

resource "helm_release" "keycloak" {
  depends_on = [
    kubectl_manifest.keycloak_namespace,
    kubectl_manifest.keycloak_admin_secret,
    kubectl_manifest.keycloak_postgres_secret,
    kubectl_manifest.keycloak_realms_import
  ]
  name             = "keycloak"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "keycloak"
  version          = "16.0.5"
  namespace        = "keycloak"
  create_namespace = false
  values = [templatefile("${path.module}/keycloak.values.yaml", {

  })]
}

resource "kubectl_manifest" "keycloak_ingress" {
  depends_on = [helm_release.keycloak, kubectl_manifest.keycloak_cert_manager_issuer]
  yaml_body  = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: keycloak-ingress
  namespace: keycloak
  annotations:
    cert-manager.io/issuer: keycloak
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-buffer-size: "256k"
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  tls:
    - hosts:
        - auth.students-epitech.ovh
      secretName: tls-keycloak
  rules:
    - host: auth.students-epitech.ovh
      http:
        paths:
          - path: /realms/kubernetes/.*
            pathType: Prefix
            backend:
              service:
                name: keycloak
                port:
                  number: 80
          - path: /resources/.*
            pathType: Prefix
            backend:
              service:
                name: keycloak
                port:
                  number: 80
          - path: /js/.*
            pathType: Prefix
            backend:
              service:
                name: keycloak
                port:
                  number: 80
  YAML
}
