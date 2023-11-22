output "vpc_no" {
  value       = ncloud_vpc.vpc.vpc_no
}

output "subnet_cidr" {
  value       = ncloud_vpc.vpc.ipv4_cidr_block
}

output "subnet_id" {
  value       = ncloud_subnet.subnet_public.id
}