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
resource "ncloud_login_key" "was_key" {
  key_name = "${var.terraform_name}-was-key"
}

resource "local_file" "ncp_pem" {
  filename = "${ncloud_login_key.was_key.key_name}.pem"
  content = ncloud_login_key.was_key.private_key
}

resource "ncloud_access_control_group" "web_acg_01" {
  name        = "${var.terraform_name}-acg00"
  description = "${var.terraform_name} Access controle group"
  vpc_no      = var.vpc_no
}

resource "ncloud_access_control_group" "was_acg_01" {
  name        = "${var.terraform_name}-acg01"
  description = "${var.terraform_name} Access controle group"
  vpc_no      = var.vpc_no
}

resource "ncloud_access_control_group" "db_acg_01" {
  name        = "${var.terraform_name}-acg02"
  description = "${var.terraform_name} Access controle group"
  vpc_no      = var.vpc_no
}

resource "ncloud_access_control_group_rule" "web_acg_rule_01" {
  access_control_group_no = ncloud_access_control_group.web_acg_01.id
  
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port(all ip)"
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

resource "ncloud_access_control_group_rule" "was_acg_rule_01" {
  access_control_group_no = ncloud_access_control_group.was_acg_01.id
  
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port(all ip)"
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

resource "ncloud_access_control_group_rule" "db_acg_rule_01" {
  access_control_group_no = ncloud_access_control_group.db_acg_01.id
  
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "accept 22 port(all ip)"
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

resource "ncloud_network_interface" "web_nic" {
  name                  = "${var.terraform_name}-web-nic"
  subnet_no             = var.sunbet_public_id
  access_control_groups = [ncloud_access_control_group.web_acg_01.id]
}

resource "ncloud_network_interface" "was_nic" {
  name                  = "${var.terraform_name}-was-nic"
  subnet_no             = var.sunbet_public_id
  access_control_groups = [ncloud_access_control_group.was_acg_01.id]
}

resource "ncloud_network_interface" "db_nic" {
  name                  = "${var.terraform_name}-db-nic"
  subnet_no             = var.sunbet_public_id
  access_control_groups = [ncloud_access_control_group.db_acg_01.id]
}

resource "ncloud_server" "web_server" {
    subnet_no = var.sunbet_public_id
    name = "${var.terraform_name}-web"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = "SVR.VSVR.STAND.C002.M008.NET.HDD.B050.G002"
    login_key_name = ncloud_login_key.was_key.key_name
    network_interface   {
      network_interface_no = ncloud_network_interface.web_nic.id
      order = 0
  }
}

resource "ncloud_server" "was_server" {
    subnet_no = var.sunbet_public_id
    name = "${var.terraform_name}-was"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = "SVR.VSVR.STAND.C002.M008.NET.HDD.B050.G002"
    login_key_name = ncloud_login_key.was_key.key_name
    network_interface   {
      network_interface_no = ncloud_network_interface.was_nic.id
      order = 0
  }
}

resource "ncloud_server" "db_server" {
    subnet_no = var.sunbet_public_id
    name = "${var.terraform_name}-db"
    server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"
    server_product_code = "SVR.VSVR.STAND.C002.M008.NET.HDD.B050.G002"
    login_key_name = ncloud_login_key.was_key.key_name
    network_interface   {
      network_interface_no = ncloud_network_interface.db_nic.id
      order = 0
  }
}

data "ncloud_root_password" "default" {
  server_instance_no = ncloud_server.was_server.instance_no
  private_key = ncloud_login_key.was_key.private_key
}

resource "local_file" "was_root_pw" {
  filename = "${ncloud_server.was_server.name}-root_password.txt"
  content = "${ncloud_server.was_server.name} => ${data.ncloud_root_password.default.root_password}"
}

resource "ncloud_public_ip" "web_ip" {
  server_instance_no = ncloud_server.web_server.id
  description        = "for ${ncloud_server.web_server.name} public ip"
}

resource "ncloud_public_ip" "was_ip" {
  server_instance_no = ncloud_server.was_server.id
  description        = "for ${ncloud_server.was_server.name} public ip"
}

resource "ncloud_public_ip" "db_ip" {
  server_instance_no = ncloud_server.db_server.id
  description        = "for ${ncloud_server.db_server.name} public ip"
}