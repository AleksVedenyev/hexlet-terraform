terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.11"
}

provider "yandex" {
  token      = var.yc_iam_token
  cloud_id   = var.yc_cloud_id
  folder_id  = var.yc_folder_id
  zone       = var.availability_zone
}
