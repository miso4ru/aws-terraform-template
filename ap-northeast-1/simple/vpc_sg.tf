################################
# simple
################################
resource "aws_security_group" "simple-common" {
  name        = "simple-common"
  description = "simple-common"
  vpc_id      = "${data.terraform_remote_state.ap-northeast-1.vpc_id}"

  tags {
    Name = "simple-common"
  }
}

resource "aws_security_group_rule" "simple-common_egress_all" {
  security_group_id = "${aws_security_group.simple-common.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "simple-common_ingress_self" {
  security_group_id = "${aws_security_group.simple-common.id}"
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  self              = true
}
