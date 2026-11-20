resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = var.virtual_machines
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.tags
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  scheduling {
    preemptible                 = false
    automatic_restart           = true
    provisioning_model          = "STANDARD"
    
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {}
    }
  }

  metadata                = var.metadata
  metadata_startup_script = var.startup_script

  dynamic "service_account" {
    for_each = var.service_account_email != null ? [1] : []
    content {
      email  = var.service_account_email
      scopes = var.service_account_scopes
    }
  }

  allow_stopping_for_update = true
}
