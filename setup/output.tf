#-------- setup/output.tf --------
output "secret" {
  value = "${module.setup-iam.secret}"
}

output "password" {
  value = "${module.setup-iam.password}"
}

output "number_students" {
  value = "${length(module.setup-iam.student_arns)}"
}
