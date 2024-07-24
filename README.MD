# Terraform and Ansible Integration Examples

This repository contains various examples of integrating Terraform with Ansible for infrastructure provisioning and configuration management. The examples demonstrate different approaches to using these tools together in AWS environments.

## Repository Structure

The repository is organized into several directories, each containing a different example or configuration:

1. terraform-ansible-provider
2. terraform-ansible-seperate-orchectrator
3. terraform-ansible-ssh
4. terraform-ansible-ssh-amz-linux
5. terraform-ansible-ssm
6. terraform-ansible-ssm-ubuntu-amz-linux-role

Each directory contains Terraform configurations, Ansible playbooks, and other necessary files for the specific integration approach.

## Key Features

- AWS EC2 instance provisioning using Terraform
- Ansible playbook execution for configuration management
- Various methods of connecting Ansible to EC2 instances:
  - SSH
  - AWS Systems Manager (SSM)
  - Ansible AWS provider
- Support for both Ubuntu and Amazon Linux 2 AMIs
- IAM role and instance profile creation for EC2 instances
- S3 bucket creation for Ansible SSM integration

## Prerequisites

- Terraform (version 1.7.5 or later)
- Ansible (latest version recommended)
- AWS CLI configured with appropriate credentials
- Basic knowledge of Terraform, Ansible, and AWS services

## Usage

To use any of the examples:

1. Navigate to the desired example directory
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Review and modify the `main.tf` file as needed
4. Apply the Terraform configuration:
   ```
   terraform apply
   ```
5. For examples using separate Ansible execution, run the Ansible playbook after Terraform completes:
   ```
   ansible-playbook -i <inventory> <playbook.yml>
   ```

## Examples Overview

1. **terraform-ansible-provider**: Uses the Terraform Ansible provider to execute Ansible playbooks directly from Terraform.

2. **terraform-ansible-seperate-orchectrator**: Demonstrates using Terraform for provisioning and Ansible as a separate orchestrator for configuration.

3. **terraform-ansible-ssh**: Configures EC2 instances for SSH access and uses Ansible over SSH for configuration.

4. **terraform-ansible-ssh-amz-linux**: Similar to the SSH example, but specifically for Amazon Linux 2 instances.

5. **terraform-ansible-ssm**: Utilizes AWS Systems Manager (SSM) for executing Ansible playbooks on EC2 instances.

6. **terraform-ansible-ssm-ubuntu-amz-linux-role**: Extends the SSM example to support both Ubuntu and Amazon Linux 2, with role-based configurations.

## Important Notes

- Ensure proper AWS credentials are set up before running the examples.
- Review and adjust security group settings in the Terraform configurations as needed.
- Some examples use local-exec provisioners, which may require additional setup on your local machine.

## Contributing

Contributions to improve the examples or add new integration methods are welcome. Please submit a pull request with your changes.

## License

This project is licensed under the terms of the license included in the repository.
