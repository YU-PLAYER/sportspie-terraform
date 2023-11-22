variable "access_key" {
  description = "NCP accesskey"
  type        = string
}

variable "secret_key" {
  description = "NCP accesskey"
  type        = string
}

variable "region" {
    description = "NCP region"
    default = "KR"
}

variable "site" {
    description = "NCP site"
    default = "public"
}

variable "support_vpc" {
    description = "NCP support vpc"
    default = "true"
}

variable "zones" {
  default = "KR-2"
}

variable "terraform_name" {
  default = "sportspie"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_no" {
  description = "vpc number"
  default = "51125"
}
variable "sunbet_public_id" {
  description = "public subnet id"
  default = "114919"
}