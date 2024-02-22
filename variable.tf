variable domain_name {
    type = string
    default = "example.com"
    description = "The domain name of your website"
}

variable org_id {
    type = string
    description = "The GCP id of your organization"
}

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

variable support_email {
    type = string
    description = "The support email for the project"
}

# variable oauth2_client_id {
#     type = string
#     description = "OAuth2 client ID for IAP"
# }