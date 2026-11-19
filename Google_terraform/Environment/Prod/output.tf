output "prod_vpc_id" {
  description = "Production VPC ID"
  value       = module.vpc.vpc_id
}

output "prod_subnet_self_link" {
  description = "Production Subnet Self Link"
  value       = module.subnet.subnet_self_link
}

output "prod_vm_internal_ip" {
  description = "Internal IP of the Production VM"
  value       = module.vm.internal_ip
}
