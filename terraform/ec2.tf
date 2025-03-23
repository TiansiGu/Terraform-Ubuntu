data "aws_ami" "ec2_image" {
  most_recent = true
  owners      = ["self"] //check your own AMIs
  filter {
    name = "name"
    values = ["amazon-linux-2023-with-docker*"] //custom AMI with docker and ssh key set up
  }
}

resource "aws_instance" "ec2" {
  count         = 6
  ami           = data.aws_ami.ec2_image.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnets[0] //the first private subnet id in the list
  vpc_security_group_ids = [aws_security_group.private-ssh.id]

  tags = merge(
    var.resource_tags,
    { Name = "custom-ec2-${format("%02d", count.index + 1)}" } //ec2-instance-01, ec2-instance-02, ...
  )
}