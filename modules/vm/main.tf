data "yandex_compute_image" "img" {
  family = "container-optimized-image"
}

resource "yandex_compute_instance" "vm" {
  name = var.name
  zone = "ru-central1-a"

  resources {
    cores  = var.instance_cpu_and_ram.cores
    memory = var.instance_cpu_and_ram.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
 }
}