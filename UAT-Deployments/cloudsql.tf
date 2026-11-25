# Cloud SQL (generated, edit values here)
module "cloudsql" {
  source           = "git::https://github.com/your-don-now/infra.git//Modules/cloudsql?ref=v1.0.0"

  project_id       = "acme-test-uat"
  region           = "asia-south1"
  instance_name    = "uat-sql"
  database_version = "POSTGRES_15"
  tier             = "db-custom-2-7680"
  db_name          = "appdb"
}
