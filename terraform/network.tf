resource "google_compute_network" "k8s" {
  name = "${var.project}-network"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "k8s" {
  name = "${var.project}-subnetwork"

  ip_cidr_range = "10.0.0.0/16"
  region        = var.region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  network = google_compute_network.k8s.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_compute_address" "control-plane" {
  count = var.cluster_type == "instances" ? var.control_plane_hosts : 0
  name  = "${var.project}-control-plane-${count.index + 1}"
}

resource "google_compute_address" "worker" {
  count = var.cluster_type == "instances" ? var.worker_hosts : 0
  name  = "${var.project}-worker-${count.index + 1}"
}


resource "google_compute_firewall" "internal_ports" {
  count       = var.cluster_type == "instances" ? 1 : 0
  name        = "allow-internal-ports"
  network     = google_compute_network.k8s.name
  target_tags = ["allow-internal-ports"]
  source_ranges = [
    "10.0.0.0/16",
    "192.168.0.0/24",
    "192.168.1.0/24"
  ]

  // TCP
  allow {
    protocol = "tcp"
  }

  // UDP
  allow {
    protocol = "udp"
  }
}

resource "google_compute_firewall" "external_ports" {
  count         = var.cluster_type == "instances" ? 1 : 0
  name          = "allow-external-ports"
  network       = google_compute_network.k8s.name
  target_tags   = ["allow-external-ports"]
  source_ranges = ["0.0.0.0/0"]

  // ICMP
  allow {
    protocol = "icmp"
  }


  // SSH
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
