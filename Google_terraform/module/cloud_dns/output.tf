output "zone_name" {
  description = "The name of the created DNS zone"
  value       = google_dns_managed_zone.zone.name
}

output "zone_id" {
  description = "The ID of the created DNS zone"
  value       = google_dns_managed_zone.zone.id
}

output "name_servers" {
  description = "Assigned name servers (for public zones)"
  value       = google_dns_managed_zone.zone.name_servers
}