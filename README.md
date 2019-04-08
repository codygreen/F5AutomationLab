# F5AutomationLab
Hands-on lab focused on automating F5 BIG-IP in AWS using Terraform and Ansible

# Setup
This lab is setup so the students will use AWS Cloud9 for all tasks.  

Requirements:
 - You'll need to have Terraform installed 
 - You'll need to install and setup a PGP key with keybase.io

To get started you'll need to create the required IAM users and roles for the student accounts.

Update the terraform variable file with the desired number of users.  Then run the following commands:
```
cd setup
terraform init
terraform apply --auto-approve
```
You can decrypt the password using:
```
terraform output password | base64 --decode | keybase pgp decrypt