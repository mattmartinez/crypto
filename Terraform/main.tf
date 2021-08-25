terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.7.0"
  }
}

resource "aws_iam_role" "prod-ci_role" {
  name = "prod-ci_role"
  assume_role_policy = data.aws_iam_policy_document.json
}

data "aws_iam_policy_document" "prod-ci-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::1234567890123:root"]
    }
  }
}

resource "aws_iam_group" "prod-ci-group" {
  name "engineers"
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group = aws_iam_group.name
  policy_arn = aws_iam_policy.prod-ci-policy.arn
}

resource "aws_iam_user" "prod-ci-user" {
  name = "MattM"
}

resource "aws_iam_user_group_membership" "prod-ci-users" {
  user = aws_iam_user.prod-ci-user.name
  groups = [
    aws_iam_group.prod-ci-group.name,
  ]
}
