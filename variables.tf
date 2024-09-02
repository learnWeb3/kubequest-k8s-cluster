# configs

variable "K8S_TOKEN" {
  description = "Kubernetes token for terreform user (base64)"
  type        = string
  sensitive   = true
}

variable "K8S_CACERT" {
  description = "Root ca certificate for kubernetes cluster access (base64)"
  type        = string
  sensitive   = true
}

variable "K8S_HOST" {
  description = "Host for kubernetes cluster access (base64)"
  type        = string
  sensitive   = true
}

variable "PROMETHEUS_GRAFANA_ADMIN_PASSWORD" {
  description = "Prometheus admin password"
  type        = string
  sensitive   = true
}

variable "APP_KEY" {
  description = "App key"
  type        = string
  sensitive   = true
}

variable "DB_PASSWORD" {
  description = "Mysql password"
  type        = string
  sensitive   = true
}

variable "DB_ROOT_PASSWORD" {
  description = "Mysql root password"
  type        = string
  sensitive   = true
}

variable "DB_USERNAME" {
  description = "Mysql username"
  type        = string
  sensitive   = true
}

variable "GCS_BUCKET_NAME_MYSQL_BACKUP" {
  description = "Google project bucket name for Mysql backup"
  type        = string
  sensitive   = true
}

variable "GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP" {
  description = "Google project service account json key for Mysql backup"
  type        = string
  sensitive   = true
}

variable "GCS_PROJECT_ID_MYSQL_BACKUP" {
  description = "Google project id for Mysql backup"
  type        = string
  sensitive   = true
}

variable "ALERT_MANAGER_MAIL_PASSWORD" {
  description = "Alert manager email account password"
  type        = string
  sensitive   = true
}

variable "ALERT_MANAGER_MAIL_USERNAME" {
  description = "Alert manager email account username"
  type        = string
  sensitive   = true
}

variable "KEYCLOAK_PG_ROOT_PASSWORD" {
  description = "keycloak postgres database root password (postgres)"
  type        = string
  sensitive   = true
}

variable "KEYCLOAK_PG_USER_PASSWORD" {
  description = "keycloak postgres database user password"
  type        = string
  sensitive   = true
}

variable "KEYCLOAK_PG_REPLICATION_PASSWORD" {
  description = "keycloak postgres database replication password"
  type        = string
  sensitive   = true
}

variable "KEYCLOAK_UI_ADMIN_PASSWORD" {
  description = "keycloak ui admin password"
  type        = string
  sensitive   = true
}

variable "MS_TEAMS_WEBHOOK_URL" {
  description = "microsoft teams webhook url"
}