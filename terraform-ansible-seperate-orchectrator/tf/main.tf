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

resource "aws_instance" "example" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

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
