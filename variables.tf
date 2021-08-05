variable "ext_port" {
  type = list

  # validation {
  #   condition = var.ext_port <= 65535 && var.ext_port > 0
  #   error_message = "The external port must be valid port range 0 - 65535."
  # }
}

variable "int_port" {
  type = number

  # validation {
  #   condition = var.int_port == 1880
  #   error_message = "The internal port must be 1880."
  # }
}

# variable "container_count" {
#   type = number
#   default = 3
# }

locals {
  container_count = length(var.ext_port) + 1
}