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

variable network_id {
    type = string
    description = "The network ID of your VPC"
}