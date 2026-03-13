output "ec2_public_ip" {
    value = aws_instance.test.public_ip
}
# output value for consumption by another module or human interacting via the UI

output "ec2_public_dns" {
    value = aws_instance.test.public_dns
}

output "ec2_private_ip" {
    value = aws_instance.test
  
}
