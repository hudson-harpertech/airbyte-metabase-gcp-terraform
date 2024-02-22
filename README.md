# Terraform Repository for Metabase and Airbyte Deployment

This repository contains Terraform code to deploy Metabase and Airbyte applications as VM instances on Google Cloud Platform (GCP), with each application being placed behind a load balancer for improved reliability and scalability.

## Authentication

Before using Terraform to deploy the resources, ensure that you are authenticated with GCP. We recommend using `gcloud auth application-default login` for a simple and secure way to gain credentials for Terraform to use during the deployment process.

Follow these steps to authenticate:

1. Install the [Google Cloud SDK](https://cloud.google.com/sdk) if you haven't already.
2. Run the following command to start the authentication process:

    ```sh
    gcloud auth application-default login
    ```

## Structure

-   `instances/`: Terraform configurations for the VM instances.

    -   `airbyte_startup_script.sh`: Startup script for Airbyte VM.
    -   `metabase_startup_script.sh`: Startup script for Metabase VM.
    -   `metabase.tf`: Terraform configuration for Metabase resources.
    -   `outputs.tf`: Output variables for instances.
    -   `provider.tf`: Provider configuration for Terraform.
    -   `variables.tf`: Variable definitions for instances.

-   `network/`: Terraform configurations for networking resources.

    -   `airbyte_backend.tf`: Backend configuration for Airbyte.
    -   `compute_network.tf`: Network configurations for VMs.
    -   `metabase_backend.tf`: Backend configuration for Metabase.
    -   `outputs.tf`: Output variables for network.
    -   `provider.tf`: Provider configuration for network resources.
    -   `variables.tf`: Variable definitions for network resources.

-   `terraform.lock.hcl`: Dependency lock file for Terraform.
-   `main.tf`: Main Terraform configuration file tying all modules together.
-   `README.md`: Documentation for the repository.
-   `terraform.tfvars`: (Optional) File for overriding default variable values.
-   `variable.tf`: General variable definition file.

## Prerequisites

-   GCP Account with billing enabled.
-   GCP Project ID where resources will be deployed.
-   GCP Service Account with necessary permissions for creating and managing resources.
-   Terraform installed on your machine.

## Usage

1. Clone the repository to your local machine.
2. Configure your `terraform.tfvars` file with appropriate values for your setup.
3. Initialize the Terraform environment with `terraform init`.
4. Validate the Terraform files with `terraform plan`.
5. Apply the Terraform configuration with `terraform apply`. Note, you may need to run this three times as GCP will timeout on configuring services and the network.

## Contributing

Contributions to this project are welcome. Please fork the repository and submit a pull request.

## License

This project is open-sourced under the [MIT License](LICENSE).

## Support

If you encounter any issues or require assistance, please submit an issue on the repository's issues page.
