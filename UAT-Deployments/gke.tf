# GKE cluster (generated, edit values here)
module "gke" {
  source           = "git::https://github.com/your-don-now/infra.git//Modules/gke?ref=v1.0.0"

  project_id       = "acme-test-uat"
  region           = "asia-south1"
  cluster_name     = "uat-gke-test-cluster"
  network          = "default"
  subnetwork       = "default"
  machine_type     = "e2-standard-4"
  node_count       = 2
}
