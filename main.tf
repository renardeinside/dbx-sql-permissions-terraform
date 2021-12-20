terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.4.1"
    }
  }
}

variable "databricks_profile" {
}

provider "databricks" {
    profile = var.databricks_profile
}

locals {
  raw_settings = yamldecode(file("${path.module}/permissions.yml"))
  settings = tomap({
      for p in local.raw_settings.principals: p.name => {
          database = p.database
          table = p.table 
          privileges = tolist(p.privileges)
      }
  })
}

resource "databricks_sql_permissions" "dynamic_permissions" {
    for_each = local.settings

    database = each.value.database 
    table = each.value.table 

    privilege_assignments {
        principal = each.key
        privileges = each.value.privileges
    }
}