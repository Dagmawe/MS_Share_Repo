resource "google_compute_shared_vpc_service_project" "service_project_attachment" {
  provider        = google-beta
  host_project    = var.shared_vpc
  service_project = var.service_project
}
