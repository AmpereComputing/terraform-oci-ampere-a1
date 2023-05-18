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

This can also be used as a terraform module.   The following is example code for module usage supplying a custom cloud-init template:


```
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
  oci_os_image             = "oraclelinux84"
  instance_prefix          = "ampere-a1-oraclelinux-84"
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

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```


<script id="asciicast-432487" src="https://asciinema.org/a/432487.js" async data-autoplay="true" data-size="small" data-speed="2"></script>


### Additional Terraform resources for OCI Ampere A1

* Apache Tomcat on Ampere A1: [https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous](https://github.com/oracle-devrel/terraform-oci-arch-tomcat-autonomous)
* WordPress on Ampere A1: [https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo](https://github.com/oracle-quickstart/oci-arch-wordpress-mds/tree/master/matomo)


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

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.oci-ssh-privkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.oci-ssh-pubkey](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [oci_core_app_catalog_listing_resource_version_agreement.almalinux_8_app_catalog_listing_resource_version_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_listing_resource_version_agreement) | resource |
| [oci_core_app_catalog_listing_resource_version_agreement.almalinux_9_app_catalog_listing_resource_version_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_listing_resource_version_agreement) | resource |
| [oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_listing_resource_version_agreement) | resource |
| [oci_core_app_catalog_listing_resource_version_agreement.openmandriva_app_catalog_listing_resource_version_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_listing_resource_version_agreement) | resource |
| [oci_core_app_catalog_subscription.almalinux_8_app_catalog_subscription](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_subscription) | resource |
| [oci_core_app_catalog_subscription.almalinux_9_app_catalog_subscription](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_subscription) | resource |
| [oci_core_app_catalog_subscription.freebsd_app_catalog_subscription](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_subscription) | resource |
| [oci_core_app_catalog_subscription.openmandriva_app_catalog_subscription](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_app_catalog_subscription) | resource |
| [oci_core_instance.ampere_a1](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.ampere_internet_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_route_table.ampere_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.ampere_security_list](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.ampere_subnet](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_virtual_network.ampere_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_virtual_network) | resource |
| [oci_marketplace_accepted_agreement.almalinux_8_accepted_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_accepted_agreement) | resource |
| [oci_marketplace_accepted_agreement.almalinux_9_accepted_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_accepted_agreement) | resource |
| [oci_marketplace_accepted_agreement.freebsd_accepted_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_accepted_agreement) | resource |
| [oci_marketplace_accepted_agreement.openmandriva_accepted_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_accepted_agreement) | resource |
| [oci_marketplace_listing_package_agreement.almalinux_8_package_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_listing_package_agreement) | resource |
| [oci_marketplace_listing_package_agreement.almalinux_9_package_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_listing_package_agreement) | resource |
| [oci_marketplace_listing_package_agreement.freebsd_package_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_listing_package_agreement) | resource |
| [oci_marketplace_listing_package_agreement.openmandriva_package_agreement](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/marketplace_listing_package_agreement) | resource |
| [random_uuid.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [tls_private_key.oci](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_core_app_catalog_listing_resource_version.almalinux_8_catalog_listing](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_version) | data source |
| [oci_core_app_catalog_listing_resource_version.almalinux_9_catalog_listing](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_version) | data source |
| [oci_core_app_catalog_listing_resource_version.freebsd_catalog_listing](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_version) | data source |
| [oci_core_app_catalog_listing_resource_version.openmandriva_catalog_listing](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_version) | data source |
| [oci_core_app_catalog_listing_resource_versions.almalinux_8_app_catalog_listing_resource_versions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_versions) | data source |
| [oci_core_app_catalog_listing_resource_versions.almalinux_9_app_catalog_listing_resource_versions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_versions) | data source |
| [oci_core_app_catalog_listing_resource_versions.freebsd_app_catalog_listing_resource_versions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_versions) | data source |
| [oci_core_app_catalog_listing_resource_versions.openmandriva_app_catalog_listing_resource_versions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_app_catalog_listing_resource_versions) | data source |
| [oci_core_images.oraclelinux-7_9-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.oraclelinux-8-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.oraclelinux-9-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.ubuntu-18_04-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.ubuntu-20_04-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.ubuntu-22_04-aarch64](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_regions.regions](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_regions) | data source |
| [oci_identity_tenancy.tenancy](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |
| [oci_marketplace_listing.almalinux_8](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing) | data source |
| [oci_marketplace_listing.almalinux_9](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing) | data source |
| [oci_marketplace_listing.freebsd](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing) | data source |
| [oci_marketplace_listing.openmandriva](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing) | data source |
| [oci_marketplace_listing_package.almalinux_8_package](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package) | data source |
| [oci_marketplace_listing_package.almalinux_9_package](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package) | data source |
| [oci_marketplace_listing_package.freebsd_package](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package) | data source |
| [oci_marketplace_listing_package.openmandriva_package](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package) | data source |
| [oci_marketplace_listing_package_agreements.almalinux_8_package_agreements](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package_agreements) | data source |
| [oci_marketplace_listing_package_agreements.almalinux_9_package_agreements](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package_agreements) | data source |
| [oci_marketplace_listing_package_agreements.freebsd_package_agreements](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package_agreements) | data source |
| [oci_marketplace_listing_package_agreements.openmandriva_package_agreements](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_package_agreements) | data source |
| [oci_marketplace_listing_packages.almalinux_8_packages](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_packages) | data source |
| [oci_marketplace_listing_packages.almalinux_9_packages](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_packages) | data source |
| [oci_marketplace_listing_packages.freebsd_packages](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_packages) | data source |
| [oci_marketplace_listing_packages.openmandriva_packages](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listing_packages) | data source |
| [oci_marketplace_listings.almalinux_8](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listings) | data source |
| [oci_marketplace_listings.almalinux_9](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listings) | data source |
| [oci_marketplace_listings.freebsd](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listings) | data source |
| [oci_marketplace_listings.openmandriva](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/marketplace_listings) | data source |

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
| <a name="output_OCI_AlmaLinux_8_OS_Image_id"></a> [OCI\_AlmaLinux\_8\_OS\_Image\_id](#output\_OCI\_AlmaLinux\_8\_OS\_Image\_id) | n/a |
| <a name="output_OCI_AlmaLinux_9_OS_Image_id"></a> [OCI\_AlmaLinux\_9\_OS\_Image\_id](#output\_OCI\_AlmaLinux\_9\_OS\_Image\_id) | n/a |
| <a name="output_OCI_Availability_Domains"></a> [OCI\_Availability\_Domains](#output\_OCI\_Availability\_Domains) | Output Availability Domain Results |
| <a name="output_OCI_FreeBSD_OS_Image_id"></a> [OCI\_FreeBSD\_OS\_Image\_id](#output\_OCI\_FreeBSD\_OS\_Image\_id) | n/a |
| <a name="output_OCI_OpenMandriva_Linux_Image_id"></a> [OCI\_OpenMandriva\_Linux\_Image\_id](#output\_OCI\_OpenMandriva\_Linux\_Image\_id) | n/a |
| <a name="output_OracleLinux-7_9-aarch64-latest-name"></a> [OracleLinux-7\_9-aarch64-latest-name](#output\_OracleLinux-7\_9-aarch64-latest-name) | n/a |
| <a name="output_OracleLinux-7_9-aarch64-latest_ocid"></a> [OracleLinux-7\_9-aarch64-latest\_ocid](#output\_OracleLinux-7\_9-aarch64-latest\_ocid) | n/a |
| <a name="output_OracleLinux-8-aarch64-latest-name"></a> [OracleLinux-8-aarch64-latest-name](#output\_OracleLinux-8-aarch64-latest-name) | n/a |
| <a name="output_OracleLinux-8-aarch64-latest_ocid"></a> [OracleLinux-8-aarch64-latest\_ocid](#output\_OracleLinux-8-aarch64-latest\_ocid) | n/a |
| <a name="output_OracleLinux-9-aarch64-latest-name"></a> [OracleLinux-9-aarch64-latest-name](#output\_OracleLinux-9-aarch64-latest-name) | n/a |
| <a name="output_OracleLinux-9-aarch64-latest_ocid"></a> [OracleLinux-9-aarch64-latest\_ocid](#output\_OracleLinux-9-aarch64-latest\_ocid) | n/a |
| <a name="output_Ubuntu-18_04-aarch64-latest_name"></a> [Ubuntu-18\_04-aarch64-latest\_name](#output\_Ubuntu-18\_04-aarch64-latest\_name) | n/a |
| <a name="output_Ubuntu-18_04-aarch64-latest_ocid"></a> [Ubuntu-18\_04-aarch64-latest\_ocid](#output\_Ubuntu-18\_04-aarch64-latest\_ocid) | n/a |
| <a name="output_Ubuntu-20_04-aarch64-latest_name"></a> [Ubuntu-20\_04-aarch64-latest\_name](#output\_Ubuntu-20\_04-aarch64-latest\_name) | n/a |
| <a name="output_Ubuntu-20_04-aarch64-latest_ocid"></a> [Ubuntu-20\_04-aarch64-latest\_ocid](#output\_Ubuntu-20\_04-aarch64-latest\_ocid) | n/a |
| <a name="output_Ubuntu-22_04-aarch64-latest_name"></a> [Ubuntu-22\_04-aarch64-latest\_name](#output\_Ubuntu-22\_04-aarch64-latest\_name) | n/a |
| <a name="output_Ubuntu-22_04-aarch64-latest_ocid"></a> [Ubuntu-22\_04-aarch64-latest\_ocid](#output\_Ubuntu-22\_04-aarch64-latest\_ocid) | n/a |
| <a name="output_ampere_a1_boot_volume_ids"></a> [ampere\_a1\_boot\_volume\_ids](#output\_ampere\_a1\_boot\_volume\_ids) | Output the boot volume IDs of the instance |
| <a name="output_ampere_a1_private_ips"></a> [ampere\_a1\_private\_ips](#output\_ampere\_a1\_private\_ips) | n/a |
| <a name="output_ampere_a1_public_ips"></a> [ampere\_a1\_public\_ips](#output\_ampere\_a1\_public\_ips) | n/a |
| <a name="output_local_oci_aarch64_image_ids"></a> [local\_oci\_aarch64\_image\_ids](#output\_local\_oci\_aarch64\_image\_ids) | n/a |
| <a name="output_local_oci_aarch64_image_names"></a> [local\_oci\_aarch64\_image\_names](#output\_local\_oci\_aarch64\_image\_names) | n/a |
| <a name="output_local_oci_aarch64_images_map"></a> [local\_oci\_aarch64\_images\_map](#output\_local\_oci\_aarch64\_images\_map) | n/a |
| <a name="output_oci_aarch64_images_map"></a> [oci\_aarch64\_images\_map](#output\_oci\_aarch64\_images\_map) | n/a |
| <a name="output_oci_home_region"></a> [oci\_home\_region](#output\_oci\_home\_region) | n/a |
| <a name="output_oci_ssh_private_key"></a> [oci\_ssh\_private\_key](#output\_oci\_ssh\_private\_key) | n/a |
| <a name="output_oci_ssh_public_key"></a> [oci\_ssh\_public\_key](#output\_oci\_ssh\_public\_key) | n/a |
| <a name="output_random_uuid"></a> [random\_uuid](#output\_random\_uuid) | n/a |
<!-- END_TF_DOCS -->