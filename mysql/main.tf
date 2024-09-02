resource "kubectl_manifest" "mysql_operator_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: mysql-operator
  YAML
}


resource "helm_release" "mysql_operator" {
  name             = "mysql-operator"
  repository       = "https://helm-charts.bitpoke.io"
  chart            = "mysql-operator"
  version          = "0.6.3"
  namespace        = "mysql-operator"
  create_namespace = false
  values = [templatefile("${path.module}/mysql-operator.values.yaml", {
  })]
}

resource "kubectl_manifest" "mysql_cluster_secret" {
  depends_on = [kubectl_manifest.mysql_operator_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: mysql-cluster
  namespace: mysql-operator
data:
  ROOT_PASSWORD: ${var.DB_ROOT_PASSWORD}
  USER: ${var.DB_USERNAME}
  PASSWORD:  ${var.DB_PASSWORD}
  DATABASE: a3ViZXF1ZXN0
  YAML
}

resource "kubectl_manifest" "mysql_cluster_backup_secret" {
  depends_on = [kubectl_manifest.mysql_operator_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: mysql-cluster-backup-secret
type: Opaque
data:
  GCS_SERVICE_ACCOUNT_JSON_KEY: ${var.GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP}
  GCS_PROJECT_ID: ${var.GCS_PROJECT_ID_MYSQL_BACKUP}
  YAML
}



resource "kubectl_manifest" "mysql_cluster" {
  depends_on = [kubectl_manifest.mysql_cluster_secret, kubectl_manifest.mysql_cluster_backup_secret, helm_release.mysql_operator]
  yaml_body  = <<YAML
apiVersion: mysql.presslabs.org/v1alpha1
kind: MysqlCluster
metadata:
  name: mysql-cluster
  namespace: mysql-operator
spec:
  replicas: 3
  secretName: mysql-cluster
  backupSchedule: "0 0 * * * *"
  storageClassName: standard
  backupSecretName: mysql-cluster-backup-secret
  backupURL: gs://${var.GCS_BUCKET_NAME_MYSQL_BACKUP}/
  volumeSpec:
    persistentVolumeClaim:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 5Gi
  YAML
}





