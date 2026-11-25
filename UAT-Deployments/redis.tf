# Memorystore Redis (generated, edit values here)
module "redis" {
  source           = "git::https://github.com/your-don-now/infra.git//Modules/redis?ref=v1.0.0"

  project_id       = "acme-test-uat"
  region           = "asia-south1"
  name             = "uat-redis"
  memory_size_gb   = 1
  tier             = "BASIC"
}
