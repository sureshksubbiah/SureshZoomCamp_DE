terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }
}

provider "google" {
  project = "dtc-de-26051982"
  region  = "us-central1"
}

resource "google_storage_bucket" "terra_demo_bucket" {
  name          = "dtc-de-26051982-terra-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}