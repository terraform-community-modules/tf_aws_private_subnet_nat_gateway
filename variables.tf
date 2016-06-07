variable "name" {
  default = "private"
}
variable "cidrs" {}
variable "azs" {}
variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "nat_gateways_count" {}
variable "map_public_ip_on_launch" {
  default = true
}
