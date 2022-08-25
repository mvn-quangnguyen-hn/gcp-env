resource "google_compute_network" "vpc_network" {
  name                    = "${var.environment}-vpc-network"
  auto_create_subnetworks = true
}
