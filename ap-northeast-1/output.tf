# vpc id
output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

# subnet id
output "vpc_subnet" {
  value = "${
        map(
            "public-a", element(aws_subnet.public.*.id, index(var.zones, "ap-northeast-1a")),
            "public-c", element(aws_subnet.public.*.id, index(var.zones, "ap-northeast-1c")),

            "private-a", element(aws_subnet.private.*.id, index(var.zones, "ap-northeast-1a")),
            "private-c", element(aws_subnet.private.*.id, index(var.zones, "ap-northeast-1c")),

            "protected-a", element(aws_subnet.protected.*.id, index(var.zones, "ap-northeast-1a")),
            "protected-c", element(aws_subnet.protected.*.id, index(var.zones, "ap-northeast-1c")),

            "lb-a", element(aws_subnet.lb.*.id, index(var.zones, "ap-northeast-1a")),
            "lb-c", element(aws_subnet.lb.*.id, index(var.zones, "ap-northeast-1c")),

            "nat-a", element(aws_subnet.nat.*.id, index(var.zones, "ap-northeast-1a")),
            "nat-c", element(aws_subnet.nat.*.id, index(var.zones, "ap-northeast-1c")),
        )}"
}

# security group
output "vpc_sg" {
  value = "${
        map(
            "ec2-bastion", aws_security_group.ec2-bastion.id,
        )}"
}
