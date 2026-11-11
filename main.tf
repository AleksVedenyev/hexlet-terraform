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


resource "yandex_compute_instance" "web1" {
  name        = "web1"
  platform_id = "standard-v1"
  zone        = var.availability_zone
  folder_id   = var.yc_folder_id

  resources {
    cores  = var.instance_cpu_and_ram.cores
    memory = var.instance_cpu_and_ram.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.web1_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  } 
}

resource "yandex_compute_instance" "web2" {
  name        = "web2"
  platform_id = "standard-v1"
  zone        = var.availability_zone
  folder_id   = var.yc_folder_id

  resources {
    cores  = var.instance_cpu_and_ram.cores
    memory = var.instance_cpu_and_ram.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.web2_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  } 
}

resource "yandex_lb_target_group" "my_tg" {
  name      = "my-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.default.id
    address   = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.default.id
    address   = yandex_compute_instance.web2.network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "my_nlb" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.my_tg.id

    healthcheck {
        name = "http"
        http_options {
          port = 8080
          path = "/ping"
        }
  }
  }
}

resource "yandex_vpc_network" "default" {
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "default" {
  zone           = var.availability_zone
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = var.yc_folder_id
}

resource "yandex_compute_disk" "web1_disk" {
  name      = "web1_disk"
  type      = "network-ssd"
  zone      = var.availability_zone
  size      = "10"
  image_id  = data.yandex_compute_image.img.id
  folder_id = var.yc_folder_id

  labels = var.resource_labels
}

resource "yandex_compute_disk" "web2_disk" {
  name      = "web2_disk"
  type      = "network-hdd"
  zone      = var.availability_zone
  size      = "10"
  image_id  = data.yandex_compute_image.img.id
  folder_id = var.yc_folder_id

  labels = var.resource_labels
}

data "yandex_compute_image" "img" {
  family = "ubuntu-2204-lts"
}