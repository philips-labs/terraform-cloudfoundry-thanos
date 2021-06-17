resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
}

locals {
  postfix = var.name_postfix != "" ? var.name_postfix : random_id.id.hex
}