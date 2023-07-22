data "aws_efs_file_system" "example" {
  file_system_id = aws_efs_file_system.example.id
}

##################### Key Pair #####################

resource "aws_key_pair" "pepperoni_tf_key" {
  key_name   = "pepperoni_tf_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

##################### Save Private Key Instance #####################

resource "local_file" "pepperoni_tf_key" {
  filename = "pepperoni_tf_key"
  content  = tls_private_key.rsa.private_key_pem
}

##################### Setup Server EC2 Instance #####################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "setup_server" {
  ami           = data.aws_ami.amazon_linux_2.id  # Correctly reference the Amazon Linux 2 AMI data source
  instance_type = "t2.micro"
  key_name      = aws_key_pair.pepperoni_tf_key.key_name
  subnet_id     = aws_subnet.pub_az_1.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.alb_sg.id, aws_security_group.webserver_sg.id]
}

##################### Output Setup Server EC2 Instance ID #####################

output "instance_id" {
  value = aws_instance.setup_server.id
}

##################### EC2 Server AZ1 Instance #####################

resource "aws_instance" "app_server_az1" {
  ami           = data.aws_ami.amazon_linux_2.id  # Correctly reference the Amazon Linux 2 AMI data source
  instance_type = "t2.micro"
  key_name      = aws_key_pair.pepperoni_tf_key.key_name
  subnet_id     = aws_subnet.pri_app_az_1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
    
  tags = {
    Name = "Server_AZ1"
  }

  user_data = <<-EOT
#!/bin/bash
yum update -y
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd 
sudo systemctl start httpd
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld
echo "data.aws_efs_file_system.dev_efs.dns_name:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a
chown apache:apache -R /var/www/html
sudo service httpd restart
EOT
}

##################### EC2 Server AZ2 Instance #####################


resource "aws_instance" "app_server_az2" {
  ami           = data.aws_ami.amazon_linux_2.id  # Correctly reference the Amazon Linux 2 AMI data source
  instance_type = "t2.micro"
  key_name      = aws_key_pair.pepperoni_tf_key.key_name
  subnet_id     = aws_subnet.pri_app_az_2.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  
  tags = {
    Name = "Server_AZ2"
  }
  user_data = <<-EOT
#!/bin/bash
yum update -y
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd 
sudo systemctl start httpd
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld
echo "data.aws_efs_file_system.dev_efs.dns_name:/ /var/www/html nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a
chown apache:apache -R /var/www/html
sudo service httpd restart
EOT
}


##################### Bastion Host #####################

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.amazon_linux_2.id  # Correctly reference the Amazon Linux 2 AMI data source
  instance_type = "t2.micro"
  key_name      = aws_key_pair.pepperoni_tf_key.key_name
  subnet_id     = aws_subnet.pub_az_1.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  
  tags = {
    Name = "Bastion_Host"
  }

}


##################### Output Bastion Host #####################

output "bastion_host_instance_id" {
  value = aws_instance.bastion_host.id
}


