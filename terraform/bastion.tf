
data "aws_ami" "al2923_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.6*-x86_64"] //amazon_linux_2023 version
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.al2923_image.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0] //the first public subnet id in the list
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]
  key_name = var.public_key
  associate_public_ip_address = true

  tags = merge(
    var.resource_tags,
    { Name = "BastionHost-${var.resource_tags.PROJECT}-${var.resource_tags.ENV}" }
  )
}

