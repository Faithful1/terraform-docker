terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {}

variable "ext_port" {
  type = number
  default = 1880

  validation {
    condition = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be valid port range 0 - 65535."
  }
}

variable "int_port" {
  type = number
  default = 1880

  validation {
    condition = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

variable "container_count" {
  type = number
  default = 1
}

variable "random_count" {
  type = number
  default = 1
}

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




# output
output "node-red-ip-address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
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