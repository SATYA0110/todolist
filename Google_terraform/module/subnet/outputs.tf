output "subnets" {
    description = "All created subnetwork resource objects."
    value = google_compute_subnetwork.subnet
}

output "subnet_ids" {
    description = "Map of subnet names to their resource IDs." 
    value = {
    for k, s in google_compute_subnetwork.subnet : k => s.id
  }
}



output "subnet_ip_cidr_ranges" {
  description = "Map of subnet names to their primary IP CIDR ranges."
  value = {
    for k, s in google_compute_subnetwork.subnet : k => s.ip_cidr_range
  }
}