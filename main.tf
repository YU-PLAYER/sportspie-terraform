resource "ncloud_vpc" "vpc" {
  name = "sportspie-vpc"
  ipv4_cidr_block = "10.0.0.0/16"
}

resource "ncloud_network_acl" "nacl" {
  vpc_no = ncloud_vpc.vpc.id
}