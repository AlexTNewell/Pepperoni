##################### EFS DNS Name #####################

data "aws_efs_file_system" "dev_efs" {
  file_system_id = aws_efs_file_system.dev_efs.id
}

##################### Public IP #####################

data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com/"
}

##################### AMI #####################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20230719.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

