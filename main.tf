# Main file

  terraform {
    required_providers {
      google = {
        source = "hashicorp/google"
        version = ">=6.33.0"
      }
    }
  }

 provider "google" {
   project = var.project
   region = "australia-southeast2"

 }


resource "google_storage_bucket" "openweb-bucket" {
  location                    = "australia-southeast1"
  name                        = "openweb-bucket"
  uniform_bucket_level_access = true
  force_destroy               = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}