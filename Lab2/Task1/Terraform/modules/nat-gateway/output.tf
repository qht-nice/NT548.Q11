output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.eip.public_ip
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}
