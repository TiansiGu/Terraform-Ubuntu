resource "aws_instance" "ec2" {
  count         = 6
  ami           = var.ec2_ami
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnets[0] //the first private subnet id in the list
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = merge(
    var.resource_tags,
    { Name = "custom-ec2-${format("%02d", count.index + 1)}" } //ec2-instance-01, ec2-instance-02, ...
  )
}