# reserved IP address
resource "google_compute_global_address" "default" {
  name = "lb-static-ip"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# HTTP target proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "lb-target-http-proxy"
  url_map  = google_compute_url_map.default.id
}

# URL map
resource "google_compute_url_map" "default" {
  name            = "lbl-url-map"
  default_service = google_compute_backend_service.default.id
}

# backend service
resource "google_compute_backend_service" "default" {
  name                  = "lb-backend-subnet"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  connection_draining_timeout_sec = 60

  backend {
    capacity_scaler = 1
    group           = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}
