terraform {
  backend "s3" {
    bucket  = "dla-tstate"
    key     = "jenkins-pipeline/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
