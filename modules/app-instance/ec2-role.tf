resource "aws_iam_role" "InstanceCoreRole" {
  name = "InstanceCoreRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        },
    ]
  }
  )
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role = aws_iam_role.InstanceCoreRole.name
    policy_arn = aws_iam_policy.ec2_policy.arn  
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.InstanceCoreRole.name
}