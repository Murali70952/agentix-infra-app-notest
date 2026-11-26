# Cloud SQL Instance

resource "google_sql_database_instance" "agentix_postgres" {
  name                = var.name
  project             = var.project
  database_version    = var.database_version
  region              = var.region
  encryption_key_name = var.encryption_key_name

  settings {
    deletion_protection_enabled = var.deletion_protection_enabled
    user_labels                 = var.user_labels

    maintenance_window {
      day  = var.maintenance_day
      hour = var.maintenance_hour
    }

    tier = var.tier
    edition = var.edition

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network
      ssl_mode        = var.ssl_mode

      authorized_networks {
        name  = var.auth_network_name
        value = var.auth_network_value
      }
    }

    dynamic "database_flags" {
      for_each = var.database_flags

      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      location                       = var.backup_location
      point_in_time_recovery_enabled = var.pitr_enabled
      transaction_log_retention_days = var.txn_log_retention_days

      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = var.retention_unit
      }
    }
  }

  deletion_protection = var.deletion_protection

  lifecycle {
    prevent_destroy = false

    ignore_changes = [
      settings[0].tier,
      settings[0].backup_configuration,
      settings[0].enable_dataplex_integration,
      settings[0].retain_backups_on_delete,
      settings[0].user_labels,
      settings[0].ip_configuration[0].psc_config,
      settings[0].maintenance_window[0].day,
      settings[0].maintenance_window[0].update_track,
      settings[0].password_validation_policy,
    ]
  }
}

# Random Password Per User

resource "random_password" "db_passwords" {
  for_each = var.db_users

  length           = 24
  special          = true
  override_special = "!@#$%^&*()-_=+"
}

# Cloud SQL Users

resource "google_sql_user" "users" {
  for_each = var.db_users
  project = var.project
  name     = each.value
  instance = google_sql_database_instance.agentix_postgres.name
  password = random_password.db_passwords[each.value].result
}

# Secret Manager Secrets

resource "google_secret_manager_secret" "db_passwords" {
  for_each = var.db_users

  project   = var.project
  secret_id = "${each.value}-password"

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

resource "google_secret_manager_secret_version" "db_passwords" {
  for_each = var.db_users

  secret      = google_secret_manager_secret.db_passwords[each.value].id
  secret_data = random_password.db_passwords[each.value].result
}