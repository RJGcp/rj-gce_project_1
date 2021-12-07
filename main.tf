provider "google" {
  region = "${var.region}"
}
data "google_compute_zones" "available" {
  region = "${var.region}"
  status = "UP"
}

resource "google_compute_address" "instances" {
  count = "${var.amount}"
  name  = "${var.name_prefix}-${count.index}"
}

resource "google_compute_disk" "instances" {
  count = "${var.amount}"

  name = "${var.name_prefix}-${count.index+1}"
  type = "${var.disk_type}"
  size = "${var.disk_size}"
  zone = "${data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)]}"

  image = "${var.disk_image}"

}

resource "google_compute_instance" "instances" {
  count = "${var.amount}"

  name         = "${var.name_prefix}-${count.index+1}"
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  boot_disk {
    source      = "${google_compute_disk.instances.*.name[count.index]}"
    auto_delete = false
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.instances.*.address[count.index]}"
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
