# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

# Generate a new key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a key pair in AWS
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Store the private key in AWS Systems Manager Parameter Store
resource "aws_ssm_parameter" "private_key" {
  name        = "/ec2/private-key"
  description = "Private key for EC2 instances"
  type        = "SecureString"
  value       = tls_private_key.example.private_key_pem
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instances and associate them with the instance profile
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "owner-id"
    values = ["099720109477"] # Canonical's AWS account ID
  }
}

data "aws_region" "current" {}

resource "aws_instance" "example" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  provisioner "local-exec" {
    command     = <<-EOT
      sleep 120 # Wait for 120 seconds before running Ansible
      aws ssm get-parameter --name "/ec2/private-key" --with-decryption --query "Parameter.Value" --output text > private_key.pem
      chmod 600 private_key.pem
      ansible-playbook -i '${self.public_ip},' \
      -u ubuntu \
      --private-key private_key.pem \
      playbook-install-docker.yml
      rm private_key.pem
    EOT
    working_dir = path.module
    interpreter = ["/bin/bash", "-c"]
    environment = {
      ANSIBLE_HOST_KEY_CHECKING           = "False"
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"
    }
  }

  tags = {
    Name = "example-instance-${count.index}"
  }
}

# Output the public IP addresses of the instances
output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.example[*].public_ip
}

# Output the instance IDs
output "instance_ids" {
  description = "Instance IDs of the EC2 instances"
  value       = aws_instance.example[*].id
}
