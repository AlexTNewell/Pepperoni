##################### Output Setup Server EC2 Instance ID #####################

output "instance_id" {
  value = aws_instance.setup_server.id
}
