variable "project_id" {
  description = "The GCP project ID where the Spot VM will be created."
  type        = string
}

variable "instance_name" {
  description = "The name of the Spot VM instance."
  type        = string
}

variable "zone" {
  description = "The GCP zone for the Spot VM (e.g., us-central1-a)."
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "The Compute Engine machine type."
  type        = string
  default     = "e2-medium"
}

variable "boot_image" {
  description = "The OS image used to initialize the boot disk."
  type        = string
  default     = "debian-cloud/debian-12"
}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB."
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "The disk type for the boot disk (e.g., pd-standard, pd-balanced, pd-ssd)."
  type        = string
  default     = "pd-balanced"
}

variable "instance_termination_action" {
  description = "Action GCP takes when preempting the Spot VM (STOP or DELETE)."
  type        = string
  default     = "STOP"

  validation {
    condition     = contains(["STOP", "DELETE"], var.instance_termination_action)
    error_message = "Valid values for instance_termination_action are STOP or DELETE."
  }
}

variable "network" {
  description = "The VPC network name or self_link."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork name or self_link (required if using custom-mode VPC)."
  type        = string
  default     = null
}

variable "assign_public_ip" {
  description = "Whether to attach an ephemeral external IP address."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Network tags applied to the VM for firewall rules."
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Key-value labels applied to the VM."
  type        = map(string)
  default     = {}
}

variable "metadata" {
  description = "Key-value metadata pairs (e.g., ssh-keys)."
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Optional shell script executed when the instance boots."
  type        = string
  default     = null
}

variable "service_account_email" {
  description = "Custom service account email to attach to the VM."
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "OAuth scopes granted to the attached service account."
  type        = list(string)
  default     = ["https://googleapis.com"]
}
