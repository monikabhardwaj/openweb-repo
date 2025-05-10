resource "google_service_account" "openweb-sa" {
  account_id = "openweb-vm-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "openweb" {
  machine_type = "n2-standard-2"
  name         = "my-instance-openweb"
  zone         = "australia-southeast1"
}

tags = ["foo", "bar"]

boot_disk {
  initialize_params {
    image = "debian-cloud/debian-11"
    labels = {
      my_label = "value"
    }
  }
}

// Local SSD disk
scratch_disk {
  interface = "NVME"
}

network_interface {
  network = "default"

  access_config {
    // Ephemeral public IP
  }
}

metadata = {
  foo = "bar"
}

metadata_startup_script = "echo hi > /test.txt"

service_account {
  # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  email  = google_service_account.openweb-sa.email
  scopes = ["cloud-platform"]
}