variable "name"  { type = string }
variable "project"  { type = string }
variable "tier"  { type = string }
variable "memory_size_gb"  { type = number }
variable "region"  { type = string }
variable "redis_version"  { type = string }
variable "authorized_network"  { type = string }
variable "read_replicas_mode"  { type = string }
variable "replica_count"  { type = number }
variable "connect_mode"  { type = string }
variable "customer_managed_key"  { type = string }
variable "transit_encryption_mode"  { type = string }
variable "auth_enabled"  { type = bool }

variable "labels"  { type = map(string) }

variable "maintenance_day"  { type = string }
variable "maintenance_hour"  { type = number }
variable "maintenance_min"  { type = number }
