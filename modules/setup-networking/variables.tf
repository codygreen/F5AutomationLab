#-------- setup-networking/variables.tf --------

variable "name" {}

variable "number_students" {}

variable "student_arns" {
  type = "list"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
