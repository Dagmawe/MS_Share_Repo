module "projects_service_project_factory" {
  source                         = "../modules/project-factory"
  for_each                       = { for project in var.project_factory : project.project_id => project }
  project_name                   = each.value.name
  project_id                     = each.value.project_id
  org_id                         = each.value.org_id
  folder_id                      = each.value.folder_id
  billing_account                = each.value.billing_account
  auto_create_network            = each.value.auto_create_network
  deletion_policy                = each.value.deletion_policy
  labels                         = each.value.labels
  enable_shared_vpc_host_project = each.value.enable_shared_vpc_host_project
  #   enable_shared_vpc_service_project = each.value.enable_shared_vpc_service_project
  #   shared_vpc                        = each.value.shared_vpc
}

module "service_project" {
  source          = "../modules/service_project"
  for_each        = { for sp in var.service_project : sp.service_project_id => sp }
  service_project = each.value.service_project_id
  shared_vpc      = each.value.shared_vpc
  depends_on      = [module.projects_service_project_factory]
}
