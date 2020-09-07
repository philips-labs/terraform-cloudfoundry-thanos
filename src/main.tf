resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 16
}
