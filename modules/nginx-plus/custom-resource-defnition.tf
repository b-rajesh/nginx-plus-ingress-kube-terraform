 # Apply kubectl to create custom resource defnition for transportservers , virtualservers & virtualserverroutes. 
 # This will be replaced one Terraform has https://github.com/hashicorp/terraform-provider-kubernetes-alpha as GA
 # The yaml files inside crd folder should be kept up to date, retrieve it from here https://github.com/nginxinc/kubernetes-ingress/tree/master/deployments/common
resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/crd/"
  }
   depends_on = [kubernetes_config_map.nginx-ingress-config-map, kubernetes_config_map.nginx_ingress_server_config_map]
}
