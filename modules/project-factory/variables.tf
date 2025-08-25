variable "project_name" {
  type        = string
  description = "The name of the project."

}

variable "project_id" {
  type        = string
  description = "The ID of the project."

}

variable "folder_id" {
  type        = string
  description = "The folder ID where the project will be created."

}
variable "billing_account" {
  type        = string
  description = "The billing account ID to associate with the project."
}

variable "auto_create_network" {
  type        = bool
  description = "Whether to auto-create a network in the project (default false)."
  default     = false
}

variable "deletion_policy" {
  description = "The deletion policy for the project."
  type        = string
  default     = "PREVENT"
}

variable "labels" {
  description = "Map of labels for project"
  type        = map(string)
  default     = {}
}

variable "org_id" {
  description = "The organization ID."
  type        = string
  default     = null
}

variable "enable_shared_vpc_host_project" {
  description = "If this project is a shared VPC host project. If true, you must *not* set shared_vpc variable. Default is false."
  type        = bool
  default     = false
}

# variable "enable_shared_vpc_service_project" {
#   description = "If this project should be attached to a shared VPC. If true, you must set shared_vpc variable."
#   type        = bool
# }

# variable "shared_vpc" {
#   description = "The ID of the host project which hosts the shared VPC"
#   type        = string
#   default     = ""
# }

# variable "service_project" {
#   description = "The ID of the service project which is attached to the shared VPC"
#   type        = string
#   default     = ""
# }
