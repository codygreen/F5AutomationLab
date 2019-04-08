#-------- setup/output.tf --------
output "secret" {
  value = "${aws_iam_access_key.automation_lab.*.encrypted_secret}"
}

output "password" {
  value = "${aws_iam_user_login_profile.automation_lab.*.encrypted_password}"
}
