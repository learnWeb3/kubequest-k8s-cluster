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
