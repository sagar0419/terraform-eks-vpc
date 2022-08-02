##Remote Backend
terraform {
  backend "s3" {
    bucket = "terraform-backup-sagar"
    region = "us-west-2"
    key    = "terraform.tfstate"
  }
}