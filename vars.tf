variable "bucket_location" {
  default = "US"
}

variable "loki_helm_chart_version" {
  type    = string
}

variable "grafan_helm_chart_version" {
  type    = string
}

variable "temp_helm_chart_version" {
  type    = string
}

variable "memir_helm_chart_version" {
  type    = string
}

variable "cert_manager_cluster_issuer" {
  type    = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "db_username" {
  type = string
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "oauth_client_id" {
  type = string
  sensitive = true
}

variable "oauth_client_secret" {
  type = string
  sensitive = true
}