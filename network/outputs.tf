output "network_id" {
  value       = google_compute_network.vpc.id
  description = "The ID of the network"
}