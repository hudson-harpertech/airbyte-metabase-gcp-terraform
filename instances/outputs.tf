output "airbyte-instance" {
    value = google_compute_instance.airbyte-instance.self_link
}

output "airbyte-instance-group" {
    value = google_compute_instance_group.airbyte-instance-group.self_link
}

output "metabase-instance" {
    value = google_compute_instance.metabase-instance.self_link
}

output "metabase-instance-group" {
    value = google_compute_instance_group.metabase-instance-group.self_link
}