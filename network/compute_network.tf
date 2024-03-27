# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"

}

# Create a Subnet
resource "google_compute_subnetwork" "my-custom-subnet" {
  name          = "my-custom-subnet-2"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
  depends_on    = [google_compute_network.vpc]
}

resource "google_compute_firewall" "allow-health-check-airbyte" {
  allow {
    ports    = ["8000"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "allow-health-check-airbyte"
  network       = var.vpc_name
  priority      = "1000"
  project       = var.project_id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["airbyte"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "allow-health-check-metabase" {
  allow {
    ports    = ["3000"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "allow-health-check-metabase"
  network       = var.vpc_name
  priority      = "1000"
  project       = var.project_id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["metabase"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "custom-allow-http" {
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "custom-allow-http"
  network       = var.vpc_name
  priority      = "1000"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "custom-allow-https" {
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "custom-allow-https"
  network       = var.vpc_name
  priority      = "1000"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "custom-allow-icmp" {
  allow {
    protocol = "icmp"
  }

  description   = "Allow ICMP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "custom-allow-icmp"
  network       = var.vpc_name
  priority      = "65534"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "custom-allow-rdp" {
  allow {
    ports    = ["3389"]
    protocol = "tcp"
  }

  description   = "Allow RDP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "custom-allow-rdp"
  network       = var.vpc_name
  priority      = "65534"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

resource "google_compute_firewall" "custom-allow-ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  description   = "Allow SSH from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "custom-allow-ssh"
  network       = var.vpc_name
  priority      = "65534"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

# Create Cloud Router

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "nat-router"
  network = var.vpc_name
  region  = var.region
  depends_on    = [google_compute_subnetwork.my-custom-subnet]
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_router.router]

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "metabase-lb-ipv4" {
  address_type  = "EXTERNAL"
  ip_version    = "IPV4"
  name          = "metabase-lb-ipv4"
  prefix_length = "0"
  project       = var.project_id
  depends_on    = [google_compute_router_nat.nat]
}

resource "google_compute_global_address" "airbyte-lb-ipv4" {
  address_type  = "EXTERNAL"
  ip_version    = "IPV4"
  name          = "airbyte-lb-ipv4"
  prefix_length = "0"
  project       = var.project_id
  depends_on    = [google_compute_router_nat.nat]
}

resource "google_compute_managed_ssl_certificate" "airbyte-cert" {
  managed {
    domains = ["airbyte.${var.domain_name}"]
  }

  name       = "airbyte-cert"
  project    = var.project_id
  type       = "MANAGED"
  depends_on = [google_compute_global_address.airbyte-lb-ipv4]
}

resource "google_compute_managed_ssl_certificate" "metabase-cert" {
  managed {
    domains = ["metabase.${var.domain_name}"]
  }

  name       = "metabase-cert"
  project    = var.project_id
  type       = "MANAGED"
  depends_on = [google_compute_global_address.metabase-lb-ipv4]
}

resource "google_iap_brand" "iap_brand" {
  support_email     = var.support_email
  application_title = "Cloud IAP protected Application"
  project           = var.project_id
  depends_on        = [google_compute_managed_ssl_certificate.airbyte-cert, google_compute_managed_ssl_certificate.metabase-cert]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_iap_client" "iap_client" {
  display_name = "Test Client"
  brand        =  google_iap_brand.iap_brand.name
  depends_on   = [google_iap_brand.iap_brand]
}