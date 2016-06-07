# Subnet
resource "aws_subnet" "private" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(split(",", var.cidrs), count.index)}"
  availability_zone       = "${element(split(",", var.azs), count.index)}"
  count                   = "${length(split(",", var.cidrs))}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags {
    Name = "${var.name}.${element(split(",", var.azs), count.index)}"
  }
}

# Routes
resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(split(",", var.cidrs))}"

  tags {
    Name = "${var.name}.${element(split(",", var.azs), count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(split(",", var.cidrs))}"
}

resource "aws_route" "nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  count                  = "${length(split(",", var.cidrs))}"

  depends_on             = ["aws_route_table.private"]
}

# NAT
resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.nat_gateways_count}"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(split(",", var.public_subnet_ids), count.index)}"
  count         = "${var.nat_gateways_count}"
}
