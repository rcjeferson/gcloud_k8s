variable "project_name" {
  description = "GCP Project name"
  type        = string
  default     = "kubernetes-444013"
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
  description = "Configure cluster type (autopilot | root)"
  type        = string
  default     = "autopilot"
}
