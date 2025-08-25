variable "networks" {
  type = list(object({
    project_id                                = string
    network_name                              = string
    routing_mode                              = optional(string, "GLOBAL")
    description                               = optional(string, null)
    auto_create_subnetworks                   = optional(bool, false)
    delete_default_internet_gateway_routes    = optional(bool, false)
    mtu                                       = optional(number, 0)
    enable_ipv6_ula                           = optional(bool, false)
    internal_ipv6_range                       = optional(string, null)
    network_firewall_policy_enforcement_order = optional(string, null)
    network_profile                           = optional(string, null)
    bgp_always_compare_med                    = optional(bool, null)
    bgp_best_path_selection_mode              = optional(string, null)
    bgp_inter_region_cost                     = optional(number, null)
  }))
  default = []
}

variable "ncc_hub_spoke" {
  type = list(object({
    project_id          = string
    ncc_hub_name        = string
    ncc_hub_description = optional(string, null)
    present_topology    = optional(string, "MESH")
    ncc_hub_labels      = optional(map(string), {})
    export_psc          = optional(bool, false)
    vpc_spokes = optional(map(object({
      uri                   = string
      spoke_location        = optional(string, "global")
      exclude_export_ranges = optional(set(string), [])
      include_export_ranges = optional(set(string), [])
      description           = optional(string)
      labels                = optional(map(string))
    })), {})
    hybrid_spokes = optional(map(object({
      location                   = string
      uris                       = set(string)
      site_to_site_data_transfer = optional(bool, false)
      type                       = string
      description                = optional(string)
      labels                     = optional(map(string))
    })), {})
    router_appliance_spokes = optional(map(object({
      instances = set(object({
        virtual_machine = string
        network         = string
        region          = string
        zone            = string
      }))
      description = optional(string)
      labels      = optional(map(string))
    })), {})
    spoke_labels = optional(map(string), {})
    # trusted projects is a list of auto accept spoke attachements
    name             = optional(string, "default")
    trusted_projects = optional(list(string), [])
  }))
  default = []

}

variable "subnets" {
  type = map(object({
    project_id   = string
    network_name = string
    subnet_name = list(object({
      subnet_name                      = string
      subnet_ip                        = string
      subnet_region                    = string
      subnet_private_access            = optional(string, "false")
      subnet_private_ipv6_access       = optional(string)
      subnet_flow_logs                 = optional(string, "false")
      subnet_flow_logs_interval        = optional(string, "INTERVAL_5_SEC")
      subnet_flow_logs_sampling        = optional(string, "0.5")
      subnet_flow_logs_metadata        = optional(string, "INCLUDE_ALL_METADATA")
      subnet_flow_logs_filter          = optional(string, "true")
      subnet_flow_logs_metadata_fields = optional(list(string), [])
      description                      = optional(string)
      purpose                          = optional(string)
      role                             = optional(string)
      stack_type                       = optional(string)
      ipv6_access_type                 = optional(string)
    }))
    secondary_ranges = optional(map(list(object({
      range_name    = string
      ip_cidr_range = string
    }))), {})

  }))
  default = {}
}


variable "router" {
  type = list(object({
    name                          = string
    project_id                    = string
    network                       = string
    region                        = string
    description                   = optional(string)
    encrypted_interconnect_router = optional(bool, false)
    bgp = optional(object({
      asn               = number
      advertise_mode    = optional(string)
      advertised_groups = optional(list(string), [])
      advertised_ip_ranges = optional(list(object({
        range       = string
        description = optional(string)
      })), [])
      keepalive_interval = optional(number)
    }), null)
    labels = optional(map(string), {})
  }))
  default = []

}

variable "nats" {
  type = list(object({
    project_id = string
    # router_name   = string
    # router_region = string
    nats = list(object({
      name                                = string
      nat_ip_allocate_option              = optional(string)
      source_subnetwork_ip_ranges_to_nat  = optional(string)
      nat_ips                             = optional(list(string), [])
      drain_nat_ips                       = optional(list(string), [])
      min_ports_per_vm                    = optional(number)
      max_ports_per_vm                    = optional(number)
      udp_idle_timeout_sec                = optional(number)
      icmp_idle_timeout_sec               = optional(number)
      tcp_established_idle_timeout_sec    = optional(number)
      tcp_transitory_idle_timeout_sec     = optional(number)
      tcp_time_wait_timeout_sec           = optional(number)
      enable_endpoint_independent_mapping = optional(bool, false)
      enable_dynamic_port_allocation      = optional(bool, false)

      log_config = optional(object({
        enable = optional(bool, true)
        filter = optional(string, "ALL")
      }), {})

      subnetworks = optional(list(object({
        name                     = string
        source_ip_ranges_to_nat  = list(string)
        secondary_ip_range_names = optional(list(string))
      })), [])
    }))
  }))
  default     = []
  description = "NATs to deploy on this router."
}



variable "project_factory" {
  type = list(object({
    name                           = string
    project_id                     = string
    folder_id                      = string
    billing_account                = string
    auto_create_network            = optional(bool, false)
    deletion_policy                = optional(string, "PREVENT")
    labels                         = optional(map(string), {})
    org_id                         = optional(string, null)
    enable_shared_vpc_host_project = optional(bool, false)
    # enable_shared_vpc_service_project = optional(bool, false)
    # shared_vpc                        = optional(string, null)
    # service_project                   = optional(string, null)
  }))
  description = "Configuration for the project factory module."
  default     = []
}

variable "service_project" {
  type = list(object({
    service_project_id = string
    shared_vpc         = string
  }))
  description = "Configuration for service projects that will be attached to a shared VPC."
  default     = []

}
