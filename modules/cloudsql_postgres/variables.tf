variable "name" {}
variable "project" {}
variable "database_version" {}
variable "region" {}
variable "encryption_key_name" {}

variable "deletion_protection_enabled" { default = true }
variable "deletion_protection" { default = true }

variable "user_labels" {
  type = map(string)
}

variable "maintenance_day" {}
variable "maintenance_hour" {}

variable "tier" {}
variable "edition" {
  type        = string
  description = "Cloud SQL edition"
  default     = "ENTERPRISE"
}

variable "ipv4_enabled" {}
variable "private_network" {}
variable "ssl_mode" {}

variable "auth_network_name" {}
variable "auth_network_value" {}

variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "backup_enabled" {}
variable "backup_start_time" {}
variable "backup_location" {}
variable "pitr_enabled" {}
variable "txn_log_retention_days" {}
variable "retained_backups" {}
variable "retention_unit" {}

variable "db_users" {
  description = "Database usernames"
  type        = set(string)
  default     = []
}