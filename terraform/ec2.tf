data "aws_ami" "ec2_image" {
  most_recent = true
  owners      = ["self"] //check your own AMIs
  filter {
    name = "name"
    values = ["amazon-ubuntu-with-docker*"] //custom AMI with docker and ssh key set up
  }
}

resource "aws_instance" "ec2" {
  count         = 5
  ami           = data.aws_ami.ec2_image.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0] //the first public subnet id in the list
  vpc_security_group_ids = [aws_security_group.public-ssh.id]
  associate_public_ip_address = true
  key_name = var.public_key

  tags = merge(
    var.resource_tags,
    { Name = (
      count.index < 3 ? "manager-${count.index + 1}" : "worker-${count.index - 2}"
    ) }
  )
}