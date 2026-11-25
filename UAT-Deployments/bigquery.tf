# BigQuery (generated, edit values here)
module "bigquery" {
  source           = "git::https://github.com/your-don-now/infra.git//Modules/bigquery?ref=v1.0.0"

  project_id       = "acme-test-uat"
  region           = "asia-south1"
  dataset_id       = "uat_analytics"
  location         = "asia-south1"
}
