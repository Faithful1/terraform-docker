terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {}

# Find the latest node-red precise image.
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# generate random string
resource "random_string" "random" {
  count = var.random_count
  length  = 4
  special = false
  upper   = false
}

# Start a container
resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
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