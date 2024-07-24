# Terraform Ansible Provider Example

This project demonstrates the use of Terraform with the Ansible provider to provision and configure EC2 instances on AWS. It showcases how to install and uninstall Docker and Docker Compose on Ubuntu 20.04 EC2 instances using Ansible playbooks executed through Terraform.

## Project Structure

- `main.tf`: Terraform configuration file for AWS resources and Ansible playbook execution
- `playbook-install-docker.yml`: Ansible playbook to install Docker and Docker Compose
- `playbook-uninstall-docker.yml`: Ansible playbook to uninstall Docker and Docker Compose

## Prerequisites

1. Terraform installed (version ~> 1.0)
2. AWS CLI configured with appropriate credentials
3. Ansible installed (version 2.9 or later)

## Configuration

The `main.tf` file contains the following key components:

1. AWS provider configuration
2. IAM role and instance profile for EC2 instances
3. EC2 instance creation
4. Ansible playbook execution using the `ansible_playbook` resource

## Ansible Playbooks

### Install Docker Playbook

The `playbook-install-docker.yml` file:

### Uninstall Docker Playbook

The `playbook-uninstall-docker.yml` file:

## Usage

1. Initialize Terraform:

   ```
   terraform init
   ```

2. Plan the Terraform execution:

   ```
   terraform plan
   ```

3. Apply the Terraform configuration:

   ```
   terraform apply
   ```

4. To destroy the resources:
   ```
   terraform destroy
   ```

## Outputs

The Terraform configuration provides several outputs:

- `ansible_playbook_stdout`: Standard output of the Ansible playbook execution
- `ansible_playbook_stderr`: Standard error output of the Ansible playbook execution
- `instance_public_ips`: Public IP addresses of the created EC2 instances
- `instance_ids`: IDs of the created EC2 instances
- `iam_role_name`: Name of the IAM role associated with the EC2 instances
- `iam_instance_profile_name`: Name of the IAM instance profile associated with the EC2 instances

## Notes

- This example uses the AWS Systems Manager (SSM) for connecting to the EC2 instances, which provides a more secure method than traditional SSH connections.
- The Ansible playbooks are executed directly from Terraform using the Ansible provider, demonstrating the integration between infrastructure provisioning and configuration management.
- Make sure to review and adjust the AWS region, instance type, and other parameters in the `main.tf` file to match your requirements.
