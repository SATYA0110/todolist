resource "google_project_service" "artifact_registry" {
    project               = var.project_id
    service               = "artifactregistry.googleapis.com"
    disable_on_destroy    = false

}

resource "google_artifact_registry_repository" "repo" {
    project               = var.project_id
    location              = var.location
    repository_id         = var.repository_id
    description           = "docker image repo"
    format                = var.format
    labels                = var.labels


docker_config {
    immutable_tags        = var.immutable_tags
}

cleanup_policy_dry_run = false

  cleanup_policies {
    id     = "delete-untagged-images"
    action = "DELETE"
    condition {
      tag_state  = "UNTAGGED"
      older_than = var.untagged_retention_seconds
    }
  }

  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = var.keep_recent_versions
    }
  }

  depends_on = [google_project_service.artifact_registry]
}

# Grant GKE Node Service Accounts permission to pull images
resource "google_artifact_registry_repository_iam_member" "readers" {
  for_each = toset(var.reader_service_accounts)

  project    = var.project_id
  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${each.value}"
}