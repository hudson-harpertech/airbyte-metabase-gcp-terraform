output "airbyte-health-check" {
    value = google_compute_health_check.airbyte-health-check.self_link
}

output "metabase-health-check" {
    value = google_compute_health_check.metabase-health-check.self_link
}