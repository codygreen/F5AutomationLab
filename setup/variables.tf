#-------- setup/variables.tf --------
variable "number_students" {
  description = "Desired number of student lab accounts to create"
  default     = 1
}

variable "aws_region" {
  default = "us-east-2"
}

variable "keybase_user" {}
