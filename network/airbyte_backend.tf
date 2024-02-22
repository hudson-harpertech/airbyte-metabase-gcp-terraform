resource "google_compute_backend_service" "airbyte_backend" {
  name                  = "airbyte-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  locality_lb_policy    = "ROUND_ROBIN"
  timeout_sec           = 30
  enable_cdn            = false
  port_name             = "airbyte"

  backend {
    group              = var.airbyte_instance_group
    balancing_mode     = "UTILIZATION"
    capacity_scaler    = 1
    max_utilization    = 0.8
  }

  health_checks = [var.airbyte_health_check]
}

resource "google_compute_url_map" "airbyte_frontend_redirect" {
  name        = "airbyte-frontend-redirect"
  description = "Automatically generated HTTP to HTTPS redirect for the airbyte-frontend forwarding rule"

  default_url_redirect {
    https_redirect            = true
    redirect_response_code    = "MOVED_PERMANENTLY_DEFAULT"
    strip_query               = false
  }
}

resource "google_compute_target_http_proxy" "airbyte_frontend_target_proxy" {
  name    = "airbyte-frontend-target-proxy"
  url_map = google_compute_url_map.airbyte_frontend_redirect.self_link
}

resource "google_compute_global_forwarding_rule" "airbyte_frontend_forwarding_rule" {
  name                  = "airbyte-frontend-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.airbyte_frontend_target_proxy.self_link
  ip_address            = google_compute_global_address.airbyte-lb-ipv4.self_link
}

resource "google_compute_url_map" "airbyte_https" {
  name            = "airbyte-https"
  default_service = google_compute_backend_service.airbyte_backend.self_link
}

resource "google_compute_target_https_proxy" "airbyte_https_target_proxy" {
  name             = "airbyte-https-target-proxy"
  url_map          = google_compute_url_map.airbyte_https.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.airbyte-cert.self_link] # Assume SSL certificate resource is defined elsewhere
}

resource "google_compute_global_forwarding_rule" "airbyte_frontend_https" {
  name                  = "airbyte-frontend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.airbyte_https_target_proxy.self_link
  ip_address            = google_compute_global_address.airbyte-lb-ipv4.address # Assume global address resource is defined elsewhere
}

