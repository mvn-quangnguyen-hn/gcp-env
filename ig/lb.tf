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

#health_check
resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

# backend service
resource "google_compute_backend_service" "default" {
  name                  = "lb-backend-subnet"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.autohealing.id]
  backend {
    group           = google_compute_instance_group_manager.appserver.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
