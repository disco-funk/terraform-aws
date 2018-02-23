provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "cluster_config" {
  bucket = "phud_terraform"
  acl = "private"
  tags {
    Name = "Phil Hudson Terraform"
  }
  versioning {
    enabled = true
  }
  force_destroy = true
}

resource "aws_iam_user" "kops-user" {
  name = "kops-user"
}

resource "aws_iam_group" "kops-group" {
  name = "kops-group"
}

resource "aws_iam_policy_attachment" "kops-ec2attach" {
  name = "kops-ec2attach"
  groups = ["${aws_iam_group.kops-group.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "kops-s3" {
  name = "kops-s3"
  groups = ["${aws_iam_group.kops-group.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "kops-iam" {
  name = "kops-iam"
  groups = ["${aws_iam_group.kops-group.name}"]
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_policy_attachment" "kops-vpc" {
  name = "kops-vpc"
  groups = ["${aws_iam_group.kops-group.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_membership" "kops-iam-group-membership" {
  name = "kops-iam-group-membership"
  group = "${aws_iam_group.kops-group.name}"
  users = ["${aws_iam_user.kops-user.name}"]
}

resource "aws_iam_access_key" "kops-key" {
  user = "${aws_iam_user.kops-user.name}"
}