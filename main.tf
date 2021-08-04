terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {}

# generate random string
resource "random_string" "random1" {
  length  = 4
  special = false
  upper   = false
}

# generate random string
resource "random_string" "random2" {
  length  = 4
  special = false
  upper   = false
}

# Find the latest node-red precise image.
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# Start a container
resource "docker_container" "nodered_container1" {
  name  = join("-", ["nodered", random_string.random1.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name  = join("-", ["nodered", random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}





# output
output "node-red-ip-address" {
  value       = join(":", [docker_container.nodered_container1.ip_address, docker_container.nodered_container1.ports[0].external])
  description = "The ip address of the container"
}

output "node-red-name1" {
  value       = docker_container.nodered_container1.name
  description = "The name of the nodered container"
}

output "node-red-name2" {
  value       = docker_container.nodered_container2.name
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