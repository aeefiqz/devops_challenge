resource "aws_s3_bucket" "terraform-state" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = true
  }
}


