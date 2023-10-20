resource "ncloud_server" "server" {
    name = "sportspie-server"
    server_image_product_code = "SPSW0LINUX000130"
    server_product_code = "SPSVRSTAND000003"
}

resource "ncloud_public_ip" "public_ip" {
  server_instance_no = "20131099"
}
