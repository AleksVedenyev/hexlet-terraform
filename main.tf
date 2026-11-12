# Создаем сеть

resource "yandex_vpc_network" "net" {
  name = "tfhexlet"
}

# Создаем подсеть

resource "yandex_vpc_subnet" "subnet" {
  name           = "tfhexlet"
  zone           = var.availability_zone
  network_id     = yandex_vpc_network.net.id
  v4_cidr_blocks = ["192.168.192.0/24"]
}

# Создаем сервер

module "vm1" {
  source      = "./modules/vm"
  subnet_id  = yandex_vpc_subnet.subnet.id
  name        = "test-vm-1"

  instance_cpu_and_ram = {
      cores     = 2
      memory    = 4
    }
}

module "vm2" {
  source      = "./modules/vm"
  subnet_id  = yandex_vpc_subnet.subnet.id
  name        = "test-vm-2"
}

output "internal_ip_of_VM1" {
    description = "Internal IP of VM1"
    value       = module.vm1.internal_ip
}

output "external_ip_of_VM1" {
    description = "External IP of VM1"
    value       = module.vm1.external_ip
}

output "internal_ip_of_VM2" {
    description = "Internal IP of VM2"
    value       = module.vm2.internal_ip
}

output "external_ip_of_VM2" {
    description = "External IP of VM2"
    value       = module.vm2.external_ip
}