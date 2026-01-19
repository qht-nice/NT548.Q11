# VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}

# Enable VPC Flow Logs (Checkov: CKV2_AWS_11)
data "aws_iam_policy_document" "vpc_flow_logs_kms_policy" {
  #checkov:skip=CKV_AWS_109: KMS key policies commonly require broad admin permissions for account root
  #checkov:skip=CKV_AWS_111: KMS key policies commonly allow write actions for account root
  #checkov:skip=CKV_AWS_356: KMS key policy resources are typically "*" by design in key policies
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "vpc_flow_logs_kms" {
  description         = "KMS key for VPC Flow Logs CloudWatch Log Group"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.vpc_flow_logs_kms_policy.json
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "/aws/vpc/${aws_vpc.vpc.id}/flow-logs"
  # Checkov: CKV_AWS_338 (>= 1 year)
  retention_in_days = 365
  # Checkov: CKV_AWS_158 (encrypt log group)
  kms_key_id = aws_kms_key.vpc_flow_logs_kms.arn
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "vpc-flow-logs-role-${aws_vpc.vpc.id}"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json
}

data "aws_iam_policy_document" "vpc_flow_logs_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name   = "vpc-flow-logs-policy"
  role   = aws_iam_role.vpc_flow_logs_role.id
  policy = data.aws_iam_policy_document.vpc_flow_logs_policy.json
}

resource "aws_flow_log" "vpc_flow_logs" {
  vpc_id               = aws_vpc.vpc.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
}
# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_public_subnet

  tags = {
    Name = "Public_subnet"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_private_subnet

  tags = {
    Name = "Private_subnet"
  }
}
#Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_gateway"
  }
}


#Default security group
resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id

  # Restrict all traffic on the default SG (Checkov: CKV2_AWS_12)
  ingress = []
  egress  = []

  revoke_rules_on_delete = true
  tags = {
    name = "Default_security_group"
  }
}

#Route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "public_subnet_rt-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}