module "ou" {
 source                 = "../modules/ou"
 organizational_units   = var.organizational_units
}


module "accounts" {
  for_each          = { for acc in var.accounts : "${acc.account_name}" => acc }
  source            = "../modules/account"
  account_name      = each.value.account_name
  account_email     = each.value.account_email
  ou_name           = each.value.ou_name
}

