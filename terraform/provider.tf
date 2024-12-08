terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

# Configura o Provider Google Cloud com o Projeto
provider "google" {
  project = var.project_name
  region = var.region
  zone = var.zone
}