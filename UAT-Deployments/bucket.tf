# GCS bucket (generated, edit values here)
module "bucket" {
  source           = "git::https://github.com/your-don-now/infra.git//Modules/bucket?ref=v1.0.0"

  project_id       = "acme-test-uat"
  region           = "asia-south1"
  bucket_name      = "yuos-deksnj"
  location         = "ASIA-SOUTH1"
  storage_class    = "STANDARD"
  versioning       = true
}
