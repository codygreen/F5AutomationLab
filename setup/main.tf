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

# create IAM users, group and roles
module "setup-iam" {
  source = "../modules/setup-iam"

  number_students = "${var.number_students}"
  keybase_user    = "${var.keybase_user}"
}

# create networking components 
module "setup-networking" {
  source = "../modules/setup-networking"

  name            = "${var.name}"
  number_students = "${var.number_students}"
  student_arns    = "${module.setup-iam.student_arns}"
}

# # create Cloud9 instances
# module "setup-cloud9" {
#   source = "../modules/setup-cloud9"


#   name            = "${var.name}"
#   number_students = "${var.number_students}"
#   vpc_ids         = "${module.setup-networking.vpc_ids}"
#   student_arns    = "${module.setup-iam.student_arns}"
#   subnet_ids      = "${module.setup-networking.subnet_ids}"
# }

