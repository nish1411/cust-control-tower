data "template_file" "controltower_manifest" {
  template = file("${path.module}/manifest.json")
  vars = {
    log_archive_account_id = aws_organizations_account.log_archive.id
    audit_account_id       = aws_organizations_account.audit.id
    security_ou_id         = aws_organizations_organizational_unit.security_ou.id
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

resource "aws_organizations_organizational_unit" "security_ou" {
  name      = "Security-OU"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

output "log_archive_account_id" {
  value = aws_organizations_account.log_archive.id
}

output "audit_account_id" {
  value = aws_organizations_account.audit.id
}

output "security_ou" {
  value = aws_organizations_organizational_unit.security_ou.id
}