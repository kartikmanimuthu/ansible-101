# Terraform-Ansible SSM Integration with Ubuntu and Amazon Linux

This project demonstrates the use of Terraform to provision EC2 instances running Ubuntu and Amazon Linux 2023 on AWS, and Ansible to configure these instances using AWS Systems Manager (SSM). It showcases how to install Docker, Docker Compose, and PostgreSQL on the EC2 instances using Ansible playbooks executed through SSM.

## Project Structure

- `main.tf`: Terraform configuration file for AWS resources and IAM roles
- `ubuntu-playbook-install.yml`: Ansible playbook to install Docker, Docker Compose, and PostgreSQL on Ubuntu instances
- `amz-linux-playbook-install.yml`: Ansible playbook to install Docker and Docker Compose on Amazon Linux 2023 instances

## Prerequisites

1. Terraform installed (version ~> 1.0)
2. AWS CLI configured with appropriate credentials
3. Ansible installed (version 2.9 or later)

## Terraform Configuration

The `main.tf` file contains the following key components:

1. AWS provider configuration
2. IAM role and instance profile for EC2 instances with SSM access
3. EC2 instance creation for both Ubuntu and Amazon Linux 2023
4. S3 bucket creation for Ansible SSM

## Ansible Playbooks

### Ubuntu Playbook

The `ubuntu-playbook-install.yml` file installs Docker, Docker Compose, and PostgreSQL on Ubuntu instances:

### Amazon Linux 2023 Playbook

The `amz-linux-playbook-install.yml` file installs Docker and Docker Compose on Amazon Linux 2023 instances:

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

- `ubuntu_instance_ids`: IDs of the created Ubuntu EC2 instances
- `amazon_linux_instance_ids`: IDs of the created Amazon Linux EC2 instances
- `iam_role_name`: Name of the IAM role associated with the EC2 instances
- `iam_instance_profile_name`: Name of the IAM instance profile associated with the EC2 instances
- `ansible_ssm_bucket_name`: Name of the S3 bucket created for Ansible SSM

## Notes

- This setup uses AWS Systems Manager (SSM) for connecting to the EC2 instances, which provides a more secure method than traditional SSH connections.
- The Ansible playbooks are executed separately from Terraform, allowing for more flexibility in configuration management.
- Make sure to review and adjust the AWS region, instance type, and other parameters in the `main.tf` file to match your requirements.
- The project uses Ansible roles from Geerlingguy for PostgreSQL and Docker installation on Ubuntu instances.

## Security Considerations

- The IAM role and instance profile are configured to allow SSM access to the EC2 instances. Ensure that you review and adjust the permissions as needed for your specific use case.
- Consider using AWS Secrets Manager or AWS Parameter Store for managing sensitive information instead of hardcoding values in the playbooks or Terraform files.

## Troubleshooting

- If you encounter issues with Ansible connecting to the EC2 instances, ensure that the SSM Agent is properly installed and running on the instances.
- Verify that the IAM role attached to the EC2 instances has the necessary permissions for SSM.
- Check the AWS region settings in both Terraform and Ansible configurations to ensure they match.
- If Ansible fails to execute, you may need to adjust the `sleep` duration in the Terraform configuration to allow more time for the EC2 instances to initialize and the SSM Agent to start.
