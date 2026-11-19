variable "project_id" {
  description = "The GCP project ID where the subnets will be created."
  type        = string
}

variable "region" {
  description = "The GCP region where the subnets will be created."
  type        = string
}

variable "network_id" {
  description = "The name or self_link of the VPC network to attach the subnets to."
  type        = string
}

variable "subnets" {
  description = "Map of subnet configurations keyed by subnet name."
  type = map(object({
    ip_cidr_range            = string
    private_ip_google_access = optional(bool, true)
    purpose                  = optional(string, "PRIVATE")
    role                     = optional(string, null)
    secondary_ranges         = optional(map(string), {})
  }))
}
