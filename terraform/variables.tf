variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Default region."
}

variable "public_key" {
  type        = string
  default     = "ami-key-pair"
  description = "The public key to access your bastion server"
}

variable "bastion_prefix"{
  type        = string
  default     = "bastion"
  description = "Bastion prefix for the bastion resources"
}

variable "vpc_name"{
  type        = string
  default     = "IaC-vpc"
  description = "The name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR for the VPC"
}

variable "aws_azs" {
  description = "List of az in the specified region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_private_subnet_cidr" {
  description = "List of internal CIDR ranges for the private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "aws_public_subnet_cidr" {
  description = "List of internal CIDR ranges for the public subnet"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "ec2_ami" {
  description = "AMI used to launch ec2 instances in the private subnet"
  type        = string
  default     = "ami-0c683bc83548aa978"
}

variable "resource_tags" {
  type = object({
    PROJECT = string
    ENV  = string
  })
  default = {
    PROJECT = "Terraform"
    ENV  = "QA"
  }
}
