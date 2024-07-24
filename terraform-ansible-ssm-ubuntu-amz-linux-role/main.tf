# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
}

locals {
  ubuntu_instance_count = 1
  amazon_instance_count = 1
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
  name               = "EC2RoleSSM"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfileSSM"
  role = aws_iam_role.ec2_role.name
}



# Get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_region" "current" {}

resource "aws_instance" "ubuntu" {
  count         = local.ubuntu_instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "ssm-ubuntu-instance-${count.index}"
  }
}

resource "aws_instance" "amazon_linux" {
  count         = local.amazon_instance_count
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "ssm-amazon-linux-instance-${count.index}"
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "ansible_ssm_bucket" {
  bucket = "ansible-ssm-bucket-${random_string.bucket_suffix.result}"
}

# resource "null_resource" "install_ansible_role" {
#   provisioner "local-exec" {
#     command = "ansible-galaxy role install geerlingguy.postgresql,3.5.2"
#   }
# }

# resource "null_resource" "wait_for_instances" {
#   depends_on = [aws_instance.ubuntu, aws_instance.amazon_linux]

#   provisioner "local-exec" {
#     command = <<-EOT
#       aws ec2 wait instance-status-ok --instance-ids ${join(" ", concat(aws_instance.ubuntu[*].id, aws_instance.amazon_linux[*].id))}
#     EOT
#   }
# }

# resource "null_resource" "run_ansible_ubuntu" {
#   count      = local.ubuntu_instance_count
#   depends_on = [null_resource.wait_for_instances, null_resource.install_ansible_role]

#   provisioner "local-exec" {
#     command     = <<-EOT
#       sleep 120
#       ansible-playbook -i '${aws_instance.ubuntu[count.index].id},' \
#       -e "ansible_aws_ssm_bucket_name=${aws_s3_bucket.ansible_ssm_bucket.id}" \
#       -e "ansible_aws_ssm_region=${data.aws_region.current.name}" \
#       playbook-install-ubuntu.yml
#     EOT
#     working_dir = path.module
#     interpreter = ["/bin/bash", "-c"]
#     environment = {
#       ANSIBLE_HOST_KEY_CHECKING           = "False"
#       OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"
#     }
#   }
# }

# resource "null_resource" "run_ansible_amazon_linux" {
#   count      = local.amazon_instance_count
#   depends_on = [null_resource.wait_for_instances, null_resource.install_ansible_role]

#   provisioner "local-exec" {
#     command     = <<-EOT
#       sleep 120
#       ansible-playbook -i '${aws_instance.amazon_linux[count.index].id},' \
#       -e "ansible_aws_ssm_bucket_name=${aws_s3_bucket.ansible_ssm_bucket.id}" \
#       -e "ansible_aws_ssm_region=${data.aws_region.current.name}" \
#       playbook-install-amazon-linux.yml
#     EOT
#     working_dir = path.module
#     interpreter = ["/bin/bash", "-c"]
#     environment = {
#       ANSIBLE_HOST_KEY_CHECKING           = "False"
#       OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"
#     }
#   }
# }

output "ubuntu_instance_ids" {
  description = "Instance IDs of the Ubuntu EC2 instances"
  value       = aws_instance.ubuntu[*].id
}

output "amazon_linux_instance_ids" {
  description = "Instance IDs of the Amazon Linux EC2 instances"
  value       = aws_instance.amazon_linux[*].id
}

output "iam_role_name" {
  description = "IAM Role name associated with the EC2 instances"
  value       = aws_iam_role.ec2_role.name
}

output "iam_instance_profile_name" {
  description = "IAM Instance Profile name associated with the EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ansible_ssm_bucket_name" {
  description = "S3 bucket name for Ansible SSM"
  value       = aws_s3_bucket.ansible_ssm_bucket.id
}
