resource "google_redis_instance" "redis" {
  name                    = var.name
  project                 = var.project
  tier                    = var.tier
  memory_size_gb          = var.memory_size_gb
  region                  = var.region
  redis_version           = var.redis_version
  authorized_network      = var.authorized_network
  read_replicas_mode      = var.read_replicas_mode
  replica_count           = var.replica_count
  connect_mode            = var.connect_mode
  customer_managed_key    = var.customer_managed_key
  transit_encryption_mode = var.transit_encryption_mode
  auth_enabled            = var.auth_enabled
  labels                  = var.labels

  maintenance_policy {
    weekly_maintenance_window {
      day = var.maintenance_day

      start_time {
        hours   = var.maintenance_hour
        minutes = var.maintenance_min
        seconds = 0
        nanos   = 0
      }
    }
  }
}

resource "google_secret_manager_secret" "redis_auth" {
  count = var.auth_enabled ? 1 : 0

  project   = var.project
  secret_id = "${var.name}-auth"

  replication {
    user_managed {
      replicas {
        location = "asia-south1"
      }
      replicas {
        location = "asia-south2"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "redis_auth" {
  count = var.auth_enabled ? 1 : 0

  secret      = google_secret_manager_secret.redis_auth[0].id
  secret_data = google_redis_instance.redis.auth_string
}