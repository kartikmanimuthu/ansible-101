# Terraform-Ansible SSH Integration with Amazon Linux 2

This project demonstrates the use of Terraform to provision EC2 instances running Amazon Linux 2 on AWS and Ansible to configure these instances using SSH. It showcases how to install and run a simple "Hello World" playbook on the EC2 instances.

## Project Structure

- `main.tf`: Terraform configuration file for AWS resources and SSH key pair
- `playbook-install.yml`: Ansible playbook to create a "Hello World" file and display its content

## Prerequisites

1. Terraform installed (version ~> 1.0)
2. AWS CLI configured with appropriate credentials
3. Ansible installed (version 2.9 or later)

## Terraform Configuration

The `main.tf` file contains the following key components:

1. AWS provider configuration
2. SSH key pair generation and management
3. Security group for SSH access
4. EC2 instance creation with Amazon Linux 2 AMI
5. Ansible playbook execution using local-exec provisioner

```terraform:terraform-ansible-ssh-amz-linux/main.tf
startLine: 1
endLine: 99
```

## Ansible Playbook

The `playbook-install.yml` file creates a "Hello World" file and displays its content:

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

- `instance_public_ips`: Public IP addresses of the created EC2 instances
- `instance_ids`: IDs of the created EC2 instances

## Notes

- This setup uses SSH for connecting to the EC2 instances, which requires proper security group configuration and key pair management.
- The Ansible playbook is executed directly from Terraform using the local-exec provisioner, demonstrating the integration between infrastructure provisioning and configuration management.
- The project uses Amazon Linux 2 AMI, which uses `ec2-user` as the default user for SSH connections.
- Make sure to review and adjust the AWS region, instance type, and other parameters in the `main.tf` file to match your requirements.

## Security Considerations

- The SSH key pair is generated and stored locally. Ensure that the private key (`private_key.pem`) is kept secure and not committed to version control.
- The security group allows SSH access from anywhere (0.0.0.0/0). In a production environment, you should restrict this to specific IP ranges.
- The private key is temporarily stored in AWS Systems Manager Parameter Store. Ensure that you have appropriate IAM permissions and consider using more secure methods for key management in production environments.

## Troubleshooting

- If you encounter SSH connection issues, ensure that the security group allows inbound traffic on port 22 and that the key pair is correctly associated with the EC2 instance.
- Check that the `ansible_user` in the playbook matches the default user for Amazon Linux 2 (ec2-user).
- If Ansible fails to connect, you may need to adjust the `sleep` duration in the local-exec provisioner to allow more time for the EC2 instance to initialize.
- Ensure that your AWS CLI is correctly configured with the appropriate credentials and region.
