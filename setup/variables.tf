#-------- setup/variables.tf --------
variable "name" {
  default = "automation_lab"
}

variable "number_students" {
  description = "Desired number of student lab accounts to create"
  default     = 2
}

variable "aws_region" {
  default = "us-east-2"
}

variable "keybase_user" {}
