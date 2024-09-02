resource "kubectl_manifest" "admin_cluster_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: admin
rules:
  - apiGroups:
      [
        "",
        "apps",
        "batch",
        "apiextensions.k8s.io",
        "networking.k8s.io",
        "storage.k8s.io",
      ]
    resources: ["*"]
    verbs: ["*"]

  YAML
}

resource "kubectl_manifest" "admin_cluster_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin
subjects:
  - kind: Group
    name: admin
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: admin
  apiGroup: rbac.authorization.k8s.io
  YAML
}