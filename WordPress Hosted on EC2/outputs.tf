##################### Output Setup Server EC2 Instance ID #####################

output "public_ip" {
  value = aws_instance.setup_server.public_ip
  sensitive = true
}

##################### Output Bastion Host IPs #####################

output "bh_public_ip" {
  value = aws_instance.bastion_host.public_ip
  sensitive = true
}

output "bh_private_ip" {
  value = aws_instance.bastion_host.private_ip
  sensitive = true
}

##################### Output Setup Server Private Key #####################

output "setup_server_private_key" {
  value = tls_private_key.rsa.private_key_pem
  sensitive = true
}

##################### EFS ID #####################

output "efs_id" {
  value = aws_efs_file_system.dev_efs.id
  sensitive = true
}

##################### AZ1 EC2 private subnet #####################

output "az1_private_subnet_ec2_private_ip" {
  value = aws_instance.app_server_az1.private_ip
  sensitive = true
}

##################### AZ2 EC2 private subnet #####################

output "az2_private_subnet_ec2_private_ip" {
  value = aws_instance.app_server_az2.private_ip
  sensitive = true
}


