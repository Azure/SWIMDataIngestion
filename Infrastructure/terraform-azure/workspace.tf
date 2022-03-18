resource "azurerm_databricks_workspace" "databricksWokspace" {
  name                = "${var.suffix}${var.workspaceName}"
  resource_group_name = azurerm_resource_group.genericRG.name
  location            = azurerm_resource_group.genericRG.location
  sku                 = "trial"

  custom_parameters {
    virtual_network_id                                   = azurerm_virtual_network.genericVNet.id
    private_subnet_name                                  = azurerm_subnet.dbSubnets["privateDB"].name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.dataBricksNSGAssociation["privateDB"].id
    public_subnet_name                                   = azurerm_subnet.dbSubnets["publicDB"].name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.dataBricksNSGAssociation["publicDB"].id
    no_public_ip                                         = false
  }

  tags = var.tags

  depends_on = [azurerm_subnet.dbSubnets, azurerm_network_security_group.dataBricksNSG]
}
