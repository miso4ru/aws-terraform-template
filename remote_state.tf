data "terraform_remote_state" "ap-northeast-1" {
  backend = "s3"
  config {
    bucket = "my-terraform-state"
    key    = "ap-northeast-1/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

#data "terraform_remote_state" "us-east-2" {
#  backend = "s3"
#  config {
#    bucket = "my-terraform-state"
#    key    = "us-east-2/terraform.tfstate"
#    region = "ap-northeast-1"
#  }
#}
