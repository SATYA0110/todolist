variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "zone_name" {
  description = "The unique name for the managed DNS zone"
  type        = string
}

variable "dns_name" {
  description = "The DNS domain name (must end with a period, e.g., example.com.)"
  type        = string
}

variable "visibility" {
  description = "Zone visibility: 'public' or 'private'"
  type        = string
  default     = "private"
}

variable "vpc_self_links" {
  description = "List of VPC self_links allowed to query this private zone"
  type        = list(string)
  default     = []
}

variable "records" {
  description = "List of DNS records to create inside the zone"
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    rrdatas = list(string)
  }))
  default = []
}
