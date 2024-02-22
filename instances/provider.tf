provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
	required_providers {
		google = {
	    version = "~> 4.28.0"
		}
  }
}
