terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

# Find the latest node-red precise image.
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# generate random string
resource "random_string" "random" {
  count = local.container_count
  length  = 4
  special = false
  upper   = false
}

# Start a container
resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol"
  }
}
















# resource "docker_image" "nginx" {
#   name         = "nginx:latest"
# }

# resource "docker_container" "nginx" {
#   image = docker_image.nginx.latest
#   name  = "tutorial"
#   ports {
#     internal = 80
#     external = 8000
#   }
# }

# output "nginx-ip-address" {
#   value = join(":", [docker_container.nginx.ip_address, docker_container.nginx.ports[0].external])
#   description = "The ip of the nginx container"
# }