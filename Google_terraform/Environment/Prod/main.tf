module "vpc" {
    source = "../../module/VPC"
    project_id = var.project_id
    vpc_name = var.vpc_name


}

module "subnet" {
    source = "../../module/subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr =  var.subnet_cidrs
}

module "firewall" {
  source     = "../../module/firewall"
  project_id = var.project_id
  network    = module.vpc.vpc_name
  rules      = var.firewall_rules
}


module "virtual_machines" {
    source = "../../module/virtual_machines"
    subnetwork     = module.subnet.subnet_ids[0]
    firewall_id   = module.firewall.firewall_id
    machine_type = var.instance_type
    project_id = var.project_id
    instance_name = var.instance_name
    zone = var.zone
}