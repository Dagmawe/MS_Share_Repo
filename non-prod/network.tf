data "google_project" "projects" {
  for_each   = { for net in var.networks : net.project_id => net }
  project_id = each.value.project_id
}

module "non-prod-network" {
  source                  = "../modules/vpc"
  for_each                = { for net in var.networks : net.project_id => net }
  project_id              = data.google_project.projects[each.key].project_id
  network_name            = each.value.network_name
  auto_create_subnetworks = each.value.auto_create_subnetworks
  routing_mode            = each.value.routing_mode
  description             = each.value.description
  depends_on              = [module.projects_service_project_factory]
}

data "google_project" "subnet_projects" {
  for_each   = { for subnet in var.subnets : subnet.project_id => subnet }
  project_id = each.value.project_id
}

module "subnets" {
  source           = "../modules/subnets"
  for_each         = { for subnet in var.subnets : subnet.project_id => subnet }
  project_id       = data.google_project.subnet_projects[each.key].project_id
  network_name     = each.value.network_name
  subnets          = each.value.subnets
  secondary_ranges = each.value.secondary_ranges
  depends_on       = [module.non-prod-network]
}
