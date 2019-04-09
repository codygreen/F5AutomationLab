#-------- setup-networking/main.tf --------

# Get availability zones
data "aws_availability_zones" "available" {}

# Get My Public IP
data "http" "myIP" {
  url = "http://ipv4.icanhazip.com"
}

# create required VPC
resource "aws_vpc" "setup_vpc" {
  count                = "${var.number_students}"
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.name}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "setup_ig" {
  count  = "${aws_vpc.setup_vpc.count}"
  vpc_id = "${aws_vpc.setup_vpc.*.id[count.index]}"

  tags {
    Name = "${var.name}_igw_${count.index}"
  }
}

# Create Public Route Table
resource "aws_route_table" "setup_public_rt" {
  count  = "${aws_vpc.setup_vpc.count}"
  vpc_id = "${aws_vpc.setup_vpc.*.id[count.index]}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.setup_ig.*.id[count.index]}"
  }

  tags {
    Name = "${var.name}_public_rt_${count.index}"
  }

  depends_on = ["aws_internet_gateway.setup_ig"]
}

# Create Default Route Table
resource "aws_default_route_table" "setup_private_rt" {
  count                  = "${aws_vpc.setup_vpc.count}"
  default_route_table_id = "${aws_vpc.setup_vpc.*.default_route_table_id[count.index]}"

  tags {
    Name = "${var.name}_private_rt_${count.index}"
  }
}

# Create Public Subnet
resource "aws_subnet" "setup_public_subnet" {
  count                   = "${aws_vpc.setup_vpc.count}"
  vpc_id                  = "${aws_vpc.setup_vpc.*.id[count.index]}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.name}_public_subnet_${count.index + 1}"
  }
}

# Associate Subnet to Route Table
resource "aws_route_table_association" "setup_public_assoc" {
  count          = "${aws_subnet.setup_public_subnet.count}"
  subnet_id      = "${aws_subnet.setup_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.setup_public_rt.*.id[count.index]}"
}

# Create Security Group
resource "aws_security_group" "f5_demo_sg" {
  count       = "${aws_vpc.setup_vpc.count}"
  vpc_id      = "${aws_vpc.setup_vpc.*.id[count.index]}"
  description = "F5 BIG-IP Terraform Demo Security Group"

  # MGMT UI
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myIP.body)}/32"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myIP.body)}/32"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
