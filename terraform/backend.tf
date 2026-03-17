terraform {
  backend "s3" {
    bucket  = "<terraform-state-bucket>"
    key     = "jenkins-pipeline/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
