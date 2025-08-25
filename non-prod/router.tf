# create router and nat resources
module "router" {
  source = "../modules/router"

  for_each = { for router in var.router : router.project_id => router }
  name     = each.value.name
  network  = each.value.network
  project  = each.value.project_id
  region   = each.value.region
  bgp      = each.value.bgp
}

module "nat" {
  source        = "../modules/nat"
  for_each      = { for nat in var.nats : nat.project_id => nat }
  project_id    = each.value.project_id
  router_name   = module.router[each.key].router.name
  router_region = module.router[each.key].router.region
  nats          = each.value.nats
}
