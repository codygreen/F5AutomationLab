#-------- setup-networking/output.tf --------

output "vpc_ids" {
  value = "${aws_vpc.setup_vpc.*.id}"
}

output "subnet_ids" {
  value = "${aws_subnet.setup_public_subnet.*.id}"

  # value = "${element(concat(aws_subnet.setup_public_subnet.*.id, list("")), 0)}"
}
