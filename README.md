![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-a1

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform module to launch Ampere A1 Shapes on Oracle Cloud Infrastructure (OCI) Free-Tier

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/AmpereComputing/terraform-oci-ampere-a1/releases/download/latest/oci-ampere-a1-latest.zip)

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free)

## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).
To keep things simple, The root compartment will be used (compartment id and tenancy id are the same) when launching the instance.  

Addtional tasks performed by this code:

* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id..
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance.
* Launch 1 to 4 Ampere A1 instances with metadata and ssh keys.
* Output IP information to connect to the instance.

To get started clone this repository from GitHub locally.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
Please note that Compartment OCID are the same as Tenancy OCID for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
private_key_path = "/home/bwayne/.oci/oracleidentitycloudservice_bwayne-08-09-14-59.pem"
```

### Using as a Module

This can also be used as a terraform module.   The [examples](examples) directory contains example code for module usage showing different operating systems booting with a custom cloud-init templates.   Doing a clone of this repository and changing directory to one of the examples, placing a terraform.tfvars into that directory, and running a typical terrafornm workflow will produce a working virtual machine in the os that was specified in the main.tf that is located within the chosen example directory.

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

<script id="asciicast-432487" src="https://asciinema.org/a/432487.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Running OpenTofu

```
tofu init && tofu plan && tofu apply -auto-approve
```

### Additional Terraform resources for OCI Ampere A1

* Apache Tomcat on Ampere A1: [https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous](https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous)
* WordPress on Ampere A1: [https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo](https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo)

### Using as a Module

This can also be used as a terraform module.   The [examples](examples) directory contains example code for module usage showing different operating systems booting with a custom cloud-init templates.   Doing a clone of this repository and changing directory to one of the examples, placing a terraform.tfvars into that directory, and running a typical terrafornm workflow will produce a working virtual machine in the os that was specified in the main.tf that is located within the chosen example directory.

<!-- BEGIN_TF_DOCS -->
## Example AlmaLinux 8

```hcl
# Example of Ampere A1 running AlmaLinux 8 on OCI using this module
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
  oci_os_image             = "almalinux8"
  instance_prefix          = "ampere-a1-almalinux-8"
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
```

## Example AlmaLinux 9

```hcl
# Example of Ampere A1 running AlmaLinux 9 on OCI using this module
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
  oci_os_image             = "almalinux9"
  instance_prefix          = "ampere-a1-almalinux-9"
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
```

## Example FreeBSD 13.1

```hcl
# Example of Ampere A1 running FreeBSD 13.1 on OCI using this module
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
  oci_os_image             = "freebsd"
  instance_prefix          = "ampere-a1-freebsd"
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
```

## Example OpenMandriva

```hcl
# Example of Ampere A1 running OpenMandriva on OCI using this module
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
  oci_os_image             = "openmandriva"
  instance_prefix          = "ampere-a1-openmandriva"
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
```

## Example OracleLinux 7.9

```hcl
# Example of Ampere A1 running OracleLinux 7.9 on OCI using this module
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
  oci_os_image             = "oraclelinux79"
  instance_prefix          = "ampere-a1-oraclelinux-79"
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
```

## Example OracleLinux 8

```hcl
# Example of Ampere A1 running OracleLinux 8 on OCI using this module
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
  oci_os_image             = "oraclelinux8"
  instance_prefix          = "ampere-a1-oraclelinux-8"
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
```

## Example Ubuntu 18.04

```hcl
# Example of Ampere A1 running Ubuntu 18.04 on OCI using this module
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
  oci_os_image             = "ubuntu1804"
  instance_prefix          = "ampere-a1-ubuntu-1804"
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
```

## Example Ubuntu 20.04

```hcl
# Example of Ampere A1 running Ubuntu 20.04 on OCI using this module
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
  oci_os_image             = "ubuntu2004"
  instance_prefix          = "ampere-a1-ubuntu-2004"
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
```

## Example Ubuntu 22.04

```hcl
# Example of Ampere A1 running Ubuntu 22.04 on OCI using this module
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
  oci_os_image             = "ubuntu2204"
  instance_prefix          = "ampere-a1-ubuntu-2204"
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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ampere_a1_cpu_core_count"></a> [ampere\_a1\_cpu\_core\_count](#input\_ampere\_a1\_cpu\_core\_count) | Default core count for Ampere A1 instances in OCI Free Tier | `string` | `"4"` | no |
| <a name="input_ampere_a1_shape"></a> [ampere\_a1\_shape](#input\_ampere\_a1\_shape) | n/a | `string` | `"VM.Standard.A1.Flex"` | no |
| <a name="input_ampere_a1_vm_memory"></a> [ampere\_a1\_vm\_memory](#input\_ampere\_a1\_vm\_memory) | Default RAM in GB for Ampere A1 instances in OCI Free Tier | `string` | `"24"` | no |
| <a name="input_cloud_init_template_file"></a> [cloud\_init\_template\_file](#input\_cloud\_init\_template\_file) | Optional path for a cloud-init file | `string` | `null` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | OCI Fingerprint ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_instance_prefix"></a> [instance\_prefix](#input\_instance\_prefix) | Name prefix for vm instances | `string` | `"ampere-a1-"` | no |
| <a name="input_oci_os_image"></a> [oci\_os\_image](#input\_oci\_os\_image) | Default OS Image From the Local Vars | `string` | `"oraclelinux84"` | no |
| <a name="input_oci_vcn_cidr_block"></a> [oci\_vcn\_cidr\_block](#input\_oci\_vcn\_cidr\_block) | CIDR Address range for OCI Networks | `string` | `"10.2.0.0/16"` | no |
| <a name="input_oci_vcn_cidr_subnet"></a> [oci\_vcn\_cidr\_subnet](#input\_oci\_vcn\_cidr\_subnet) | CIDR Address range for OCI Networks | `string` | `"10.2.1.0/24"` | no |
| <a name="input_oci_vm_count"></a> [oci\_vm\_count](#input\_oci\_vm\_count) | OCI Free Tier Ampere A1 is two instances | `number` | `1` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Local path to the OCI private key file | `any` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCI Tenancy ID for Free-Tier Account | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCI User ID for Free-Tier Account | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_OCI_AlmaLinux_8_OS_Image_id"></a> [OCI\_AlmaLinux\_8\_OS\_Image\_id](#output\_OCI\_AlmaLinux\_8\_OS\_Image\_id) | Output OCI AlmaLinux 8 Image ID |
| <a name="output_OCI_AlmaLinux_9_OS_Image_id"></a> [OCI\_AlmaLinux\_9\_OS\_Image\_id](#output\_OCI\_AlmaLinux\_9\_OS\_Image\_id) | Output OCI AlmaLinux 9 Image ID |
| <a name="output_OCI_Availability_Domains"></a> [OCI\_Availability\_Domains](#output\_OCI\_Availability\_Domains) | Output Availability Domain Results |
| <a name="output_OCI_FreeBSD_OS_Image_id"></a> [OCI\_FreeBSD\_OS\_Image\_id](#output\_OCI\_FreeBSD\_OS\_Image\_id) | Output OCI FreeBSD Image ID |
| <a name="output_OCI_OpenMandriva_Linux_Image_id"></a> [OCI\_OpenMandriva\_Linux\_Image\_id](#output\_OCI\_OpenMandriva\_Linux\_Image\_id) | Output OCI OpenMandriva Image ID |
| <a name="output_OracleLinux-7_9-aarch64-latest-name"></a> [OracleLinux-7\_9-aarch64-latest-name](#output\_OracleLinux-7\_9-aarch64-latest-name) | Output OCI OracleLinux 7.9 Image Name |
| <a name="output_OracleLinux-7_9-aarch64-latest_ocid"></a> [OracleLinux-7\_9-aarch64-latest\_ocid](#output\_OracleLinux-7\_9-aarch64-latest\_ocid) | Output OCI OracleLinux 7.9 Image ID |
| <a name="output_OracleLinux-8-aarch64-latest-name"></a> [OracleLinux-8-aarch64-latest-name](#output\_OracleLinux-8-aarch64-latest-name) | Output OCI AlmaLinux 8 Image Name |
| <a name="output_OracleLinux-8-aarch64-latest_ocid"></a> [OracleLinux-8-aarch64-latest\_ocid](#output\_OracleLinux-8-aarch64-latest\_ocid) | Output OCI AlmaLinux 8 Image ID |
| <a name="output_OracleLinux-9-aarch64-latest-name"></a> [OracleLinux-9-aarch64-latest-name](#output\_OracleLinux-9-aarch64-latest-name) | Output OCI AlmaLinux 9 Image ID |
| <a name="output_OracleLinux-9-aarch64-latest_ocid"></a> [OracleLinux-9-aarch64-latest\_ocid](#output\_OracleLinux-9-aarch64-latest\_ocid) | Output OCI AlmaLinux 9 Image ID |
| <a name="output_Ubuntu-18_04-aarch64-latest_name"></a> [Ubuntu-18\_04-aarch64-latest\_name](#output\_Ubuntu-18\_04-aarch64-latest\_name) | Output OCI Ubuntu 18.04 Image Name |
| <a name="output_Ubuntu-18_04-aarch64-latest_ocid"></a> [Ubuntu-18\_04-aarch64-latest\_ocid](#output\_Ubuntu-18\_04-aarch64-latest\_ocid) | Output OCI Ubuntu 18.04 Image ID |
| <a name="output_Ubuntu-20_04-aarch64-latest_name"></a> [Ubuntu-20\_04-aarch64-latest\_name](#output\_Ubuntu-20\_04-aarch64-latest\_name) | Output OCI Ubuntu 20.04 Image Name |
| <a name="output_Ubuntu-20_04-aarch64-latest_ocid"></a> [Ubuntu-20\_04-aarch64-latest\_ocid](#output\_Ubuntu-20\_04-aarch64-latest\_ocid) | Output OCI Ubuntu 20.04 Image ID |
| <a name="output_Ubuntu-22_04-aarch64-latest_name"></a> [Ubuntu-22\_04-aarch64-latest\_name](#output\_Ubuntu-22\_04-aarch64-latest\_name) | Output OCI Ubuntu 22.04 Image Name |
| <a name="output_Ubuntu-22_04-aarch64-latest_ocid"></a> [Ubuntu-22\_04-aarch64-latest\_ocid](#output\_Ubuntu-22\_04-aarch64-latest\_ocid) | Output OCI Ubuntu 22.04 Image ID |
| <a name="output_ampere_a1_boot_volume_ids"></a> [ampere\_a1\_boot\_volume\_ids](#output\_ampere\_a1\_boot\_volume\_ids) | Output the boot volume IDs of the instance(s) |
| <a name="output_ampere_a1_private_ips"></a> [ampere\_a1\_private\_ips](#output\_ampere\_a1\_private\_ips) | Output the private IP(s) of the instance(s) |
| <a name="output_ampere_a1_public_ips"></a> [ampere\_a1\_public\_ips](#output\_ampere\_a1\_public\_ips) | Output the public IP(s) of the instance(s) |
| <a name="output_local_oci_aarch64_image_ids"></a> [local\_oci\_aarch64\_image\_ids](#output\_local\_oci\_aarch64\_image\_ids) | Output: List of available OCI image IDs |
| <a name="output_local_oci_aarch64_image_names"></a> [local\_oci\_aarch64\_image\_names](#output\_local\_oci\_aarch64\_image\_names) | Output: List of available OCI image names |
| <a name="output_local_oci_aarch64_images_map"></a> [local\_oci\_aarch64\_images\_map](#output\_local\_oci\_aarch64\_images\_map) | Output: the local map of the available oci image names and IDs |
| <a name="output_oci_aarch64_images_map"></a> [oci\_aarch64\_images\_map](#output\_oci\_aarch64\_images\_map) | Output: map of image names and image ids |
| <a name="output_oci_home_region"></a> [oci\_home\_region](#output\_oci\_home\_region) | Output: the home region of the tenancy |
| <a name="output_oci_ssh_private_key"></a> [oci\_ssh\_private\_key](#output\_oci\_ssh\_private\_key) | Output: The dynamically created openssh private key |
| <a name="output_oci_ssh_public_key"></a> [oci\_ssh\_public\_key](#output\_oci\_ssh\_public\_key) | Output: The dynamically created openssh public key |
| <a name="output_random_uuid"></a> [random\_uuid](#output\_random\_uuid) | Output: A randomly generated uuid |
<!-- END_TF_DOCS -->

## References

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)
* [Bootstrapping a VM image in Oracle Cloud Infrastructure using Cloud-Init](https://martincarstenbach.wordpress.com/2018/11/30/bootstrapping-a-vm-image-in-oracle-cloud-infrastructure-using-cloud-init/)
* [Oracle makes building applications on Ampere A1 Compute instances easy](https://blogs.oracle.com/cloud-infrastructure/post/oracle-makes-building-applications-on-ampere-a1-compute-instances-easy?source=:ow:o:p:nav:062520CloudComputeBC)
* [scross01/oci-linux-instance-cloud-init.tf](https://gist.github.com/scross01/5a66207fdc731dd99869a91461e9e2b8)
* [scross01/autonomous_linux_7.7.tf](https://gist.github.com/scross01/bcd21c12b15787f3ae9d51d0d9b2df06)
* [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/#always-free)
* [OCI Terraform Level 200](https://www.oracle.com/a/ocom/docs/terraform-200.pdf)
* [OCI Deploy Button](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/Tasks/deploybutton.htm)
* [Working with OCI Marketplace Stacks](https://www.abhinavkotnala.com/?p=377)
