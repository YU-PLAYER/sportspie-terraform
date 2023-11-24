/*
** network
*/
resource "ncloud_vpc" "vpc" {
  name = "${var.terraform_name}-vpc"
  ipv4_cidr_block = var.vpc_cidr
}

resource "ncloud_network_acl" "nacl" {
  vpc_no = ncloud_vpc.vpc.id
}

resource "ncloud_subnet" "subnet_public" {
  name = "${var.terraform_name}-public"
  vpc_no = ncloud_vpc.vpc.id
  subnet = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 0) // "10.0.0.0/24"
  zone = var.zones
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type = "PUBLIC"
}

/*
** server
*/
resource "ncloud_login_key" "sportspie_key" {
  key_name = "${var.terraform_name}-key"
}

resource "local_file" "ncp_pem" {
  filename = "${ncloud_login_key.sportspie_key.key_name}.pem"
  content = ncloud_login_key.sportspie_key.private_key
}

resource "ncloud_access_control_group" "sportspie_acg_01" {
  name        = "${var.terraform_name}-acg001"
  description = "${var.terraform_name} Access controle group"
  vpc_no      = var.vpc_no
}

resource "ncloud_access_control_group_rule" "sportspie_acg_rule_01" {
  access_control_group_no = ncloud_access_control_group.sportspie_acg_01.id
  
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "80"
    description = "accept 80 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "8080"
    description = "accept 8080 port(all ip)"
  }
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "3306"
    description = "accept 8080 port(all ip)"
  }
  outbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept TCP 1-65535 port"
  }
  outbound {
    protocol    = "UDP"
    ip_block    = "0.0.0.0/0" 
    port_range  = "1-65535"
    description = "accept UDP 1-65535 port"
  }
  outbound {
    protocol    = "ICMP"
    ip_block    = "0.0.0.0/0" 
    description = "accept ICMP"
  }
}

resource "ncloud_network_interface" "sportspie_nic" {
  name                  = "${var.terraform_name}-nic"
  subnet_no             = var.sunbet_public_id
  access_control_groups = [ncloud_access_control_group.sportspie_acg_01.id]
}

resource "ncloud_server" "server" {
    subnet_no = var.sunbet_public_id
    name = "${var.terraform_name}-server"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = "SVR.VSVR.STAND.C002.M008.NET.HDD.B050.G002"
    login_key_name = ncloud_login_key.sportspie_key.key_name
    network_interface   {
      network_interface_no = ncloud_network_interface.sportspie_nic.id
      order = 0
  }
}

data "ncloud_root_password" "sportspie_default" {
  server_instance_no = ncloud_server.server.instance_no
  private_key = ncloud_login_key.sportspie_key.private_key
}

resource "local_file" "sportspie_root_pw" {
  filename = "${ncloud_server.server.name}-root_password.txt"
  content = "${ncloud_server.server.name} => ${data.ncloud_root_password.sportspie_default.root_password}"
}

resource "ncloud_public_ip" "server_ip" {
  server_instance_no = ncloud_server.server.id
  description        = "for ${ncloud_server.server.name} public ip"
}