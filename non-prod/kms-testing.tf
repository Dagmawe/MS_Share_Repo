# data "google_project" "cmk-log-project" {
#   project_id = "cmk-log-project"
# }

# # Enable KMS api 
# resource "google_project_service" "kms_api" {
#   project = "442897125960"
#   service = "cloudkms.googleapis.com"

#   disable_on_destroy = false
# }

# # enable logging api
# resource "google_project_service" "logging_api" {
#   project            = data.google_project.cmk-log-project.project_id
#   service            = "logging.googleapis.com"
#   disable_on_destroy = false
# }


# # Create a KMS Key Ring
# resource "google_kms_key_ring" "org_key_ring" {
#   name     = "my-US-key-ring"
#   project  = data.google_project.cmk-log-project.project_id
#   location = "us"

#   depends_on = [
#     google_project_service.kms_api
#   ]

# }
# # Create a Crypto Key within the Key Ring
# resource "google_kms_crypto_key" "org_cmk" {
#   name            = "org-logging-key"
#   key_ring        = google_kms_key_ring.org_key_ring.id
#   rotation_period = "7776000s"

#   depends_on = [
#     google_kms_key_ring.org_key_ring,
#     google_project_service.kms_api
#   ]
# }

# # create a org log bucket with specified CMEK - all logs stored in this bucket will be encrypted with the specified CMEK
# # resource "google_logging_organization_bucket_config" "org_log_bucket" {
# #   organization   = "16289122644"
# #   location       = "US"
# #   retention_days = 90
# #   bucket_id      = "org-cmek-log-bucket"

# #   cmek_settings {
# #     kms_key_name = google_kms_crypto_key.org_cmk.id
# #   }

# #   depends_on = [
# #     google_kms_crypto_key.org_cmk
# #   ]
# # }

# #had to create it in console since the only location tf would allow is "global" and not "us-central1"
# # resource "google_logging_project_bucket_config" "central_log_bucket" {
# #   project        = data.google_project.cmk-log-project.project_id
# #   location       = "us-central1"
# #   retention_days = 90
# #   bucket_id      = "central-cmek-log-bucket"

# #   cmek_settings {
# #     kms_key_name = google_kms_crypto_key.org_cmk.id
# #   }
# # }


# # CMEK setting to set or update CMEK setting is not support with terraform - need to use gcloud command - tell GCP to use the KMS key for logging at an org level
# # gcloud logging cmek-settings update \
# #   --organization=16289122644 \
# #   --kms-key-name=projects/<PROJECT_ID>/locations/<REGION>/keyRings/<KEY_RING>/cryptoKeys/<KEY>

# resource "google_logging_folder_sink" "folder_sink" {
#   name        = "central-folder-sink"
#   folder      = "889725146537" # The ID of the folder to capture logs from
#   description = "Sink to route all logs from the folder to a central log bucket"

#   # The full path to the destination log bucket
#   destination = "logging.googleapis.com/projects/cmk-log-project/locations/us/buckets/central-log-bucket"
# }

# # 2. Grant the new sink's service account permission to write to the bucket
# resource "google_project_iam_member" "log_bucket_writer" {
#   project = "cmk-log-project" # The project containing the destination log bucket
#   role    = "roles/logging.bucketWriter"

#   # Automatically uses the unique service account created for the sink above
#   member = google_logging_folder_sink.folder_sink.writer_identity
# }

# resource "google_logging_organization_sink" "org_sink" {
#   name        = "central-org-sink"
#   org_id      = "16289122644"
#   destination = "logging.googleapis.com/projects/cmk-log-project/locations/us/buckets/central-log-bucket"
#   filter      = "" # Optional

# }

# resource "google_project_iam_member" "sink_writer" {
#   project = data.google_project.cmk-log-project.project_id
#   role    = "roles/logging.bucketWriter"
#   member  = google_logging_organization_sink.org_sink.writer_identity
# }

# # grant service agen proper roles to use the KMS key for logging
# resource "google_kms_crypto_key_iam_member" "project_logging_service_agent_permissions" {
#   crypto_key_id = google_kms_crypto_key.org_cmk.id
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#   member        = "serviceAccount:service-${data.google_project.cmk-log-project.number}@gcp-sa-logging.iam.gserviceaccount.com"
# }

# resource "google_kms_crypto_key_iam_member" "org_logging_service_agent_permissions" {
#   crypto_key_id = google_kms_crypto_key.org_cmk.id
#   role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#   member        = "serviceAccount:service-org-16289122644@gcp-sa-logging.iam.gserviceaccount.com"
# }
