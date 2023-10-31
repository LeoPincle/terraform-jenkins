terraform {
  backend "s3" {
    bucket = "project-ci-12-terraform-state"
    key    = "backend/project-jenkins.tfstate"
    region = "us-east-2"
    dynamodb_table = "project-jenkins-table"
  }
}
