variable "organizational_units" {
  type = map(object({
    child_ous = optional(list(string), [])
  }))
  default     = {}
  description = "organizational_unit_mapping"
}