terraform {
  required_version = "> 0.10.0"

  backend "s3" {
    bucket = "my-terraform-state"
    key    = "ap-northeast-1/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
