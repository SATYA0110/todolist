output "repository_id" {
  description = "The ID of the Artifact Registry repository"
  value       = google_artifact_registry_repository.repo.repository_id
}

output "repository_url" {
  description = "Full Docker registry URL for pushing and pulling images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}"
}
