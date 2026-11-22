output "vpc_id" {
    value = google_compute_network.vpc.id
}

output "vpc_name" {
    value = google_compute_network.vpc.name
}

output "vpc_self_links" {
  value = [
    google_compute_network.vpc.self_link
  ]
}


