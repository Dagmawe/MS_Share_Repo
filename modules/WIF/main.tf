
# TODO: Compplete the WIF setup for GitHub Actions
# Create the service account that GitHub Actions will impersonate
# resource "google_service_account" "sa" {
#   project      = var.project_id
#   account_id   = var.service_account_id
#   display_name = "Service Account for GitHub Actions WIF"
# }

resource "google_iam_workload_identity_pool" "pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
  description               = var.pool_description
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  workload_identity_pool_provider_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.name
  display_name                       = var.provider_display_name
  description                        = var.provider_description
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  #Configure the provider to trust GitHub's OIDC issuer
  oidc {
    issuer_uri = var.issuer_uri
  }
}

#  Grant the external identity (the GitHub repo) the ability to impersonate the SA
# This binds the GitHub repo to the Google Cloud Service Account
# resource "google_service_account_iam_member" "iam_binding" {
#   service_account_id = google_service_account.sa.name
#   role               = "roles/iam.workloadIdentityUser"

#   # The "member" is the external identity that is allowed to impersonate the SA.
#   # This syntax specifies "any workflow in a specific repository".
#   member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
# }
