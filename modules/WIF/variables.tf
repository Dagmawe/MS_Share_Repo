# variables.tf

variable "project_id" {
  type        = string
  description = "The GCP project ID to deploy the resources in."
}


variable "pool_id" {
  type        = string
  description = "The ID of the Workload Identity Pool to create."

}

variable "pool_display_name" {
  type        = string
  description = "The display name for the Workload Identity Pool."
  default     = "Workload Identity Pool for GitHub"
}

variable "pool_description" {
  type        = string
  description = "A description for the Workload Identity Pool."
  default     = "Pool for authenticating GitHub Actions"
}

variable "provider_display_name" {
  type        = string
  description = "The display name for the Workload Identity Pool Provider."
  default     = "GitHub Actions Provider"
}

variable "provider_description" {
  type        = string
  description = "A description for the Workload Identity Pool Provider."
  default     = "Provider for authenticating GitHub Actions"
}

variable "issuer_uri" {
  type        = string
  description = "The issuer URI for the Workload Identity Pool Provider."

}
