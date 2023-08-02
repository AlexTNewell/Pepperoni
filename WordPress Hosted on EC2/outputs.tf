output "public_key" {
  value = tls_private_key.example.public_key_pem
}

output "private_key" {
  value = tls_private_key.example.private_key_pem
}
