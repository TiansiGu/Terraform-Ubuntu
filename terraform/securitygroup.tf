data "http" "my_ip" {
  url = "https://api.ipify.org?format=text" // fetch your ip address
}

resource "aws_security_group" "public-ssh" {
  vpc_id      = module.vpc.vpc_id
  name        = "public-ssh"
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
    cidr_blocks = ["${data.http.my_ip.response_body}/32"]
  }

  # Cluster management communications (TCP port 2377)
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    self = true
  }

  # Communication among nodes (TCP and UDP port 7946)
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self = true
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self = true
  }

  # Overlay network traffic (UDP port 4789)
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self = true
  }

  tags = merge(
    var.resource_tags, { Name = "public-ssh" }
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
    security_groups = [ aws_security_group.public-ssh.id ]
  }

  tags = merge(
    var.resource_tags,
    { Name = "private-ssh" }
  )
}
