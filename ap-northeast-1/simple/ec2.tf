################################
# Launch instance
################################

resource "aws_eip" "simple-web-1" {
    vpc = true
}


data "aws_ami" "amzn-ami-hvm" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn-ami-hvm-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
  #name_regex = "^(?!.*(.rc-)).+$"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.simple-web.0.id}"
  allocation_id = "${aws_eip.simple-web-1.id}"
}

resource "aws_instance" "simple-web" {
    ## hvm
    instance_type = "t2.micro"
    ami = "${data.aws_ami.amzn-ami-hvm.id}"

    subnet_id = "${data.terraform_remote_state.ap-northeast-1.vpc_subnet["public-a"]}"
    vpc_security_group_ids = [
        "${aws_security_group.simple-common.id}",
        "${data.terraform_remote_state.ap-northeast-1.vpc_sg["ec2-bastion"]}",
    ]
    key_name = "${var.key_pair["ap-northeast-1"]}"
    iam_instance_profile = "${aws_iam_instance_profile.ec2-simple.name}"
    tags = {
        Name = "${var.project_code}-${format("simple-web-%02d", count.index)}"
        Roles = "web"
        Environment = "simple"
        auto_stop = "enable"
        amirotate = "{\"no_reboot\":true,\"retention_period\":170000}"
    }
   count = 1
}

resource "aws_iam_role" "ec2-simple" {
  name = "${var.project_code}-ec2-simple"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-simple-ro" {
  role       = "${aws_iam_role.ec2-simple.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2-simple" {
  name = "${var.project_code}-ec2-simple"
  role = "${aws_iam_role.ec2-simple.name}"
}
