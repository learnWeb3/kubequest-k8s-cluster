variable "DB_USERNAME" {
  description = "Mysql username"
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

variable GCS_BUCKET_NAME_MYSQL_BACKUP {
  description = "Google project bucket name for Mysql backup"
  type        = string
  sensitive   = true
}

variable GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP {
  description = "Google project service account json key for Mysql backup"
  type        = string
  sensitive   = true
}

variable GCS_PROJECT_ID_MYSQL_BACKUP {
  description = "Google project id for Mysql backup"
  type        = string
  sensitive   = true
}