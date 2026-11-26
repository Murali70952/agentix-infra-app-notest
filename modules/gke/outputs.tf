output "cluster_name" {
  value = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "cluster_id" {
  value = google_container_cluster.cluster.id
}

output "node_pools" {
  value = keys(var.node_pools)
}
