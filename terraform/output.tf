output "control_plane_ips" {
  value = google_compute_address.control-plane.*.address
}

output "worker_ips" {
  value = google_compute_address.worker.*.address
}

output "cluster_endpoint" {
  value = google_container_cluster.k8s.*.endpoint
}

output "ssh_access" {
  value = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${var.ssh_public_key}"
}
