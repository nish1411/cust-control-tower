variable "organizational_units" {
  type = map(object({
    child_ous = optional(list(string), [])
  }))
  default     = {}
  description = "organizational_unit_mapping"
}

variable "accounts" {
  type = list(object({
    account_name               = optional(string)
    account_email              = optional(string)
    ou_name                    = optional(string, "")
  }))
  description = "accounts_mapping"
  default     = []
}