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
  count = 2
  length  = 4
  special = false
  upper   = false
}

# Start a container
resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}




# output
output "node-red-ip-address" {
  value       = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
  description = "The ip address of the container"
}

output "node-red-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the nodered container"
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