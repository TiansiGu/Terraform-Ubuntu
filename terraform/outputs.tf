# Custom EC2 instances Public DNS
output "ec2_public_dns" {
  description = "Public DNS of the EC2 instances"
  value = [for i in aws_instance.ec2 : i.public_dns]  //loop through all created instances to get their private DNS
}