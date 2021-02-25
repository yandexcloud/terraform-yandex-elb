variable "name" {
  type        = string
  description = "Prefix for resources being created."
}

variable "domain_name" {
  type        = string
  description = "Load balancer domain name associated."
}

variable "folder" {
  type        = string
  description = "Name of the parent folder"
}

variable "hosted_zone_id" {
  type        = string
  description = "AWS public hosted zone id where resource records will be created."
}

variable "aws_region" {
  type        = string
  description = "AWS region - part of credentials to access hosted zone."
}

variable "aws_role_arn" {
  type        = string
  description = "ARN of the AWS role with permissions to edit resource records in the hosted zone provided."
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key ID to assume the role provided."
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret access key to assume the role provided."
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

variable "clusters" {
  type = list(object({
    cluster = string
    lport   = number
    bport   = number
    healthcheck = object({
      timeout             = number
      interval            = number
      healthy_threshold   = number
      unhealthy_threshold = number
    })
  }))
  description = "List of target groups."
}
