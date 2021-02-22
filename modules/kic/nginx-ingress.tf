resource "null_resource" "build-kic" {
  provisioner "local-exec" {
    command = "git clone https://github.com/nginxinc/kubernetes-ingress.git ${path.module}/kubernetes-ingress"
  }
  provisioner "local-exec" {
    command = "cp nginx-repo.* ${path.module}/kubernetes-ingress/"
  }
  provisioner "local-exec" {
    command = "sh ${path.module}/start-docker.sh"
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/kubernetes-ingress/ && git checkout v${var.ingress_conroller_version}"
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/kubernetes-ingress/ && make container DOCKERFILE=DockerfileWithOpentracingForPlus PREFIX=${var.ingress_controller_prefix}/${var.ingress_controller_image_name}"
  }
  
  provisioner "local-exec" {
    command = "rm -rf ${path.module}/kubernetes-ingress"
  }
  /*
  provisioner "local-exec" {
    when    = destroy
    command = "docker rmi ${var.ingress_controller_prefix}/${var.ingress_controller_image_name}:${var.ingress_conroller_version}"
  } */
}
