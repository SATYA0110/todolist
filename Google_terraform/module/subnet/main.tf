resource "google_compute_subnetwork" "subnet" {
    for_each = var.subnets

    name = each.key
    project = var.project_id
    region = var.region
    ip_cidr_range = each.value.ip_cidr_range

    network = var.network_id

    private_ip_google_access = each.value.private_ip_google_access

    prupose = each.value.prupose
    role = each.value.role

    dynamic "secondary_ip_range" {
        for_each = each.value.secondary_ranges

        content {
            range_name = secondary_ip_range.key
            ip_cidr_range = secondary_ip_range.value
        }
    }

    log_config {
        aggregation_interval = "INTERVAL_5_SEC"
        flow_sampling = 0.5
        metadata = "INCLUDE_ALL_METADATA"
    }
}