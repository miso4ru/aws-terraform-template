################################
# SSH
################################
# ec2-bastion
resource "aws_security_group" "ec2-bastion" {
  name        = "ec2-bastion"
  description = "ec2-bastion"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "ec2-bastion"
  }
}

resource "aws_security_group_rule" "ec2-bastion_egress_all" {
  security_group_id = "${aws_security_group.ec2-bastion.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2-bastion_ingress_22" {
  security_group_id = "${aws_security_group.ec2-bastion.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22

  cidr_blocks = [
    "${var.my_ip_addresses}",
  ]
}
