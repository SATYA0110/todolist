resource "google_container_cluster" "gke" {
    name                          = var.cluster_name
    location                      = var. region
    project                       = var.project_id
    remove_default_node_pool      = false
    network                       = var.network
    subnetwork                    = var.subnetwork
    deletion_protection           = var.deletion_protection
    release_channel {
    channel = var.release_channel
    }

    ip_allocation_policy {
        cluster_secondary_range_name  = var.pods_secondary_range_name
        services_secondary_range_name = var.services_secondary_range_name
    }
    

    private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }

    dynamic "master_authorized_networks_config" {
    for_each = length(var.master_authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.master_authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }


  # Workload Identity (binds Kubernetes Service Accounts to GCP IAM Service Accounts)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Enable Shielded GKE Nodes
  enable_shielded_nodes = true

  # Enable Dataplane V2 (eBPF-based networking & native NetworkPolicy enforcement)
  datapath_provider = "ADVANCED_DATAPATH"

  # Cloud Logging & Managed Prometheus Monitoring
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  # Daily maintenance window (02:00 UTC)
  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_config,
    ]
  }
}

resource "google_container_node_pool" "pools" {
  for_each = var.node_pools

  name     = each.key
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.gke.name

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  upgrade_settings {
    max_surge       = each.value.max_surge
    max_unavailable = each.value.max_unavailable
  }

  node_config {
    machine_type    = each.value.machine_type
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    spot            = each.value.spot
    image_type      = each.value.image_type
    service_account = each.value.service_account
    tags            = each.value.tags
    labels          = each.value.labels

    dynamic "taint" {
      for_each = each.value.taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    # Required for Workload Identity on worker nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    oauth_scopes = [
      "https://googleapis.com"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}