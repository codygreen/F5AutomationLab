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
You can decrypt the password using either:
```
terraform output password | base64 --decode | keybase pgp decrypt

terraform output --json password | jq -r '.value[0]' | base64 --decode | keybase pgp decrypt
```

To loop through all the password variables for lab students run the following command:
```
for i in $(seq 1 `terraform output number_students`);
do
  terraform output --json password | jq -r '.value[`$i`]' | base64 --decode | keybase pgp decrypt
done
```

You can access your Cloud9 IDE via https://us-east-2.console.aws.amazon.com/cloud9/home?region=us-east-2

