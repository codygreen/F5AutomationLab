#-------- setup-cloud9/main.tf --------

resource "aws_cloud9_environment_ec2" "cloud9" {
  count                       = "${var.number_students}"
  instance_type               = "t2.micro"
  name                        = "${var.name}-cloud9-env-${count.index}"
  automatic_stop_time_minutes = 120
  owner_arn                   = "${var.student_arns[count.index]}"
  subnet_id                   = "${var.subnet_ids[count.index]}"
}
