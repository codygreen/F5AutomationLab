#-------- setup/main.tf --------

terraform {
  backend "s3" {
    bucket = "cody-terraform"
    key    = "f5_automation_lab_setup/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

# create IAM users
resource "aws_iam_user" "automation_lab" {
  count         = "${var.number_students}"
  name          = "automation-user-${count.index}"
  path          = "/lab/"
  force_destroy = true
}

# create access key
resource "aws_iam_access_key" "automation_lab" {
  count   = "${aws_iam_user.automation_lab.count}"
  user    = "${aws_iam_user.automation_lab.*.name[count.index]}"
  pgp_key = "keybase:${var.keybase_user}"
}

# create login profile
resource "aws_iam_user_login_profile" "automation_lab" {
  count                   = "${aws_iam_user.automation_lab.count}"
  user                    = "${aws_iam_user.automation_lab.*.name[count.index]}"
  pgp_key                 = "keybase:${var.keybase_user}"
  password_reset_required = false
}

# add users to group
resource "aws_iam_group_membership" "automation_lab" {
  name  = "automation_lab_group_membership"
  group = "${aws_iam_group.automation_lab.name}"
  users = ["${aws_iam_user.automation_lab.*.name}"]
}

# create IAM group
resource "aws_iam_group" "automation_lab" {
  name = "f5_automation_lab"
}

data "aws_iam_policy" "AWSCloud9User" {
  arn = "arn:aws:iam::aws:policy/AWSCloud9User"
}

# attach policy to IAM group
resource "aws_iam_group_policy_attachment" "automation_lab_attach" {
  group      = "${aws_iam_group.automation_lab.name}"
  policy_arn = "${data.aws_iam_policy.AWSCloud9User.arn}"
}
