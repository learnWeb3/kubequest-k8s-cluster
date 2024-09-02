
module "metrics" {
  source                            = "./metrics"
  PROMETHEUS_GRAFANA_ADMIN_PASSWORD = var.PROMETHEUS_GRAFANA_ADMIN_PASSWORD
  ALERT_MANAGER_MAIL_PASSWORD       = var.ALERT_MANAGER_MAIL_PASSWORD
  ALERT_MANAGER_MAIL_USERNAME       = var.ALERT_MANAGER_MAIL_USERNAME
  MS_TEAMS_WEBHOOK_URL              = var.MS_TEAMS_WEBHOOK_URL
}

module "commons" {
  depends_on = [module.metrics]
  source     = "./commons"
}

module "oidc" {
  depends_on                       = [module.commons]
  source                           = "./oidc"
  KEYCLOAK_PG_REPLICATION_PASSWORD = var.KEYCLOAK_PG_REPLICATION_PASSWORD
  KEYCLOAK_PG_ROOT_PASSWORD        = var.KEYCLOAK_PG_ROOT_PASSWORD
  KEYCLOAK_PG_USER_PASSWORD        = var.KEYCLOAK_PG_USER_PASSWORD
  KEYCLOAK_UI_ADMIN_PASSWORD       = var.KEYCLOAK_UI_ADMIN_PASSWORD
}

module "gke_identity_service" {
  depends_on = [module.oidc]
  source     = "./gke-identity-service"
}


module "mysql" {
  depends_on                                = [module.commons]
  source                                    = "./mysql"
  DB_PASSWORD                               = var.DB_PASSWORD
  DB_ROOT_PASSWORD                          = var.DB_ROOT_PASSWORD
  DB_USERNAME                               = var.DB_USERNAME
  GCS_BUCKET_NAME_MYSQL_BACKUP              = var.GCS_BUCKET_NAME_MYSQL_BACKUP
  GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP = var.GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP
  GCS_PROJECT_ID_MYSQL_BACKUP               = var.GCS_PROJECT_ID_MYSQL_BACKUP

}

module "kubequest" {
  depends_on = [module.mysql]
  source     = "./kubequest"

  APP_KEY     = var.APP_KEY
  DB_USERNAME = var.DB_USERNAME
  DB_PASSWORD = var.DB_PASSWORD
}

module "rbac" {
  depends_on = [module.kubequest]
  source     = "./rbac"
}


