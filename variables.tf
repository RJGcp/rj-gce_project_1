variable "region" {
    default = "us-west4"
}
variable "zone" {
    default = "us-west4-a"
}

variable "amount" {
    default = "1"
}
variable "name_prefix" {
    default = "rj"
}
variable "machine_type" {
    default = "f1-micro"
}

variable "disk_type" {
  default = "pd-ssd"
}

variable "disk_size" {
    default = "10"
}
variable "disk_image" {
    default = "ubuntu-minimal-2004-focal-v20211120"
}

# variable "disk_create_local_exec_command_or_fail" {
#   default = ":"
# }

# variable "disk_create_local_exec_command_and_continue" {
#   default = ":"
# }

# variable "disk_destroy_local_exec_command_or_fail" {
#   default = ":"
# }

# variable "disk_destroy_local_exec_command_and_continue" {
#   default = ":"
# }
