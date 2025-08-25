data "google_project" "ncc_projects" {
  for_each   = { for ncc in var.ncc_hub_spoke : ncc.project_id => ncc }
  project_id = each.value.project_id
}

module "non-prod_ncc_hub_spoke" {
  source           = "../modules/ncc"
  for_each         = { for ncc in var.ncc_hub_spoke : ncc.project_id => ncc }
  project_id       = data.google_project.ncc_projects[each.key].project_id
  ncc_hub_name     = each.value.ncc_hub_name
  vpc_spokes       = each.value.vpc_spokes
  hybrid_spokes    = try(each.value.hybrid_spokes, {})
  trusted_projects = each.value.trusted_projects
}
