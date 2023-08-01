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

output "setup_server_private_key" {
  value = tls_private_key.rsa.private_key_pem
  sensitive = true
}

