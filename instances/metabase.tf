resource "google_compute_instance" "metabase-instance" {
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      size  = "30"
    }
    auto_delete = "true"
    device_name = "metabase-instance"
    mode        = "READ_WRITE"
  }

  can_ip_forward = "false"

  confidential_instance_config {
    enable_confidential_compute = "false"
  }

  deletion_protection = "false"
  enable_display      = "false"

  lifecycle {
    ignore_changes = all
  }

  machine_type        = "e2-medium"

  metadata = {
    startup-script = file("${path.module}/metabase_startup_script.sh")
  }

  name = "metabase-instance"

  network_interface {
    network = var.vpc_name
    subnetwork = "my-custom-subnet-2"
    subnetwork_project = var.project_id
  }

  project = var.project_id

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = "true"
    min_node_cpus       = "0"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = "true"
    enable_secure_boot          = "false"
    enable_vtpm                 = "true"
  }

  tags = ["metabase", "lb-health-check"]
  zone = var.zone
}

resource "google_compute_instance_group" "metabase-instance-group" {
  instances = [google_compute_instance.metabase-instance.self_link]
  name      = "metabase-instance-group"

  named_port {
    name = "metabase"
    port = "3000"
  }

  network = var.network_id
  project = var.project_id
  zone    = var.zone
}