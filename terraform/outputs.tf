# Bastion Host Public DNS
output "bastion_public_dns" {
  description = "Public DNS of the bastion host instance"
  value       = aws_instance.bastion.public_dns
}

# Custom EC2 instances Private DNS
output "ec2_private_dns" {
  description = "Private DNS of the EC2 instances"
  value = [for i in aws_instance.ec2 : i.private_dns]  //loop through all created instances to get their private DNS
}