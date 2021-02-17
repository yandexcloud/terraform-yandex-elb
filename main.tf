terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "yandex_compute_image" "elb" {
  name = var.image
}

resource "yandex_compute_instance_group" "elb" {
  name               = var.name
  service_account_id = var.sa

  instance_template {
    name               = "${var.name}-{instance.zone_id}-{instance.index_in_zone}"
    hostname           = "${var.name}-{instance.zone_id}-{instance.index_in_zone}"
    platform_id        = var.platform_id
    service_account_id = var.sa

    resources {
      cores         = var.cores
      memory        = var.memory
      core_fraction = var.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.elb.id
        size     = var.disk_size
        type     = var.disk_type
      }
    }

    network_interface {
      subnet_ids = var.subnet_ids
      nat        = true
    }

    labels = var.labels

    metadata = {
      user-data          = var.userdata
      ssh-keys           = var.ssh_key
      serial-port-enable = var.serial_port
    }

    network_settings {
      type = "STANDARD"
    }

    scheduling_policy {
      preemptible = var.preemptible
    }
  }

  allocation_policy {
    zones = var.zones
  }

  scale_policy {
    fixed_scale {
      size = var.size
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }
}
