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
    profile = vars.databricks_profile
}

