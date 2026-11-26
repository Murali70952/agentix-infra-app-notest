# Memorystore Redis
module "redis" {
  source = "../modules/redis"

  name                    = "uat-redis"
  project                 = "sakmdcsfkdj"
  region                  = "asia-south1"
  tier                    = "STANDARD_HA"
  memory_size_gb          = 1
  redis_version           = "REDIS_7_0"
  authorized_network      = "sacdsvcsv"
  read_replicas_mode      = "READ_REPLICAS_DISABLED"
  replica_count           = 0
  connect_mode            = "PRIVATE_SERVICE_ACCESS"
  customer_managed_key    = "sasdfcs"
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  auth_enabled            = true
  labels                  = {
    env = "uat"
  }
  maintenance_day         = "SUNDAY"
  maintenance_hour        = 2
  maintenance_min         = 0
}
