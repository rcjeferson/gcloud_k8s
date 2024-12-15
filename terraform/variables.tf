variable "project" {
  description = "Terraform Project name"
  type        = string
  default     = "k8s"
}

variable "project_name" {
  description = "GCP Project name"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "us-west1-b"
}

variable "cluster_type" {
  description = "Configure cluster type (autopilot | instances)"
  type        = string
  default     = "autopilot"
}

variable "ssh_public_key" {
  description = "SSH Key that will be used on hosts"
  type        = string
}

variable "control_plane_hosts" {
  description = "Configure how many control plane instances will be created"
  type        = number
  default     = 1
}

variable "worker_hosts" {
  description = "Configure how many workers instances will be created"
  type        = number
  default     = 2
}

variable "instances_machine_type" {
  description = "Which machine type will be used in instances"
  type        = string
  default     = "n2-standard-2"
}
