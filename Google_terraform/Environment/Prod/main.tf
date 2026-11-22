module "vpc" {
  source     = "../../module/VPC"
  project_id = var.project_id
  vpc_name   = var.vpc_name
}

module "subnet" {
  source     = "../../module/subnet"
  project_id = var.project_id
  region     = var.region
  network_id = module.vpc.vpc_id

  subnets = {
    (var.subnetwork) = {
      ip_cidr_range            = var.subnet_cidr
      private_ip_google_access = true
      secondary_ranges = {
        "gke-pods"     = "10.20.0.0/16" # Must match var.pods_secondary_range_name in module.gke
        "gke-services" = "10.30.0.0/20" # Must match var.services_secondary_range_name in module.gke
      }
    }
  }
}

module "firewall" {
  source     = "../../module/firewall"
  project_id = var.project_id
  network    = module.vpc.vpc_name
  rules      = var.firewall_rules
}

module "virtual_machines" {
  source           = "../../module/virtual_machines"
  project_id       = var.project_id
  virtual_machines = var.machine_name
  machine_type     = var.machine_type
  zone             = var.zone
  network          = module.vpc.vpc_id
  subnetwork       = module.subnet.subnet_ids[var.subnetwork]
}

module "nat" {
  source           = "../../module/nat" 
  router_name      = "prod-nat-router"
  nat_name         = "prod-nat-gateway"
  region           = var.region
  network_id       = module.vpc.vpc_id
  project_id       = var.project_id
}


module "gke" {
  source = "../../module/cluster"

  project_id   = var.project_id
  cluster_name = "prod-gke-cluster"
  region       = var.region

  network                       = module.vpc.vpc_id
  subnetwork                    = module.subnet.subnet_ids[var.subnetwork]
  pods_secondary_range_name     = "gke-pods"
  services_secondary_range_name = "gke-services"

  enable_private_nodes    = true
  enable_private_endpoint = false
  master_ipv4_cidr_block  = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "203.0.113.10/32"
      display_name = "Jenkins CI/CD Server"
    }
  ]

  node_pools = {
    general-pool = {
      machine_type    = "e2-standard-4"
      min_count       = 1
      max_count       = 3
      disk_size_gb    = 100
      spot            = false
      service_account = "544097438669-compute@developer.gserviceaccount.com"
      tags            = ["gke-node", "prod"]
      labels = {
        workload = "general"
      }
    }
    spot-pool = {
      machine_type    = "e2-standard-4"
      min_count       = 0
      max_count       = 5
      disk_size_gb    = 100
      spot            = true
      service_account = "544097438669-compute@developer.gserviceaccount.com"
      tags            = ["gke-node", "spot"]
      labels = {
        workload = "stateless"
      }
      taints = [
        {
          key    = "://google.com"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }

  labels = {
    environment = "prod"
    managed_by  = "terraform"
  }
}


module "cloud_dns" {
  source = "../../module/cloud-dns"

  project_id = var.project_id
  zone_name  = "prod-private-zone"
  dns_name   = "prod.internal."
  visibility = "private"

  # Reference the network output from your VPC module
  vpc_self_links = [
    module.vpc.network_self_link
  ]

  # Example records pointing to your VM internal IP and a CNAME
  records = [
    {
      name    = "app"
      type    = "A"
      ttl     = 300
      rrdatas = [module.vm.internal_ip]
    },
    {
      name    = "api"
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["app.prod.internal."]
    },
    {
      name    = "" # Apex record (prod.internal.)
      type    = "TXT"
      ttl     = 300
      rrdatas = ["\"v=spf1 -all\""]
    }
  ]
}

