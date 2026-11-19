variable "project_id" {
  description = "The GCP project ID where the firewall rules will be created."
  type        = string
}

variable "network" {
  description = "The name or self_link of the VPC network to attach the firewall rules to."
  type        = string
}

variable "rules" {
  description = "Map of firewall rules to create dynamically."
  type = map(object({
    description             = optional(string, "Managed by Terraform")
    direction               = optional(string, "INGRESS") # INGRESS or EGRESS
    priority                = optional(number, 1000)
    disabled                = optional(bool, false)
    source_ranges           = optional(list(string), [])
    destination_ranges      = optional(list(string), [])
    source_tags             = optional(list(string), [])
    target_tags             = optional(list(string), [])
    source_service_accounts = optional(list(string), [])
    target_service_accounts = optional(list(string), [])

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])

    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])

    log_config = optional(object({
      metadata = string # INCLUDE_ALL_METADATA or EXCLUDE_ALL_METADATA
    }), null)
  }))
  default = {}
}
