resource "kubectl_manifest" "readonly_mysql_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: readonly
  namespace: mysql-operator
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
    verbs: ["get", "watch", "list"]
  YAML
}
resource "kubectl_manifest" "readonly_kubequest_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: readonly
  namespace: kubequest
rules:
  - apiGroups:
      [
        "",
        "apps",
        "batch",
        "autoscaling",
        "apiextensions.k8s.io",
        "networking.k8s.io",
        "storage.k8s.io",
      ]
    resources: ["*"]
    verbs: ["get", "watch", "list"]
  YAML
}
resource "kubectl_manifest" "readonly_mysql_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: readonly
  namespace: mysql-operator
subjects:
  - kind: Group
    name: readonly
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: readonly
  apiGroup: rbac.authorization.k8s.io
  YAML
}
resource "kubectl_manifest" "readonly_kubequest_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: readonly
  namespace: kubequest
subjects:
  - kind: Group
    name: readonly
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: readonly
  apiGroup: rbac.authorization.k8s.io
    YAML
}
