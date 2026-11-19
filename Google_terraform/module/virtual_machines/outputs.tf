output "instance_id" {
  description = "The server-defined unique numeric ID of the Spot VM."
  value       = google_compute_instance.spot_vm.instance_id
}

output "self_link" {
  description = "The URI of the created Spot VM resource."
  value       = google_compute_instance.spot_vm.self_link
}

output "name" {
  description = "The name of the Spot VM instance."
  value       = google_compute_instance.spot_vm.name
}

output "internal_ip" {
  description = "The internal IP address assigned to the primary network interface."
  value       = google_compute_instance.spot_vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "The ephemeral external IP address if assign_public_ip is enabled."
  value       = try(google_compute_instance.spot_vm.network_interface[0].access_config[0].nat_ip, null)
}
