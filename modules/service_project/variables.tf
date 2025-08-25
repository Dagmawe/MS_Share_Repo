variable "shared_vpc" {
  description = "The ID of the host project which hosts the shared VPC"
  type        = string
  default     = ""
}

variable "service_project" {
  description = "The ID of the service project which is attached to the shared VPC"
  type        = string
  default     = ""
}
