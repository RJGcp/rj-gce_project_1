provider "google" {
  region = var.region
}
data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

locals {
  is_prod = length(regexall("p", "${var.instance_name}")) > 0
  is_qa = length(regexall("q", "${var.instance_name}")) > 0
}

resource "google_compute_address" "instances" {
  count = var.amount
  name  = "${var.instance_name}-${count.index}"
}

# resource "google_compute_disk" "instances" {
#   name = var.instance_name
#   type = var.disk_type
#   size = var.disk_size
#   zone = var.zone

#   image = var.disk_image

# }
resource "google_compute_disk" "additional_disk" {
  count = "${local.is_prod}" ? 1 : 0
  name  = "test-disk"
  type  = "pd-ssd"
  zone  = var.zone
  size  = 10
}

resource "google_compute_instance" "prod_instances" {
  count = "${local.is_prod}" ? 1 : 0

  name                = var.instance_name
  zone                = var.zone
  machine_type        = var.machine_type
  boot_disk {
    initialize_params {
      image       = "{var.disk_image}"
      type        = "pd-ssd"
    }
  }
  deletion_protection = true
  tags                = "${var.tags}"
  attached_disk {
    source = google_compute_disk.additional_disk.*.name[count.index]
  }



  network_interface {
    network = var.network

    access_config {
      nat_ip = google_compute_address.instances.*.address[count.index]
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }
}

# Creating the QA GCE
resource "google_compute_instance" "qa_instances" {
  count = "${local.is_qa}" ? 1 : 0

  name                = var.instance_name
  zone                = var.zone
  machine_type        = var.machine_type
  boot_disk {
    initialize_params {
      image       = "{var.disk_image}"
      type        = "pd-ssd"
    }
  }
  deletion_protection = true
  tags                = "${var.qa_tags}"
  
  network_interface {
    network = var.network

    access_config {
      nat_ip = google_compute_address.instances.*.address[count.index]
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }
}
