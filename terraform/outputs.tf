output "instance_id" {
  value = aws_instance.web_server.id
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "private_key_pem" {
  value     = tls_private_key.demo_key.private_key_pem
  sensitive = true
}
