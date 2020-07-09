provider "azurerm" {
  features {}
}
resource "random_pet" "pet-prefix" {
  length = 1
  prefix = var.prefix
}

resource "azurerm_resource_group" "k8s-resource-group" {
  depends_on = [var.depends_on_kic]
  name     = "${random_pet.pet-prefix.id}-k8s-rg"
  location = var.location
}

resource "azurerm_resource_group" "nginx-ingress-container-rg" {
  depends_on = [var.depends_on_kic]
  name     = "${random_pet.pet-prefix.id}-container-rg"
  location = var.location
}

resource "azurerm_container_registry" "nginx-ingress-acr" {
  depends_on = [var.depends_on_kic, azurerm_resource_group.nginx-ingress-container-rg]
  name                     = var.ingress_controller_prefix
  resource_group_name      = azurerm_resource_group.nginx-ingress-container-rg.name
  location                 = var.location
  sku                      = "Basic"
  admin_enabled            = false
}

resource "null_resource" "push-image-to-acr" {
  depends_on = [var.depends_on_kic, azurerm_container_registry.nginx-ingress-acr]
  provisioner "local-exec" {
    command = "az acr login --name ${azurerm_container_registry.nginx-ingress-acr.name}"
  }
  provisioner "local-exec" {
    command = "docker push ${azurerm_container_registry.nginx-ingress-acr.login_server}/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  }
  provisioner "local-exec" {
    command = "docker rmi ${azurerm_container_registry.nginx-ingress-acr.login_server}/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  }
}

resource "azurerm_virtual_network" "k8s-vnet" {
  depends_on = [var.depends_on_kic]
  name                = "${random_pet.pet-prefix.id}-vnet"
  location            = azurerm_resource_group.k8s-resource-group.location
  resource_group_name = azurerm_resource_group.k8s-resource-group.name
  address_space       = ["${var.vpc_cidr}"]
}

resource "azurerm_subnet" "k8s-nodepool-subnet" {
  depends_on = [var.depends_on_kic]
  name                 = "${random_pet.pet-prefix.id}-internal-subnet"
  virtual_network_name = azurerm_virtual_network.k8s-vnet.name
  resource_group_name  = azurerm_resource_group.k8s-resource-group.name
  address_prefixes     = ["${var.vpc_subnet_cidr}"]
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  depends_on = [var.depends_on_kic]
  name                = "${random_pet.pet-prefix.id}-k8s"
  location            = azurerm_resource_group.k8s-resource-group.location
  resource_group_name = azurerm_resource_group.k8s-resource-group.name
  dns_prefix          = "${random_pet.pet-prefix.id}-k8s"

  default_node_pool {
    name           = "primarynode"
    node_count     = var.default_node_pool_count
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.k8s-nodepool-subnet.id //only set if the network_plugin in the network_profile is set to "azure" or if your other node pool is part of subnet
    node_labels = {
      label = var.system_node_label_identifier
    }
    tags = {
      Environment = var.environment
      NodePool    = "system node for system application pod deployments"
    }
  }
  kubernetes_version  = var.kubernetes_version
  //node_resource_group = "aks-cluster-node-group"

  network_profile {
    network_plugin    = "azure"
    //load_balancer_sku = "standard"
    //outbound_type     = "userDefinedRouting"
  }

  tags = {
    Environment = var.environment
  }

  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group  ${azurerm_resource_group.k8s-resource-group.name} --name  ${azurerm_kubernetes_cluster.aks-cluster.name}"
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "aks-cluster-application-node-pool" {
  depends_on = [var.depends_on_kic]
  name                  = "application"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = var.application_node_pool_count
  vnet_subnet_id        = azurerm_subnet.k8s-nodepool-subnet.id
  node_labels = {
    label = var.application_node_label_identifier
  }
  tags = {
    Environment = var.environment
    NodePool    = "Used for Appliation pod deployments"
  }
}

/*
resource "null_resource" "attach-acr-to-aks" {

  provisioner "local-exec" {
    command = "az aks update -n ${azurerm_kubernetes_cluster.nginx-ingress-aks-cluster.name} -g ${azurerm_resource_group.nginx-ingress-rg.name} --attach-acr ${azurerm_container_registry.nginx-ingress-acr.name}"
  }
   //depends_on = [azurerm_kubernetes_cluster_node_pool.nginx-ingress-aks-cluster-application-node-pool]
   depends_on = [azurerm_kubernetes_cluster.nginx-ingress-aks-cluster]
}
*/

resource "azurerm_role_assignment" "acr-role-assignment" {
  depends_on = [var.depends_on_kic, null_resource.push-image-to-acr]
  scope              = azurerm_container_registry.nginx-ingress-acr.id
  role_definition_name = "AcrPull"
  principal_id       = data.azurerm_user_assigned_identity.principal.principal_id
  skip_service_principal_aad_check = true
}

data "azurerm_user_assigned_identity" "principal" {
  name                = "${azurerm_kubernetes_cluster.aks-cluster.name}-agentpool"
  resource_group_name =  azurerm_kubernetes_cluster.aks-cluster.node_resource_group
}
data "azurerm_kubernetes_cluster" "primarynode-cluster" {
  name                = azurerm_kubernetes_cluster.aks-cluster.name
  resource_group_name = azurerm_resource_group.k8s-resource-group.name
}