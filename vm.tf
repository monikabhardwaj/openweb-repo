resource "google_service_account" "openweb-sa" {
  account_id = "openweb-vm-sa"
  display_name = "Custom SA for VM Instance"
}

data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
  }

resource "google_compute_instance" "debian" {
  machine_type = "n2-standard-2"
  name         = "my-instance-openweb"
  zone         = "australia-southeast2-b"

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link #self-link latest image
      size = 10
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

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email = google_service_account.openweb-sa.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    "ssh-keys" = <<EOT
     dev : SHA256:rplHojbM3AwthIRAsmGYznSHV/r5RN5dYRgWDxnvudA openweb
     EOT

    #"openweb:${file("~/.ssh/id_rsa.pub")} openweb"
  }
  #startup_script = templatefile(
  #  "./scripts/provisions.sh",
  #  {})
}

resource "google_compute_firewall" "ssh" {
  name        = "ssh-access"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["22", "8080"]
  }

  target_tags = ["ssh"]
  source_ranges = ["0.0.0.0/0"]

}