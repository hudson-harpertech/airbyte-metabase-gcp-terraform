variable project_id {
    type = string
    default = "sample-airbyte-metabase-from-terraform"
    description = "The project ID of your GCP project"
}

variable region {
    type = string
    default = "us-west1"
    description = "The region of your GCP project"
}

variable zone {
    type = string
    default = "us-west1-b"
    description = "The region of your GCP project"
}

variable vpc_name {
    type = string
    default = "my-custom-vpc"
    description = "Name of custom VPC Network"
}

# data "terraform_remote_state" "networks" {
#   backend = "local"
# }

variable domain_name {
    type = string
    default = "example.com"
    description = "The domain name of your website"
}

variable support_email {
    type = string
    description = "The support email for the project"
}

variable airbyte_instance_group {
    type = string
    default = "airbyte-instance-group"
    description = "The name of the instance group for Airbyte"
}

variable airbyte_instance {
    type = string
    default = "airbyte-instance"
    description = "The name of the instance for Airbyte"
}

variable airbyte_health_check {
    type = string
    default = "airbyte-health-check"
    description = "The name of the health check for Airbyte"
}

variable metabase_instance_group {
    type = string
    default = "metabase-instance-group"
    description = "The name of the instance group for Airbyte"
}

variable metabase_instance {
    type = string
    default = "metabase-instance"
    description = "The name of the instance for Airbyte"
}

variable metabase_health_check {
    type = string
    default = "metabase-health-check"
    description = "The name of the health check for Airbyte"
}