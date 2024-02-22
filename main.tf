terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.28.0"
    }
  }
  required_version = ">= 0.13"
}

resource "google_project_service" "cloudresourcemanager_service" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "monitoring_service" {
  project = var.project_id
  service = "monitoring.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "serviceusage_service" {
  project = var.project_id
  service = "serviceusage.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "iam_service" {
  project = var.project_id
  service = "iam.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "compute_service" {
  project = var.project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "iap_service" {
  project = var.project_id
  service = "iap.googleapis.com"
}

module "network" {
    source = "./network"
    project_id = var.project_id
    region = var.region
    vpc_name = var.vpc_name
    domain_name = var.domain_name
    support_email = var.support_email
    airbyte_instance_group = module.instances.airbyte-instance-group
    airbyte_instance = module.instances.airbyte-instance
    airbyte_health_check = module.healthChecks.airbyte-health-check
    metabase_instance_group = module.instances.metabase-instance-group
    metabase_instance = module.instances.metabase-instance
    metabase_health_check = module.healthChecks.metabase-health-check
}

module "instances" {
    source = "./instances"
    project_id = var.project_id
    region = var.region
    zone = var.zone
    vpc_name = var.vpc_name
    network_id = module.network.network_id
}

module "healthChecks" {
    source = "./healthChecks"
    project_id = var.project_id
    region = var.region
}

