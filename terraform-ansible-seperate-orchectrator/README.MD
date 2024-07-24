# Terraform-Ansible Separate Orchestrator

This project demonstrates the use of Terraform and Ansible as separate tools to provision and configure EC2 instances on AWS. It showcases how to install and uninstall Docker and Docker Compose on Ubuntu 20.04 EC2 instances using Ansible playbooks, with the infrastructure provisioned by Terraform.

## Project Structure

- `tf/`: Terraform configuration files
  - `main.tf`: Terraform configuration for AWS resources
  - `.terraform.lock.hcl`: Terraform dependency lock file
- `ansible/`: Ansible configuration and playbooks
  - `install-docker.yml`: Ansible playbook to install Docker and Docker Compose
  - `uninstall-docker.yml`: Ansible playbook to uninstall Docker and Docker Compose
  - `hosts.ini`: Inventory file for Ansible
  - `ansible.cfg.test`: Ansible configuration file

## Prerequisites

1. Terraform installed (version ~> 1.0)
2. AWS CLI configured with appropriate credentials
3. Ansible installed (version 2.9 or later)

## Terraform Configuration

The `tf/main.tf` file contains the following key components:

1. AWS provider configuration
2. IAM role and instance profile for EC2 instances
3. EC2 instance creation

```terraform:terraform-ansible-seperate-orchectrator/tf/main.tf
startLine: 1
endLine: 84
```

## Usage

1. Navigate to the `tf` directory and initialize Terraform:

   ```
   cd tf
   terraform init
   ```

2. Plan and apply the Terraform configuration:

   ```
   terraform plan
   terraform apply
   ```

3. Update the `ansible/hosts.ini` file with the EC2 instance IDs created by Terraform.

4. Run the Ansible playbook to install Docker:

   ```
   cd ../ansible
   ansible-playbook -i hosts.ini install-docker.yml
   ```

5. To uninstall Docker, run:

   ```
   ansible-playbook -i hosts.ini uninstall-docker.yml
   ```

6. To destroy the resources:
   ```
   cd ../tf
   terraform destroy
   ```

## Notes

- This setup uses AWS Systems Manager (SSM) for connecting to the EC2 instances, which provides a more secure method than traditional SSH connections.
- The Ansible playbooks are executed separately from Terraform, allowing for more flexibility in configuration management.
- Make sure to review and adjust the AWS region, instance type, and other parameters in the `tf/main.tf` file to match your requirements.
- The `ansible.cfg.test` file is provided as an example. Rename it to `ansible.cfg` and adjust the settings as needed for your environment.

## Security Considerations

- Ensure that your AWS credentials are properly secured and not exposed in any of the configuration files.
- Review and customize the IAM roles and policies to follow the principle of least privilege.
- Consider using AWS Secrets Manager or similar services to manage sensitive information.

## Troubleshooting

- If you encounter issues with Ansible connecting to the EC2 instances, ensure that the SSM Agent is properly installed and running on the instances.
- Verify that the IAM role attached to the EC2 instances has the necessary permissions for SSM.
- Check the AWS region settings in both Terraform and Ansible configurations to ensure they match.
