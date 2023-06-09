terraform {
  required_version = ">= 1.3.0"
}

variable "vcn_name" {}
variable "region" {}
variable "nf_subnet_cidr" {}
variable "nf_router_registration_key_list" {}

module "vcn1" {
  source = "../modules/m-gcp-network"
  vcn_name = var.vcn_name
  region = var.region
  nf_subnet_cidr = var.nf_subnet_cidr
  create_vcn = true
}

module "compute1" {
  depends_on = [
    module.vcn1
  ]
  source = "../modules/m-gcp-compute"
  region = var.region
  er_ssh_public_key = "~/.ssh/id_rsa.pub"
  er_reg_keys = var.nf_router_registration_key_list
}
/*
module "nlb1" {
  depends_on = [
    module.compute1
  ]
  source = "../modules/m-gcp-nlb"
  region = var.region
}
*/

output "instance_public_ips" {value = module.compute1.instance_public_ips}
output "instance_private_ips" { value = module.compute1.instance_private_ips}
