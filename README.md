# Packer-Terraform
Clone this repo to your local machine.

## Configure AWS Credentials
Get your AWS credentials from AWS Academy and export them as environment variables:
```
% export AWS_ACCESS_KEY_ID="your aws_access_key_id"
% export AWS_SECRET_ACCESS_KEY="your aws_secret_access_key"
% export AWS_SESSION_TOKEN="your aws_session_token"
```

## Create a custom AWS AMI using Packer 
Check if you already have packer installed on your machine:
```
% packer
```
If not, run the following commands to install packer:
```
% brew tap hashicorp/tap
% brew install hashicorp/tap/packer
``` 
Install Amazon plugin on packer: 
```
% packer plugins install github.com/hashicorp/amazon
```
In the **root directory**, create a key pair using Amazon EC2 (You need to have AWS CLI preinstalled):
```
% aws ec2 create-key-pair \
    --key-name ami-key-pair \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ami-key-pair.pem
```
You can also name the key pair on your preference. But be sure to change the value of "ssh_keypair_name" and "ami-key-pair" in aws-ami-docker.json if you do so.

For future connection to ec2 instances launched by the custom AMI, run the following command to set the permissions of your private key file:
```
% chmod 400 ami-key-pair.pem
```
Note: It is not recommended to change the path of the private key file, because packer config file use the specific location for image creation.
If you move it, be sure to update the path in aws-ami-docker.json at the same time.

Create a custom AMI with **docker** and **ssh public key** set up:
```
% cd packer
% packer build aws-ami-docker.json  
```

## Use Terraform to provision AWS resources
Check if you already have terraform installed on your machine:
```
% terraform
```
If not, run the following commands to install packer:
```
% brew install hashicorp/tap/terraform
``` 
At terraform directory, run the following commands to provision AWS resources
```
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
```

## SSH into Ubuntu EC2
To get the public DNS of the ec2 instances, you can either find them in AWS console,
or run the following command in terraform directory:
```
terraform output
```
Example output:
```
ec2_public_dns = [
  "ec2-18-234-185-106.compute-1.amazonaws.com",
  "ec2-54-205-91-132.compute-1.amazonaws.com",
  "ec2-52-207-209-190.compute-1.amazonaws.com",
  "ec2-44-201-83-118.compute-1.amazonaws.com",
  "ec2-44-211-144-155.compute-1.amazonaws.com",
]
```

Add the key in the root directory into SSH agent:
```
% ssh-add ami-key-pair.pem
```
SSH into the ec2 instances with agent forwarding:
```
% ssh -i ami-key-pair.pem ubuntu@[your-ec2-public-ipv4-dns]
```

Run some docker commands to verify docker is ready to use:
```
docker ps
```
