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

output "ca_certificate" {
  description = "Base64-encoded public certificate of the cluster root of trust"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "location" {
  description = "The region where the cluster resides"
  value       = google_container_cluster.primary.location
}

output "node_pool_names" {
  description = "List of managed node pool names"
  value       = keys(google_container_node_pool.pools)
}