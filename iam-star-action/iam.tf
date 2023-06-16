resource "aws_iam_policy" "policy_pass" {
  name = "policy_pass"
  path = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "s3:*",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "42739aa4-91d2-4771-9247-19af6745f150"
  }
}

resource "aws_iam_policy" "policy_fail" {
  name = "policy_fail"
  path = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "*",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
  tags = {
    yor_trace = "033b8617-bad4-4b8b-935b-dd34b5fd0c52"
  }
}

# Test IAM Policy document data type - pass
data "aws_iam_policy_document" "pass1" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  # Allow IAM Permissions
  statement {
    effect = "Allow"
    actions = [
      "iam:AttachUserPolicy",
    ]

    resources = [
      "arn:aws:iam:::/home/&{aws:username}",
      "arn:aws:iam:::/home/&{aws:username}/*",
    ]
  }
}

# Test IAM Policy document data type - fail
data "aws_iam_policy_document" "fail" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "*",
      "s3:PutBucketPolicy",
      "s3:PutBucketAcl",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  # Allow IAM Permissions
  statement {
    actions = [
      "iam:AttachUserPolicy",
    ]

    resources = [
      "arn:aws:iam:::/home/&{aws:username}",
      "arn:aws:iam:::/home/&{aws:username}/*",
    ]
  }
}