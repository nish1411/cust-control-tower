data "template_file" "controltower_manifest" {
  template = file("${path.module}/manifest.json")
  vars = {
    log_archive_account_id = aws_organizations_account.log_archive.id
    audit_account_id       = aws_organizations_account.audit.id
    security_ou_name       = "Security-OU"
  }
}

resource "aws_controltower_landing_zone" "example" {
  manifest_json = data.template_file.controltower_manifest.rendered
  version       = "3.3"
}

data "aws_organizations_organization" "main" {}

resource "aws_organizations_account" "log_archive" {
  name      = "Log Archive"
  email     = "aws2.log@the-afc.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_account" "audit" {
  name      = "Security"
  email     = "aws2.audit@the-afc.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

output "log_archive_account_id" {
  value = aws_organizations_account.log_archive.id
}

output "audit_account_id" {
  value = aws_organizations_account.audit.id
}

resource "aws_iam_policy" "controltower_admin_policy" {
  name        = "AWSControlTowerAdminPolicy"
  description = "AWSControlTowerAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect   = "Allow",
        Action   = "ec2:DescribeAvailabilityZones",
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role" "ctl_admin" {
  name = "AWSControlTowerAdmin"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "controltower.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "ctl_admin_policy_attach" {
  role       = aws_iam_role.ctl_admin.name
  policy_arn = aws_iam_policy.controltower_admin_policy.arn
}


resource "aws_iam_role_policy_attachment" "ctl_service_policy_attach" {
  role       = aws_iam_role.ctl_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
}


resource "aws_iam_policy" "controltower_cloudtrail_policy" {
  name        = "AWSControlTowerCloudTrailRolePolicy"
  description = "AWSControlTowerCloudTrailRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [
        {
            "Action": "logs:CreateLogStream",
            "Resource": "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*",
            "Effect": "Allow"
        },
        {
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:aws-controltower/CloudTrailLogs:*",
            "Effect": "Allow"
        }
    ]
  })
}

resource "aws_iam_role" "cloudtrail" {
  name = "AWSControlTowerCloudTrailRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ctl_cloudtrail_policy_attach" {
  role       = aws_iam_role.cloudtrail.name
  policy_arn = aws_iam_policy.controltower_cloudtrail_policy.arn
}

resource "aws_iam_role" "configrole" {
  name = "AWSControlTowerConfigAggregatorRoleForOrganizations"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ctl_configrole_policy_attach" {
  role       = aws_iam_role.configrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_iam_policy" "controltower_stacksetrole_policy" {
  name        = "AWSControlTowerStackSetRolePolicy"
  description = "AWSControlTowerStackSetRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/AWSControlTowerExecution"
            ],
            "Effect": "Allow"
        }
    ]
  })
}

resource "aws_iam_role" "stacksetrole" {
  name = "AWSControlTowerStackSetRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudformation.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ctl_stacksetrole_policy_attach" {
  role       = aws_iam_role.stacksetrole.name
  policy_arn = aws_iam_policy.controltower_stacksetrole_policy.arn
}
