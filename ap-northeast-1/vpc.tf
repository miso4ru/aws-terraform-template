################################
# VPC
################################
resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr["ap-northeast-1"]}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.project_code}-main"
  }
}

variable "zones" {
  type = "list"

  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
  ]
}

################################
# Subnet
################################
resource "aws_subnet" "public" {
  count                   = "${length(var.zones)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.cidr["ap-northeast-1"], 7, 0*length(var.zones) + count.index)}"
  availability_zone       = "${element(var.zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.project_code}-public-${substr(element(var.zones, count.index),-1,1)}"
  }
}

resource "aws_subnet" "private" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr["ap-northeast-1"], 7, 1*length(var.zones) + count.index)}"
  availability_zone = "${element(var.zones, count.index)}"

  tags {
    Name = "${var.project_code}-private-${substr(element(var.zones, count.index),-1,1)}"
  }
}

resource "aws_subnet" "protected" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr["ap-northeast-1"], 7, 2*length(var.zones) + count.index)}"
  availability_zone = "${element(var.zones, count.index)}"

  tags {
    Name = "${var.project_code}-protected-${substr(element(var.zones, count.index),-1,1)}"
  }
}

resource "aws_subnet" "lb" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr["ap-northeast-1"], 9, 40 + 0*length(var.zones) + count.index)}"
  availability_zone = "${element(var.zones, count.index)}"

  tags {
    Name = "${var.project_code}-lb-${substr(element(var.zones, count.index),-1,1)}"
  }
}

resource "aws_subnet" "nat" {
  count             = "${length(var.zones)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(var.cidr["ap-northeast-1"], 9, 40 + 1*length(var.zones) + count.index)}"
  availability_zone = "${element(var.zones, count.index)}"

  tags {
    Name = "${var.project_code}-nat-${substr(element(var.zones, count.index),-1,1)}"
  }
}
