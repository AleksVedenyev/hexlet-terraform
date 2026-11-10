terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.11"
}

provider "yandex" {
  zone  = var.availability_zone
}


resource "yandex_compute_instance" "default" {
  name        = var.server_name
  platform_id = "standard-v1"
  zone        = var.availability_zone
  folder_id   = "b1ggqguhuafevpgrl3m9"

  resources {
    cores  = var.instance_cpu_and_ram.cores
    memory = var.instance_cpu_and_ram.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.default.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  } 
}

resource "yandex_vpc_network" "default" {
  folder_id = "b1ggqguhuafevpgrl3m9"
}

resource "yandex_vpc_subnet" "default" {
  zone           = var.availability_zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = "b1ggqguhuafevpgrl3m9"
}

resource "yandex_compute_disk" "default" {
  name      = "disk-name"
  type      = "network-ssd"
  zone      = var.availability_zone
  size      = "10"
  image_id  = "fd83s8u085j3mq231ago" // идентификатор образа Ubuntu
  folder_id = "b1ggqguhuafevpgrl3m9"

  labels = var.resource_labels
}