variable "MQTT_AUTH_PASSWORD" {
  description = "MQTT api user password"
  type        = string
  sensitive   = true
}

variable "KAFKA_SASL_PASSWORD" {
  description = "Device metrics kakfa user"
  type        = string
  sensitive   = true
}

variable "KAFKA_ECOMMERCE_SASL_PASSWORD" {
  description = "Ecommerce kafka user password"
  type        = string
  sensitive   = true
}

variable "GOOGLE_STORAGE_PRIVATE_KEY" {
  description = "Google storage private key for file object storage"
  type        = string
  sensitive   = true
}

variable "KEYCLOAK_ADMIN_CLIENT_SECRET" {
  description = "Kecyloak admin client secret to perform operations such as registering new device clients"
  type        = string
  sensitive   = true
}

variable "OPENSEARCH_URL" {
  description = "opensearch url"
  type        = string
  sensitive   = true
}

variable "MONGO_URI" {
  description = "Mongo uri connection string"
  type        = string
  sensitive   = true
}