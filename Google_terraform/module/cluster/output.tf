output "cluster_id" {
  description = "The unique ID of the GKE cluster"
  value       = google_container_cluster.gke.id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "endpoint" {
  description = "The IP address of the Kubernetes control plane"
  value       = google_container_cluster.gke.endpoint
  sensitive   = true
}


output "node_pool_names" {
  description = "List of managed node pool names"
  value       = keys(google_container_node_pool.pools)
}