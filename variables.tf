variable "cidr" {
  type = "map"

  default = {
    ap-northeast-1 = "10.0.0.0/16"
    us-west-2      = "10.1.0.0/16"
    us-east-2      = "10.2.0.0/16"
  }
}

variable "project_code" {
  type    = "string"
  default = "mypj"
}

variable "my_ip_addresses" {
  type = "list"

  default = [
    "xxx.xxx.xxx.xxx/32",
  ]
}

variable "key_pair" {
  type = "map"

  default = {
    ap-northeast-1 = "my-key-ap-northeast-1"
    #us-east-2      = "my-key-us-east-2"
  }
}

variable "ami_id" {
  type = "map"

  default = {
    ap-northeast-1 = "" # Base AMI build by Packer
    #us-east-2 = ""     # Base AMI build by Packer
  }
}

variable "log_bucket" {
  type    = "string"
  default = "my-aws-logs"
}
