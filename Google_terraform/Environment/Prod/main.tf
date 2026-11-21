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
      ip_cidr_range = var.subnet_cidr
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
  subnetwork                    = module.subnet.id
  pods_secondary_range_name     = "gke-pods-range"
  services_secondary_range_name = "gke-services-range"

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
      service_account = module.iam_service_account.email
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
      service_account = module.iam_service_account.email
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
