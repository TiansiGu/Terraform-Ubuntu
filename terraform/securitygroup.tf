resource "aws_security_group" "bastion-allow-ssh" {
  vpc_id      = module.vpc.vpc_id
  name        = "bastion-allow-ssh"
  description = "security group for bastion that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" //allow all outbound protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //Todo: change to my ip address
  }

  tags = merge(
    var.resource_tags, { Name = "bastion-allow-ssh" }
  )
}

resource "aws_security_group" "private-ssh" {
  vpc_id      = module.vpc.vpc_id
  name        = "private-ssh"
  description = "security group for private subnet instances that allows ssh from the bastion host security group and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [ aws_security_group.bastion-allow-ssh.id ]
  }

  tags = merge(
    var.resource_tags,
    { Name = "private-ssh" }
  )
}
