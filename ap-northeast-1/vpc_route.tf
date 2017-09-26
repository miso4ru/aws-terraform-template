################################
# Gateway
################################
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project_code}-main"
  }
}

################################
# Main RouteTable
################################
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.project_code}-main"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

################################
# PrivateTable
################################
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project_code}-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.zones)}"
  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
}

################################
# ProtectedTable
################################
resource "aws_route_table" "protected" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.project_code}-protected"
  }
}

resource "aws_route_table_association" "protected" {
  count          = "${length(var.zones)}"
  route_table_id = "${aws_route_table.protected.id}"
  subnet_id      = "${element(aws_subnet.protected.*.id, count.index)}"
}
