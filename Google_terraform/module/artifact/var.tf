variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "location" {
  description = "GCP region for Artifact Registry (e.g., us-central1)"
  type        = string
}

variable "repository_id" {
  description = "Name of the Artifact Registry repository"
  type        = string
}


variable "format" {
  description = "Repository format (DOCKER, HELM, PYTHON, NPM, etc.)"
  type        = string
  default     = "DOCKER"
}

variable "immutable_tags" {
  description = "Prevent overwriting existing image tags"
  type        = bool
  default     = false
}

variable "untagged_retention_seconds" {
  description = "Delete untagged images older than this duration (default 7 days)"
  type        = string
  default     = "604800s"
}

variable "keep_recent_versions" {
  description = "Number of most recent image versions to always retain"
  type        = number
  default     = 10
}

variable "reader_service_accounts" {
  description = "List of GCP service account emails allowed to pull images (e.g., GKE node SA)"
  type        = list(string)
  default     = []
}


variable "labels" {
  description = "Resource labels applied to the repository"
  type        = map(string)
  default     = {}
}