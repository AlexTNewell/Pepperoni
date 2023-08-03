##################### EFS DNS Name #####################

data "aws_efs_file_system" "dev_efs" {
  file_system_id = aws_efs_file_system.dev_efs.id
}

##################### Hosted Zone #####################

data "aws_route53_zone" "primary" {
    name            = "thelondonchesssystem.com"
    private_zone    = false
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

##################### AWS Launch Config User Data #####################

data "template_file" "user_data" {
  template = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    git clone https://github.com/AlexTNewell/possible-solution.git
    yum install -y amazon-efs-utils  # For Amazon Linux
    mkdir -p /var/www/docker_resources
    echo "data.aws_efs_file_system.dev_efs.dns_name:/ /var/www/docker_resources nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
    mount -a
    cp -r /home/ec2-user/possible-solution/* /var/www/docker_resources
    docker build anewellcloud/possible-solution:latest
    docker run -d -p 80:80 -v /var/www/docker_resources/main/sub:/www anewellcloud/possible-solution:latest
  EOT
}


