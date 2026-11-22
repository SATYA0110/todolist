

resource "google_dns_managed_zone" "zone" {
  project     = var.project_id
  name        = var.zone_name
  dns_name    = var.dns_name
  description = "Managed by Terraform"
  visibility  = var.visibility

  dynamic "private_visibility_config" {
    for_each = var.visibility == "private" ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.vpc_self_links
        content {
          network_url = networks.value
        }
      }
    }
  }
}

resource "google_dns_record_set" "records" {
  for_each = { for r in var.records : "${r.name}-${r.type}" => r }

  project      = var.project_id
  managed_zone = google_dns_managed_zone.zone.name
  name         = each.value.name == "" ? var.dns_name : "${each.value.name}.${var.dns_name}"
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas
}


