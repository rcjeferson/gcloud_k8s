data "google_client_openid_userinfo" "me" {}

data "google_compute_image" "ubuntu" {
  project = "ubuntu-os-cloud"
  family  = "ubuntu-minimal-2410-amd64"
}

// Control Planes
resource "google_compute_instance" "control-plane" {
  count = var.cluster_type == "instances" ? var.control_plane_hosts : 0

  name         = "${var.project}-control-plane-${count.index + 1}"
  machine_type = var.instances_machine_type
  zone         = var.zone

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s.self_link
    access_config {
      nat_ip = google_compute_address.control-plane[count.index].address
    }
  }

  metadata = {
    ssh-keys  = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${var.ssh_public_key}"
    user-data = file("${path.module}/cloud-config.yaml")
  }
}

// Workers
resource "google_compute_instance" "worker" {
  count = var.cluster_type == "instances" ? var.worker_hosts : 0

  name         = "${var.project}-workers-${count.index + 1}"
  machine_type = var.instances_machine_type
  zone         = var.zone

  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s.self_link
    access_config {
      nat_ip = google_compute_address.worker[count.index].address
    }
  }

  metadata = {
    ssh-keys  = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${var.ssh_public_key}"
    user-data = file("${path.module}/cloud-config.yaml")
  }
}
