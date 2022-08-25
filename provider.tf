terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
  }
  backend "gcs" {
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "project" {
  service = "compute.googleapis.com"
}
