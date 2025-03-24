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
![img_2.2.png](./screenshots/img_2.2.png)

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

#### EC2
All the ec2 instances launched:
![img_11.png](./screenshots/img_11.png)
##### Bastion Host
Bastion Host locates in a public subnet, and was created with the newest official AMI of Amazon Linux 2023 (provided by Amazon)
![img_12.png](./screenshots/img_12.png)
![img_13.png](./screenshots/img_13.png)

Out of security, the Bastion Host only allows inbounding SSH traffic from your IP address
![img_19.png](./screenshots/img_19.png)
You can verify your IP address by running `curl -s https://api.ipify.org `:
![img_20.png](./screenshots/img_20.png)

##### Custom EC2
Bastion Host locates in a private subnet, and was created with your new AMI created from Packer
![img_14.png](./screenshots/img_14.png)
![img_15.png](./screenshots/img_15.png)

All the custom ec2 instances only allows inbounding SSH traffic from the Bastion Host
![img_21.png](./screenshots/img_21.png)
![img_22.png](./screenshots/img_22.png)

## SSH into Private EC2 via Bastion Host
To get the public DNS of the bastion host and the private DNS of the custom ec2 you want to ssh into, you can either find them in AWS console,
or run in terraform directory:
```
terraform output
```
Example output:
![img_16.png](./screenshots/img_16.png)

Add the key in the root directory into SSH agent:
```
% ssh-add ami-key-pair.pem
```
SSH into the bastion host with agent forwarding:
```
% ssh -A -i ami-key-pair.pem ec2-user@[your-bastion-host-public-ipv4-dns]
```
Once you are inside the bastion host, SSH into your custom ec2 instance in the private subnet
```
% ssh ec2-user@[your-custom-ec2-private-ipv4-dns]
```
Example output:
![img_17.png](./screenshots/img_17.png)
In ec2.tf, no key-pair is associated to the ec2 instance. However, you can still use the private key file to ssh into this EC2 as the public key has been pre-configured in the custom AMI, and thus was pre-set in the ec2

Run some docker commands to verify docker is ready to use:
![img_18.png](./screenshots/img_18.png)