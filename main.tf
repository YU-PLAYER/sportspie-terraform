resource "ncloud_vpc" "vpc" {
  name = "${var.terraform_name}-vpc"
  ipv4_cidr_block = "10.0.0.0/16"
}

resource "ncloud_network_acl" "nacl" {
  vpc_no = ncloud_vpc.vpc.id
}

resource "ncloud_subnet" "subnet" {
  name = "${var.terraform_name}-public"
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "10.0.0.0/24"
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}