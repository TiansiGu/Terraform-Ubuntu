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
In the root directory, create a key pair using Amazon EC2 (You need to have AWS CLI preinstalled):
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
You will see packer building logs. Once the process is completed, you will see outputs like the following:
![img.png](./screenshots/img.png)

You will be able to see the AMI with the Id specified in the packer build output in AWS Console:
![img_1.png](./screenshots/img_1.png)




## Use Terraform to provision AWS resources
Check if you already have terraform installed on your machine:
```
% terraform
```
If not, run the following commands to install packer:
```
% brew tap hashicorp/tap
% brew install hashicorp/tap/terraform
``` 
At terraform directory, run the following commands to provision AWS resources
```
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
```
After execution, you will see output like this for `terraform apply`:
![img_2.png](./screenshots/img_2.png)

Now you can check the resources terraform just created on your AWS console:
#### VPC
![img_3.png](./screenshots/img_3.png)

Public subnets are connected to the internet through IGW (Internet Gateway, created together with VPC).
![img_4.png](./screenshots/img_4.png)
![img_5.png](./screenshots/img_5.png)
Private subnets can connect to outside through NGW (NAT Gateway, created together with VPC).
![img_6.png](./screenshots/img_6.png)
![img_7.png](./screenshots/img_7.png)
IGW, NGW, and Elastic IP associated to the NGW allocated through the creation of VPC:
![img_8.png](./screenshots/img_8.png)
![img_9.png](./screenshots/img_9.png)
![img_10.png](./screenshots/img_10.png)

You can use the private key file to ssh into this EC2 as the public key has been pre-configured in the AMI, and thus pre-set in the EC2


Run some docker commands to verify docker is ready to use:
