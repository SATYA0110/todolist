variable "project_id" {
  description = "project_id of gcp"
  type        = string
}

variable "region" {
  description = "region of resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone for Production VM"
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  description = "Name of the production VPC"
  type        = string
}

variable "subnetwork" {
  description = "Name of the production subnet"
  type        = string
  default     = "my_subnet"
}

variable "subnet_cidr" {
  description = "IP CIDR range for production subnet"
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type for production"
  type        = string
}

variable "machine_name" {
  description = "Name of the production VM instance"
  type        = string
}

variable "firewall_rules" {
  description = "Map of firewall rules for the production VPC"
  type        = any
  default     = {}
}
