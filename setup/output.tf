#-------- setup/output.tf --------
output "secret" {
  value = "${module.setup-iam.secret}"
}

output "password" {
  value = "${module.setup-iam.password}"
}

output "test" {
  value = "${length(module.setup-iam.student_arns)}"
}
