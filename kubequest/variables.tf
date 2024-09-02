variable "APP_KEY" {
  description = "App key"
  type        = string
  sensitive   = true
}

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