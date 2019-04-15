#-------- lab1/main.tf --------

provider "aws" {
  region = "${var.aws_region}"
}

# get networking components
data aws_vpc "udf" {
  cidr_block = "${var.vpc_cidr}"
}

data "aws_subnet_ids" "udf" {
  vpc_id = "${data.aws_vpc.udf.id}"
}

# # create compute resource
module compute {
  source = "../../../modules/compute"

  subnet_id      = "${data.aws_subnet_ids.udf.ids[0]}"
  instance_count = 2
}
