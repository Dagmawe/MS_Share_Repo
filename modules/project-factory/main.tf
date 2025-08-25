resource "google_project" "project" {
  name                = var.project_name
  project_id          = var.project_id
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
  deletion_policy     = var.deletion_policy
  labels              = var.labels
}

resource "google_compute_shared_vpc_host_project" "host_project" {
  provider = google-beta
  count    = var.enable_shared_vpc_host_project ? 1 : 0
  project  = google_project.project.project_id
}

# resource "google_compute_shared_vpc_service_project" "service_project_attachment" {
#   count           = var.enable_shared_vpc_service_project ? 1 : 0
#   provider        = google-beta
#   host_project    = var.shared_vpc
#   service_project = var.service_project
# }
