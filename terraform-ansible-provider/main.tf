terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create an IAM role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name               = "EC2Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# Create the EC2 instances
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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "example-instance-${count.index}"
  }
}

resource "ansible_playbook" "install_docker" {
  count = length(aws_instance.example)

  playbook                = "${path.module}/playbook-install-docker.yml"
  name                    = aws_instance.example[count.index].id
  diff_mode               = true
  verbosity               = 1
  replayable              = false
  ignore_playbook_failure = true


  extra_vars = {
    ansible_aws_ssm_bucket_name         = "ansible-ssm-bucket-stx-demo"
    ansible_aws_ssm_region              = data.aws_region.current.name
    ANSIBLE_HOST_KEY_CHECKING           = "False"
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"
  }

  depends_on = [aws_instance.example]
}

output "ansible_playbook_stdout" {
  description = "Ansible playbook stdout"
  value       = [for i in range(length(aws_instance.example)) : ansible_playbook.install_docker[i].ansible_playbook_stdout]
}

output "ansible_playbook_stderr" {
  description = "Ansible playbook stderr"
  value       = [for i in range(length(aws_instance.example)) : ansible_playbook.install_docker[i].ansible_playbook_stderr]
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

# Output the IAM Role Name
output "iam_role_name" {
  description = "IAM Role name associated with the EC2 instances"
  value       = aws_iam_role.ec2_role.name
}

# Output the IAM Instance Profile Name
output "iam_instance_profile_name" {
  description = "IAM Instance Profile name associated with the EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.name
}
