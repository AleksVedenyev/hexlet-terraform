variable "name" {
  description = "Instance name"
  type        = string
  default     = "hexlet-test-vm"
}

variable "instance_cpu_and_ram" {
  description = "Instance resource parameters"
  type = object({
    cores     = number
    memory    = number
  })
  default = {
    cores     = 2
    memory    = 2
  }
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
}

variable "nat" {
  description = "Enable or disable NAT on VM"
  type        = bool
  default     = true
}