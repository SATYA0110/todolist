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
}