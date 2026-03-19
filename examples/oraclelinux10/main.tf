# Example of Ampere A1 running OracleLinux 9 on OCI using this module
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
locals {
  cloud_init_template_path = "${path.cwd}/cloud-init.yaml.tpl"
}
module "oci-ampere-a1" {
  source                   = "github.com/amperecomputing/terraform-oci-ampere-a1"
  tenancy_ocid             = var.tenancy_ocid
  user_ocid                = var.user_ocid
  fingerprint              = var.fingerprint
  private_key_path         = var.private_key_path
# Optional
# oci_vcn_cidr_block       = "10.2.0.0/16"
# oci_vcn_cidr_subnet      = "10.2.1.0/24"
  oci_os_image             = "oraclelinux9"
  instance_prefix          = "ampere-a1-oraclelinux-9"
  oci_vm_count             = "1"
  ampere_a1_vm_memory      = "24"
  ampere_a1_cpu_core_count = "4"
  cloud_init_template_file = local.cloud_init_template_path
}
output "oci_ampere_a1_private_ips" {
  value     = module.oci-ampere-a1.ampere_a1_private_ips
}
output "oci_ampere_a1_public_ips" {
  value     = module.oci-ampere-a1.ampere_a1_public_ips
}
