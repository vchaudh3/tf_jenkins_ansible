resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-vchaudh3"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

