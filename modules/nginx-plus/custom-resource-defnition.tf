 # Apply kubectl to create custom resource defnition for transportservers , virtualservers & virtualserverroutes. 
 # This will be replaced one Terraform has https://github.com/hashicorp/terraform-provider-kubernetes-alpha as GA
 # The yaml files inside crd folder should be kept up to date, retrieve it from here https://github.com/nginxinc/kubernetes-ingress/tree/master/deployments/common
resource "null_resource" "cluster" {

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/crd/"
  }
   depends_on = [kubernetes_config_map.nginx-ingress-config-map, kubernetes_config_map.nginx_ingress_server_config_map]
}
/** NSM
resource "null_resource" "cluster-role-nsm" {

  provisioner "local-exec" {
    command = "kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config  get-value core/account)"
  }
   depends_on = [kubernetes_config_map.nginx-ingress-config-map, kubernetes_config_map.nginx_ingress_server_config_map]
}

resource "null_resource" "deploy-nsm" {

  provisioner "local-exec" {
    command = "nginx-meshctl deploy --disable-auto-inject --enabled-namespaces=\"bookinfo,microservice-namespace\" --mtls-mode strict --registry-server asia.gcr.io/f5-gcs-4299-sales-se-nginx/ --registry-key /Users/fourframes/.config/gcloud/application_default_credentials.json --image-tag 0.8.0"
  }
   depends_on = [null_resource.cluster-role-nsm, kubernetes_config_map.nginx-ingress-config-map, kubernetes_config_map.nginx_ingress_server_config_map]
}
**/