output "subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "private_route_table_ids" {
  value = "${join(",", aws_route_table.private.*.id)}"
}

output "nat_eips" {
  value = "${join(",", aws_eip.nat.*.public_ip)}"
}
