##################### EC2 Launch Template #####################

resource "aws_launch_configuration" "dev-launch-template" {
  image_id             = data.aws_ami.amazon_linux_2.id
  instance_type        = "t2.micro"              
  security_groups      = [aws_security_group.webserver_sg.id]  
  key_name             = aws_key_pair.pepperoni_tf_key.key_name     
  user_data            = <<-EOF
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
    EOF

  lifecycle {
    create_before_destroy = true
  }
}

##################### ASG #####################

resource "aws_autoscaling_group" "dev_asg" {
  name                 = "dev_asg"
  vpc_zone_identifier = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  target_group_arns = aws_lb.app_alb.arn
  health_check_type = ELB
  enabled_metrics = GroupTotalInstances
  launch_template {
    id      = aws_launch_template.dev-launch-template.id
  }
  desired_capacity = 2
  min_size             = 1
  max_size             = 4

  lifecycle {
    create_before_destroy = true
  }
}

##################### ASG Notification #####################

resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [
    aws_autoscaling_group.dev_asg.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.dev_server_updates.arn
}