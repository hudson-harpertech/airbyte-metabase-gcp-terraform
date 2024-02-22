resource "google_compute_health_check" "airbyte-health-check" {
  check_interval_sec = "5"
  healthy_threshold  = "2"

  log_config {
    enable = "false"
  }

  name    = "airbyte-health-check"
  project = var.project_id

  tcp_health_check {
    port         = "8000"
    proxy_header = "NONE"
  }

  timeout_sec         = "5"
  unhealthy_threshold = "2"
}

resource "google_compute_health_check" "metabase-health-check" {
  check_interval_sec = "5"
  healthy_threshold  = "2"

  log_config {
    enable = "false"
  }

  name    = "metabase-health-check"
  project = var.project_id

  tcp_health_check {
    port         = "3000"
    proxy_header = "NONE"
  }

  timeout_sec         = "5"
  unhealthy_threshold = "2"
}
