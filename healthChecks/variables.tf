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