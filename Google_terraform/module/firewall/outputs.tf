output "firewall_rules" {
  description = "Map of created GCP firewall rule objects."
  value       = google_compute_firewall.dynamic_rules
}

output "firewall_rule_ids" {
  description = "Map of firewall rule names to their GCP resource IDs."
  value       = { for k, v in google_compute_firewall.dynamic_rules : k => v.id }
}

output "firewall_rule_self_links" {
  description = "Map of firewall rule names to their GCP self_links."
  value       = { for k, v in google_compute_firewall.dynamic_rules : k => v.self_link }
}
