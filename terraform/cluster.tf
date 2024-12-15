resource "google_container_cluster" "k8s" {
  name = "${var.project}-autopilot-cluster"

  count = var.cluster_type == "autopilot" ? 1 : 0

  location                 = var.region
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true

  network    = google_compute_network.k8s.id
  subnetwork = google_compute_subnetwork.k8s.id

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.k8s.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.k8s.secondary_ip_range[1].range_name
  }

  deletion_protection = false
}
