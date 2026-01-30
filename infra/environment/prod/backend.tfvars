    bucket         = "devopschallenge-tfstate-bucket"
    key            = "prod/eks-cluster/terraform.tfstate"      
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state"
    encrypt        = true