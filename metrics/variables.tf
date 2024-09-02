variable "PROMETHEUS_GRAFANA_ADMIN_PASSWORD" {
  description = "Prometheus admin password"
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

variable "MS_TEAMS_WEBHOOK_URL" {
  description = "microsoft teams webhook url"
}
