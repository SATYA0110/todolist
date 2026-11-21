variable "project_id" {
  description = "GCP Project ID where the GKE cluster will be provisioned"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region for the regional GKE cluster"
  type        = string
}

variable "network" {
  description = "VPC network name or self-link"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self-link for GKE nodes"
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Name of the secondary IP range in the subnetwork for Pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "Name of the secondary IP range in the subnetwork for Services"
  type        = string
}

variable "release_channel" {
  description = "GKE release channel (RAPID, REGULAR, STABLE, or UNSPECIFIED)"
  type        = string
  default     = "REGULAR"
}

variable "enable_private_nodes" {
  description = "Restrict worker nodes to internal IP addresses only"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Restrict control plane access to internal IP only"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "RFC1918 /28 CIDR block for the GKE control plane VPC peering"
  type        = string
  default     = "172.16.0.0/28"
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks permitted to reach the Kubernetes API endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "node_pools" {
  description = "Map of custom node pools to attach to the GKE cluster"
  type = map(object({
    machine_type    = string
    min_count       = number
    max_count       = number
    disk_size_gb    = optional(number, 100)
    disk_type       = optional(string, "pd-balanced")
    spot            = optional(bool, false)
    image_type      = optional(string, "COS_CONTAINERD")
    service_account = optional(string, null)
    tags            = optional(list(string), [])
    labels          = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    auto_repair     = optional(bool, true)
    auto_upgrade    = optional(bool, true)
    max_surge       = optional(number, 1)
    max_unavailable = optional(number, 0)
  }))
}

variable "deletion_protection" {
  description = "Prevent accidental cluster deletion via Terraform"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Resource labels applied to the GKE cluster"
  type        = map(string)
  default     = {}
}
