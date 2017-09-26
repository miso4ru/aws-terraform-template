################################
# IAM Role Bastion
################################
# ec2-bastion
resource "aws_iam_role" "ec2-bastion" {
    name = "ec2-bastion"
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

resource "aws_iam_instance_profile" "ec2-bastion" {
    name = "ec2-bastion"
    role = "${aws_iam_role.ec2-bastion.name}"
}

resource "aws_iam_role_policy_attachment" "ec2-bastion-ro" {
    role = "${aws_iam_role.ec2-bastion.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-bastion-ssm" {
    role = "${aws_iam_role.ec2-bastion.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

################################
# IAM Role AMI Build
################################
# ami builder
resource "aws_iam_role" "ami-build" {
    name = "ami-build"
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

resource "aws_iam_instance_profile" "ami-build" {
    name = "ami-build"
    role = "${aws_iam_role.ami-build.name}"
}

resource "aws_iam_role_policy_attachment" "ami-build-ro" {
    role = "${aws_iam_role.ami-build.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ami-build-ssm" {
    role = "${aws_iam_role.ami-build.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


################################
# IAM Role Dev EC2
################################
resource "aws_iam_role" "ec2-dev" {
    name = "ec2-dev"
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

resource "aws_iam_instance_profile" "ec2-dev" {
    name = "ec2-dev"
    role = "${aws_iam_role.ec2-dev.name}"
}

resource "aws_iam_role_policy_attachment" "ec2-dev-ro" {
    role = "${aws_iam_role.ec2-dev.name}"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ec2-dev-ssm" {
    role = "${aws_iam_role.ec2-dev.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
