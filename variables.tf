variable "region" {
  default = "us-west4"
}
variable "zone" {
  default = "us-west4-a"
}

variable "amount" {
  default = "1"
}
variable "instance_name" {
  default = "p-a-cos"
}
variable "machine_type" {
  default = "n2-standard-2"
}

variable "disk_type" {
  default = "pd-ssd"
}

variable "disk_size" {
  default = "50"
}
variable "disk_image" {
  default = "windows-server-20h2-dc-core-v20211115"
}
variable "network" {
  default = "default"
}
variable "tags" {
   default = ["rj", "rj"]
}
variable "qa_tags" {
   default = ["qa_rj", "qa_rj"]
}