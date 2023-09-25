resource "azurerm_public_ip" "kafkaPublicIP" {
  name                = "${var.suffix}-KafkaPublicIP"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "kafkaNIC" {
  name                = "${var.suffix}-KafkaNIC"
  location            = azurerm_resource_group.genericRG.location
  resource_group_name = azurerm_resource_group.genericRG.name

  ip_configuration {
    name      = "kafkaServer"
    subnet_id = azurerm_subnet.subnets["headnodes"].id
    #subnet_id                     = data.azurerm_subnet.kafkasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kafkaPublicIP.id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "kafkaServer" {
  name                = "${var.suffix}-KafkaServer"
  resource_group_name = azurerm_resource_group.genericRG.name
  location            = azurerm_resource_group.genericRG.location
  size                = "Standard_DS3_v2"
  admin_username      = var.vmUserName
  #  encryption_at_host_enabled = true
  network_interface_ids = [azurerm_network_interface.kafkaNIC.id, ]

  admin_ssh_key {
    username   = var.vmUserName
    public_key = file(var.sshKeyPath)
  }

  os_disk {
    name                 = "${var.suffix}-kafkaServerosDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 100
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = var.centossku
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.genericSA.primary_blob_endpoint
  }

  custom_data = base64encode(<<CUSTOM_DATA
  #cloud-config
  chef:
    chef_license: "accept"
    install_type: "omnibus"
    omnibus_url: "https://www.chef.io/chef/install.sh"
    omnibus_version: "17.6.18"
    force_install: false
    server_url: "https://api.chef.io/organizations/chambras"
    environment: dev
    node_name: "${var.suffix}-KafkaServer"
    run_list: "recipe[KafkaServer]"
    validation_name: "chambras-validator"
    validation_cert: "${file(var.validatorCertPath)}"

  output: {all: '| tee -a /var/log/cloud-init-output.log'}
  runcmd:
    - sed -i "s/-----BEGIN RSA PRIVATE KEY-----/&\n/"  /etc/chef/validation.pem
    - sed -i "s/-----END RSA PRIVATE KEY-----/\n&/" /etc/chef/validation.pem
    - sed -i "2s/\s\+/\n/g"  /etc/chef/validation.pem
    - sed -i '/^$/d' /etc/chef/validation.pem
    - while [ ! -e /usr/bin/chef-client ]; do sleep 2; done; chef-client --chef-license=accept
  CUSTOM_DATA
  )

  tags = var.tags
}
