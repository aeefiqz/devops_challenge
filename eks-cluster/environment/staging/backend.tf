terraform {
  backend "s3" {
    bucket         = "devopschallenge-tfstate-bucket"
    key            = "staging/eks-cluster/terraform.tfstate"      
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state"
    encrypt        = true
  }
}
