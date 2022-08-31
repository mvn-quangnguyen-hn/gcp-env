resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "instance-template-"
  machine_type = "e2-small"

  // boot disk
  disk {
    source_image = "debian-cloud/debian-11"
  }

  // networking
  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      // Ephemeral public IP
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get install nginx -y
  EOF
}
