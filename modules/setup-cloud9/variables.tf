#-------- setup-cloud9/variables.tf --------

variable "name" {}

variable "number_students" {}

variable "vpc_ids" {
  type = "list"
}

variable "student_arns" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}
