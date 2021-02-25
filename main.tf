terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "yandex_resourcemanager_folder" "folder" {
  name = var.folder
}

data "yandex_compute_image" "elb" {
  name = var.image
}

resource "yandex_compute_instance_group" "elb" {
  name               = var.name
  folder_id          = data.yandex_resourcemanager_folder.folder.id
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
      user-data = templatefile("${path.module}/data/userdata.yml", {
        cds = templatefile("${path.module}/data/cds.yaml", {
          clusters = var.clusters
        })
        cds_tpl = templatefile("${path.module}/data/cds.yaml.tpl", {
          clusters = var.clusters
        })
        lds = templatefile("${path.module}/data/lds.yaml", {
          clusters = var.clusters
        })
        envoy = templatefile("${path.module}/data/envoy.yaml", {
          name = var.name
        })
        aws_region     = var.aws_region
        aws_role_arn   = var.aws_role_arn
        aws_access_key = var.aws_access_key
        aws_secret_key = var.aws_secret_key
        aws_zone_id    = var.hosted_zone_id
        folder_id      = data.yandex_resourcemanager_folder.folder.id
        group_name     = var.name
        domain_name    = var.domain_name
      })
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
