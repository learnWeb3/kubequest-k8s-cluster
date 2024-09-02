resource "kubectl_manifest" "developer_mysql_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
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
    verbs: ["*"]
  YAML
}
resource "kubectl_manifest" "developer_kubequest_role" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
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
    verbs: ["*"]
  YAML
}
resource "kubectl_manifest" "developer_mysql_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer
  namespace: mysql-operator
subjects:
  - kind: Group
    name: developer
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
  YAML
}
resource "kubectl_manifest" "developer_kubequest_role_binding" {
  yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer
  namespace: kubequest
subjects:
  - kind: Group
    name: developer
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
  YAML
}