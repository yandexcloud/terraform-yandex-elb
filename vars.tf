variable "name" {
  type        = string
  description = "Prefix for resources being created."
}

variable "image" {
  type        = string
  description = "Load balancer image name."
}

variable "sa" {
  type        = string
  description = "Load balancer service account id."
}

variable "platform_id" {
  type        = string
  description = "VM platform id."
}

variable "cores" {
  default     = 2
  description = "VM cores number."
}

variable "memory" {
  default     = 1
  description = "VM memory size (GB)."
}

variable "core_fraction" {
  default     = 5
  description = "VM CPU core fraction percents."
}

variable "disk_size" {
  default     = 1
  description = "VM boot disk size."
}

variable "disk_type" {
  default     = "nework-ssd"
  description = "VM boot disk size."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to attach load balancer too."
}

variable "ssh_key" {
  type        = string
  description = "Public ssh key to put into VMs authorized keys."
}

variable "serial_port" {
  default     = 1
  description = "0/1 - disable/enable serial console output."
}

variable "preemptible" {
  default     = true
  description = "Indicates whether load balancer's VMs should be preemptible."
}

variable "zones" {
  type        = list(string)
  description = "List of zones where to place load balancer's VMs."
}

variable "size" {
  default     = 1
  description = "Desired instance group size."
}

variable "labels" {
  default     = {}
  description = "Labels for load balancer's instance group."
}

variable "userdata" {
  type        = string
  description = "User data provided to load balancer's VMs."
}
