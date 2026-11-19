project_id            = "project-46ccb90c-64b1-4c46-8d9"
region                = "us-central1"
zone                  = "us-central1-a"

vpc_name              = "prod-vpc"

subnet_cidr           = "10.10.0.0/24"
machine_type          = "e2-standard-4"
machine_name          = "prod"

firewall_rules = {
  "prod-allow-iap-ssh" = {
    description   = "Allow SSH access strictly via GCP Identity-Aware Proxy"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["35.235.240.0/20"]
    target_tags   = ["prod-vm"]
    allow = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }

  "prod-allow-internal" = {
    description   = "Allow internal communication within prod subnet"
    direction     = "INGRESS"
    priority      = 1000
    source_ranges = ["10.10.0.0/24"]
    allow = [
      {
        protocol = "tcp"
        ports    = ["80", "443"]
      },
      {
        protocol = "icmp"
      }
    ]
  }
}
