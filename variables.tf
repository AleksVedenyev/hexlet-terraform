variable "server_name" {
  description = "Name of server"
  type        = string
  default     = "web"
}

variable "availability_zone" {
  description = "Zone to place instances in."
  type        = string
  default     = "ru-central1-a"
}

variable "instance_cpu_and_ram" {
  description = "Instance resource parameters."
  type = object({
    cores     = number
    memory    = number
  })
  default = {
    cores     = 2
    memory    = 2
  }
}

variable "resource_labels" {
  description = "Labels to set for all resources"
  type        = map(string)
  default = {
    project     = "project-test"
    environment = "dev"
  }
}

 variable "yc_folder_id" {
  description  = "Folder id in Cloud"
  type         = string
 }

