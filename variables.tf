# variables.tf
variable "project" {
  type = string
  description = "The GCP project ID"
  default = "openweb-459102" # Set a default value or ensure it's passed in
}

variable "vm" {}