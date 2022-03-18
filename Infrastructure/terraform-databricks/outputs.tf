output "ClusterState" {
  value       = databricks_cluster.shared_autoscaling.state
  description = "State of the cluster."
}
