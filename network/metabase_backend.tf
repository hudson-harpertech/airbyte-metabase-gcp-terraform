resource "google_compute_backend_service" "metabase_backend" {
  name                  = "metabase-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  locality_lb_policy    = "ROUND_ROBIN"
  timeout_sec           = 30
  enable_cdn            = false
  port_name             = "metabase"

  backend {
    group              = var.metabase_instance_group
    balancing_mode     = "UTILIZATION"
    capacity_scaler    = 1
    max_utilization    = 0.8
  }

  health_checks = [var.metabase_health_check]
}

resource "google_compute_url_map" "metabase_frontend_redirect" {
  name        = "metabase-frontend-redirect"
  description = "Automatically generated HTTP to HTTPS redirect for the metabase-frontend forwarding rule"

  default_url_redirect {
    https_redirect            = true
    redirect_response_code    = "MOVED_PERMANENTLY_DEFAULT"
    strip_query               = false
  }
}

resource "google_compute_target_http_proxy" "metabase_frontend_target_proxy" {
  name    = "metabase-frontend-target-proxy"
  url_map = google_compute_url_map.metabase_frontend_redirect.self_link
}

resource "google_compute_global_forwarding_rule" "metabase_frontend_forwarding_rule" {
  name                  = "metabase-frontend-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.metabase_frontend_target_proxy.self_link
  ip_address            = google_compute_global_address.metabase-lb-ipv4.self_link
}

resource "google_compute_url_map" "metabase_https" {
  name            = "metabase-https"
  default_service = google_compute_backend_service.metabase_backend.self_link
}

resource "google_compute_target_https_proxy" "metabase_https_target_proxy" {
  name             = "metabase-https-target-proxy"
  url_map          = google_compute_url_map.metabase_https.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.metabase-cert.self_link] # Assume SSL certificate resource is defined elsewhere
}

resource "google_compute_global_forwarding_rule" "metabase_frontend_https" {
  name                  = "metabase-frontend"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.metabase_https_target_proxy.self_link
  ip_address            = google_compute_global_address.metabase-lb-ipv4.address # Assume global address resource is defined elsewhere
}

