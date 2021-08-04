# output
output "node-red-ip-address" {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The ip address of the container"
  sensitive = true
}

output "node-red-name" {
  value       = docker_container.nodered_container[*].name
  description = "The name of the nodered container"
}
