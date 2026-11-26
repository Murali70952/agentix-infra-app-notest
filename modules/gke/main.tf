# GKE CLUSTER

resource "google_container_cluster" "cluster" {

  name     = var.name
  location = var.location
  project  = var.project

  initial_node_count       = 1
  remove_default_node_pool = true

  deletion_protection = false

  networking_mode = "VPC_NATIVE"

  release_channel {
    channel = "STABLE"
  }

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  monitoring_config {

    managed_prometheus {
      enabled = true
    }

    enable_components = [
      "SYSTEM_COMPONENTS",
      "APISERVER",
      "SCHEDULER",
      "CONTROLLER_MANAGER",
      "POD",
      "DAEMONSET",
      "DEPLOYMENT",
      "STATEFULSET",
      "JOBSET",
      "STORAGE",
      "KUBELET",
      "CADVISOR",
      "HPA"
    ]
  }

  logging_config {

    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS"
    ]
  }

  private_cluster_config {

    enable_private_nodes    = true
    enable_private_endpoint = true

    private_endpoint_subnetwork = var.private_endpoint_subnetwork
  }

  network = var.network

  subnetwork = var.subnetwork

  ip_allocation_policy {

    cluster_secondary_range_name  = var.cluster_secondary_range_name

    services_secondary_range_name = var.services_secondary_range_name
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  service_external_ips_config {
    enabled = false
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_dataset_id != null ? [1] : []
    content {
      enable_network_egress_metering       = true
      enable_resource_consumption_metering = true
      bigquery_destination {
        dataset_id = var.resource_usage_dataset_id
      }
    }
   }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = var.kms_key
  }

  addons_config {

    horizontal_pod_autoscaling {
      disabled = false
    }

    http_load_balancing {
      disabled = false
    }

    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

    gcp_filestore_csi_driver_config {
      enabled = true
    }

    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }

  secret_manager_config {
    enabled = true
  }

  workload_identity_config {
    workload_pool = var.workload_pool
  }

  enable_shielded_nodes       = true
  enable_intranode_visibility = true

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
  }

  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }

  default_max_pods_per_node = 32
}

# NODE POOLS

resource "google_container_node_pool" "node_pools" {

  for_each = var.node_pools

  name     = each.key
  project  = var.project
  location = var.location

  cluster = google_container_cluster.cluster.name

  max_pods_per_node = each.value.max_pods_per_node

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {

    machine_type = each.value.machine_type

    service_account = each.value.service_account

    tags = each.value.tags

    labels = each.value.labels

    resource_labels = each.value.resource_labels

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    dynamic "taint" {

      for_each = lookup(each.value, "taints", [])

      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }

    boot_disk_kms_key = var.kms_key
  }

  lifecycle {

    ignore_changes = [
      node_count,
      version,
      node_locations,
      autoscaling
    ]
  }
}