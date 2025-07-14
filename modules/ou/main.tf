data "aws_organizations_organization" "main" {}


resource "aws_organizations_organizational_unit" "parent_ou" {
  for_each  = var.organizational_units
  name      = each.key
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

locals {
  child_ous = merge([
    for parent, config in var.organizational_units : {
      for child in config.child_ous : 
      "${parent}-${child}" => {
        name       = child
        parent_key = parent
      }
    }
  ]...)
}

resource "aws_organizations_organizational_unit" "child_ou" {
  for_each  = local.child_ous

  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.parent_ou[each.value.parent_key].id
}
