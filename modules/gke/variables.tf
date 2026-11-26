variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "kms_key" {
  type = string
}

variable "workload_pool" {
  type = string
}

variable "cluster_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}

variable "private_endpoint_subnetwork" {
  type = string
}

variable "labels" {
  type = map(string)
}

# BQ Dataset

variable "resource_usage_dataset_id" {
  type    = string
  default = null
}
# Node Pools

variable "node_pools" {
  type = map(any)
}