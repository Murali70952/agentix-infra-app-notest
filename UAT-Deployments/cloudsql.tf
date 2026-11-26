# Cloud SQL Postgres
module "cloudsql" {
  source = "../modules/cloudsql_postgres"

  name                        = "uat-postgres"
  project                     = "sakmdcsfkdj"
  region                      = "asia-south1"
  database_version            = "POSTGRES_15"
  encryption_key_name         = "sfdsvdf"
  deletion_protection_enabled = true
  deletion_protection         = true
  user_labels                 = {
    env = "uat"
  }
  maintenance_day             = 7
  maintenance_hour            = 2
  tier                        = "db-custom-2-7680"
  edition                     = "ENTERPRISE"
  ipv4_enabled                = false
  private_network             = "sdcsdss"
  ssl_mode                    = "ENCRYPTED_ONLY"
  auth_network_name           = "0.0.0.0/0"
  auth_network_value          = "10.0.0.0/8"
  database_flags              = []
  backup_enabled              = true
  backup_start_time           = "02:00"
  backup_location             = "asia"
  pitr_enabled                = true
  txn_log_retention_days      = 7
  retained_backups            = 7
  retention_unit              = "COUNT"
  db_users                    = []
}
