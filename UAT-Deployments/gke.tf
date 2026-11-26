# GKE cluster
module "gke" {
  source = "../modules/gke"

  name                          = "uat-gke"
  project                       = "sakmdcsfkdj"
  location                      = "asia-south1"
  network                       = "sefsfes"
  subnetwork                    = "sdfsf"
  kms_key                       = "sdfsf"
  workload_pool                 = "sdfjndksv.svc.id.goog"
  cluster_secondary_range_name  = "dsfsdf"
  services_secondary_range_name = "dsfsdf"
  private_endpoint_subnetwork   = "sdfsf"
  labels                        = {
    env = "uat"
  }
  resource_usage_dataset_id     = "bigdatasrajan"
  node_pools                    = {
    primary = {
      machine_type = "e2-standard-4"
      min_node_count = 1
      max_node_count = 3
      max_pods_per_node = 32
      service_account = null
      tags = ["gke-node"]
      labels = {
        env = "uat"
      }
      resource_labels = {}
    }
  }
}
