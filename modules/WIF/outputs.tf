output "pool_id" {
  description = "Workload Identity Pool ID."
  value       = google_iam_workload_identity_pool.pool.workload_identity_pool_id

}

output "provider_id" {
  description = "Workload Identity Pool Provider ID."
  value       = google_iam_workload_identity_pool_provider.provider

}
