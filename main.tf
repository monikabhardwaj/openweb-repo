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
   user_project_override = true
 }

#API list to be enabled
locals {
  apis_to_enable= [
  "cloudresourcemanager.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
]
}


resource "google_project_service" "openweb-vm" {
  project            = var.project
  for_each           = toset(local.apis_to_enable) # Use toset to ensure uniqueness
  service            = each.value
  disable_on_destroy = false  # Keep APIs enabled when Terraform destroys the resource
}

resource "google_storage_bucket" "openweb-bucket" {
  location                    = "australia-southeast2"
  name                        = "openweb-bucket1"
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