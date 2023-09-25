output "generic_RG" {
  value       = azurerm_resource_group.genericRG.name
  description = "RG name."
}

output "subnets" {
  value = {
    for subnet in azurerm_subnet.subnets :
    subnet.name => subnet.address_prefixes
  }
  description = "subnets created."
}

output "dataBricksSubnets" {
  value = {
    for subnet in azurerm_subnet.dbSubnets :
    subnet.name => subnet.address_prefixes
  }
  description = "Databricks dedicated subnets."
}

output "kafkaPublicIP" {
  value       = azurerm_public_ip.kafkaPublicIP.ip_address
  description = "Kafka server public IP."
}

output "kafkaPrivateIP" {
  value       = azurerm_network_interface.kafkaNIC.private_ip_address
  description = "Kafka private IP."
}

output "sshAccess" {
  description = "Command to ssh into the VM."
  sensitive   = false
  value       = <<SSHCONFIG
  ssh ${var.vmUserName}@${azurerm_public_ip.kafkaPublicIP.ip_address} -i ~/.ssh/vm_ssh
  SSHCONFIG
}

output "databricks_host" {
  value       = "https://${azurerm_databricks_workspace.databricksWokspace.workspace_url}/"
  description = "Databricks URL."
}

output "databricks_ws_id" {
  value       = azurerm_databricks_workspace.databricksWokspace.workspace_id
  description = "The unique identifier of the databricks workspace in Databricks control plane."
}
