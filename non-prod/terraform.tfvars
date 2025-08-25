#project creation
project_factory = [
  {
    project_id          = "host-non-prod-project1"
    name                = "host-non-prod-project1"
    billing_account     = "014CD6-C5F571-D1FFA4"
    folder_id           = "folders/663111463644"
    auto_create_network = false
    labels = {
      environment = "non-prod"
    }
    enable_shared_vpc_host_project = true # This project will be a Shared VPC host project
  },
  {
    project_id          = "service-project-12-nonprod"
    name                = "service-project-12-nonprod"
    billing_account     = "014CD6-C5F571-D1FFA4"
    folder_id           = "folders/663111463644"
    auto_create_network = false
    labels = {
      environment = "non-prod"
    }
  }
]

# service project attachment to shared VPC
service_project = [
  {
    service_project_id = "service-project-12-nonprod"
    shared_vpc         = "host-non-prod-project1"
  }
]


# This file is used to define variables for the non-production environment in Terraform.
networks = [
  {
    project_id              = "host-non-prod-project1"
    network_name            = "host-network"
    routing_mode            = "GLOBAL"
    description             = "VPC for internal non-prod environment"
    auto_create_subnetworks = false
  },
  {
    project_id              = "service-project-12-nonprod"
    network_name            = "service-project-network"
    routing_mode            = "GLOBAL"
    description             = "VPC for red non-prod environment"
    auto_create_subnetworks = false
  }

]

# # # hub and spoke configuration for NCC
# ncc_hub_spoke = [
#   {
#     project_id   = "net-282536-transit-nonprod"
#     ncc_hub_name = "non-prod-hub"
#     vpc_spokes = {
#       "internal-vpc-spoke" = {
#         uri                   = "projects/net-65432-int-nonprod/global/networks/internal-network"
#         exclude_export_ranges = []
#         include_export_ranges = []
#         description           = "Internal VPC spoke"
#       },
#       "red-vpc-spoke" = {
#         uri                   = "projects/net-65432-red-nonprod/global/networks/red-network"
#         exclude_export_ranges = []
#         include_export_ranges = []
#         description           = "Red VPC spoke"
#       }
#     }
#     trusted_projects = [
#       "net-65432-red-nonprod",
#       "net-65432-int-nonprod"
#     ]
#   }
# ]

# subnets = {
#   "subnet1" = {
#     project_id   = "net-65432-int-nonprod"
#     network_name = "internal-network"
#     subnets = [
#       {
#         name          = "internal-subnet"
#         ip_cidr_range = " " # Specify the CIDR range for the subnet
#         region        = "us-central1"
#         description   = "Subnet for internal services"
#         purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
#         role          = "ACTIVE"
#         stack_type    = "PRIMARY"
#       }
#     ]
#     secondary_ranges = {
#       "internal-secondary-range" = [
#         {
#           range_name    = "internal-secondary-range"
#           ip_cidr_range = "" # Specify the CIDR range for the secondary range
#         }
#       ]
#     }
#   },
#  "subnet2" = {
#     project_id   = "net-65432-int-nonprod"
#     network_name = "internal-network"
#     subnets = [
#       {
#         name          = "internal-subnet"
#         ip_cidr_range = " " # Specify the CIDR range for the subnet
#         region        = "us-central1"
#         description   = "Subnet for internal services"
#         purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
#         role          = "ACTIVE"
#         stack_type    = "PRIMARY"
#       }
#     ]
#     secondary_ranges = {
#       "internal-secondary-range" = [
#         {
#           range_name    = "internal-secondary-range"
#           ip_cidr_range = "" # Specify the CIDR range for the secondary range
#         }
#       ]
#     }
#   }

# }

