![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Getting Cloud-Native with FreeBSD on Ampere

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
  * [Terraform](#terraform)
  * [Oracle OCI "Always Free" Account](#oracle-oci-always-free-account)
* [What exactly is Terraform doing](#what-exactly-is-terraform-doing)
* [Configuration with terraform.tfvars](#configuration-with-terraform-tfvars)
* [Creating a cloud-init template](#creating-a-cloud-init-template)
* [Using as a Module](#using-as-a-module)
* [Running Terraform](#running-terraform)
* [References](#references)

## Introduction

Here at [Ampere Computing](https://amperecomputing.com) we are always interested in diverse workloads for our cloud-native Ampere(R) Altra(TM) Aarch64 processors, and that includes down to the the choose of your Operating System. [FreeBSD](https://freebsd.org) is an active open source software project originally developed over 30 years ago focusing on features, speed, and stability. It is derived from BSD, the version of UNIX® developed at the University of California, Berkeley for servers, desktops and embedded systems.  It has been a staple in datacenters for years due to it's advanced networking, security and storage features, which have also made it a choice for powering diverse platforms amoungst some of the largest web and internet service providers.

From a technology perspective, [FreeBSD](https://freebsd.org) has similarities with Linux, with similar package management tooling and methods, packages, and open source software stacks available for installation easily.
For those unfamiliar with the FreeBSD user experence, it will seem similar to other unix or linux operation systems with simalar shells, remote management, compilers and development platforms easily avaible for quick installationa via package management. [FreeBSD](https://freebsd.org) and linux do have some major diffences to consider when deciding on which to use and why use it.  The first difference between [FreeBSD](https://freebsd.org) and Linux is in the scope of the project itself.  The [FreeBSD](https://freebsd.org) Project maintains a complete system. The project community delivers a kernel, device drivers, userland utilities, and documentation.  The scope of the Linux community on the other hand focuses on only delivering a kernel and drivers. The Linux Community relies on third-parties like Enterprise Linux vendors, and other Open Source Linux OS projects for system software to be curated.
The second and a major difference between [FreeBSD](https://freebsd.org) and Linux is in terms of how the project software is licensed.  FreeBSD source code is generally released under a permissive BSD license. The kernel code and most newly created code are released under the two-clause BSD license which allows everyone to use and redistribute FreeBSD as they wish. In general a lax, permissive non-copyleft free software license, compatible with the GNU GPL. The BSD license is intended to encourage product commercialization. BSD-licensed code can be sold or included in proprietary products without restriction on future behavior.
Linux is licensed with the GPL.  The GPL, while designed to prevent the proprietary commercialization of open source code, is considered a copyleft license and can still provide strategic advantage to a company deciding to build solutions using Linux.

Historically speaking, FreeBSD may not necessarily be considered the obvious choice when choosing a cloud-native OS for an instance within thier cloud provider, however it supports the same industry standard metadata interfaces for instance configurations as linux, [Cloud-Init](https://cloud-init.io), allowing you to automate your [FreeBSD] workloads, in a simlar fashion to other operating system options.  This makes it perfectly suitable when using on a cloud platform.

Now personally speaking I have been working with the great team at the [FreeBSD](https://freebsd.org) project for some time watching thier craftmanship, curating, iterating, and helping achive the "it just works" experience for Aarch64 and Ampere platforms and customers who choose to build and run solutions on [FreeBSD](https://freebsd.org). Recently [FreeBSD](https://freebsd.org) became available for use on Ampere A1 shapes within the [Oracle OCI](https://www.oracle.com/cloud/free/#always-free) marketplace.

In this post, we will build upon prevous work to quickly automate using [FreeBSD](https://freebsd.org) on Ampere(R) Altra(TM) Arm64 processors within Oracle Cloud Infrastructure using Ampere A1 shapes.

## Requirements

Obviously to begin you will need a couple things.  Personally I'm a big fan of the the DevOPs tools that support lots of api, and different use cases. [Terraform](https://www.terraform.io/downloads.html) is one of those types of tools.  If you have seen my prevous session with some members of the Oracle Cloud Infrastracture team, I build a terraform module to quickly get you started using Ampere plaforms on OCI.  Today we are going to use that module to launch a [FreeBSD](Instance) virtual machine while passing in some metadata to configure it.

 * [Terraform](https://www.terraform.io/downloads.html) will need be installed on your system. 
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free) and credentials for API use

## Using the oci-ampere-a1 terraform module

The [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module code supplies the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).  It has been updated to include the ability to easily select [FreeBSD](https://freebsd.org) as an option.  To keep things simple from an OCI perspective, the root compartment will be used (compartment id and tenancy id are the same) when launching any instances.  Addtional tasks performed by the [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module.

* Operating system image id discovery in the user region.
* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id.
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance.
* Launch 1 to 4 Ampere A1 instances with metadata and ssh keys.
* Output IP information to connect to the instance.

## Configuration with terraform.tfvars

For the purpose of this we will quickly configure Terraform using a terraform.tfvars in the project directory.  
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

### Creating a cloud init template.

```
#cloud-config
package_update: true
package_upgrade: true
packages:
  - tmux
  - rsync
  - git
  - curl
  - bzip2
  - python3
  - python3-devel
  - python3-pip-wheel
  - gcc
  - gcc-c++
  - bzip2
  - screen
groups:
  - ampere
system_info:
  default_user:
    groups: [ampere]
runcmd:
  - echo 'OCI Ampere FreeBSD Example' >> /etc/motd
```

### Running Terraform

Executing terraform is broken into three commands.   The first you must initialize the terraform project with the modules and necessary plugins to support proper execution.   The following command will do that:

```
terraform init
```

Below is output from a 'terraform init' execution within the project directory.

```
Initializing modules...
Downloading git::https://github.com/amperecomputing/terraform-oci-ampere-a1.git for oci-ampere-a1...
- oci-ampere-a1 in .terraform/modules/oci-ampere-a1

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/template...
- Finding latest version of oracle/oci...
- Finding latest version of hashicorp/tls...
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)
- Installing oracle/oci v4.89.0...
- Installed oracle/oci v4.89.0 (signed by a HashiCorp partner, key ID 1533A49284137CEB)
- Installing hashicorp/tls v4.0.1...
- Installed hashicorp/tls v4.0.1 (signed by HashiCorp)
- Installing hashicorp/local v2.2.3...
- Installed hashicorp/local v2.2.3 (signed by HashiCorp)
- Installing hashicorp/random v3.3.2...
- Installed hashicorp/random v3.3.2 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

After 'terraform init' is executed it is necessary to run 'plan' to see the tasks, steps and objects. that will be created by interacting with the cloud APIs.
Executing the following from a command line will do so:

```
terraform plan
```

The ouput from a 'terraform plan' execution in the project directy will look similar to the following:


```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.oci-ampere-a1.local_file.oci-ssh-privkey will be created
  + resource "local_file" "oci-ssh-privkey" {
      + content              = (sensitive)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "/home/ansible/src/terraform-oci-ampere-a1/examples/freebsd131/oci-id_rsa"
      + id                   = (known after apply)
    }

  # module.oci-ampere-a1.local_file.oci-ssh-pubkey will be created
  + resource "local_file" "oci-ssh-pubkey" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0644"
      + filename             = "/home/ansible/src/terraform-oci-ampere-a1/examples/freebsd131/oci-id_rsa.pub"
      + id                   = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.almalinux_8_app_catalog_listing_resource_version_agreement will be created
  + resource "oci_core_app_catalog_listing_resource_version_agreement" "almalinux_8_app_catalog_listing_resource_version_agreement" {
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaaiayknhrp2gsevmoano5i3253iv65q73pc6qzk4s2lrouoruz6zua"
      + listing_resource_version = "8.6.20220523"
      + oracle_terms_of_use_link = (known after apply)
      + signature                = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement will be created
  + resource "oci_core_app_catalog_listing_resource_version_agreement" "freebsd_app_catalog_listing_resource_version_agreement" {
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a"
      + listing_resource_version = "13.1"
      + oracle_terms_of_use_link = (known after apply)
      + signature                = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_subscription.almalinux_8_app_catalog_subscription will be created
  + resource "oci_core_app_catalog_subscription" "almalinux_8_app_catalog_subscription" {
      + compartment_id           = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + display_name             = (known after apply)
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaaiayknhrp2gsevmoano5i3253iv65q73pc6qzk4s2lrouoruz6zua"
      + listing_resource_id      = (known after apply)
      + listing_resource_version = "8.6.20220523"
      + oracle_terms_of_use_link = (known after apply)
      + publisher_name           = (known after apply)
      + signature                = (known after apply)
      + summary                  = (known after apply)
      + time_created             = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_subscription.freebsd_app_catalog_subscription will be created
  + resource "oci_core_app_catalog_subscription" "freebsd_app_catalog_subscription" {
      + compartment_id           = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + display_name             = (known after apply)
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a"
      + listing_resource_id      = (known after apply)
      + listing_resource_version = "13.1"
      + oracle_terms_of_use_link = (known after apply)
      + publisher_name           = (known after apply)
      + signature                = (known after apply)
      + summary                  = (known after apply)
      + time_created             = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_instance.ampere_a1[0] will be created
  + resource "oci_core_instance" "ampere_a1" {
      + availability_domain                 = "FFpD:CA-MONTREAL-1-AD-1"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
      + compartment_id                      = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + dedicated_vm_host_id                = (known after apply)
      + defined_tags                        = (known after apply)
      + display_name                        = "AmpereA1-0"
      + fault_domain                        = (known after apply)
      + freeform_tags                       = (known after apply)
      + hostname_label                      = (known after apply)
      + id                                  = (known after apply)
      + image                               = (known after apply)
      + ipxe_script                         = (known after apply)
      + is_pv_encryption_in_transit_enabled = (known after apply)
      + launch_mode                         = (known after apply)
      + metadata                            = (known after apply)
      + private_ip                          = (known after apply)
      + public_ip                           = (known after apply)
      + region                              = (known after apply)
      + shape                               = "VM.Standard.A1.Flex"
      + state                               = (known after apply)
      + subnet_id                           = (known after apply)
      + system_tags                         = (known after apply)
      + time_created                        = (known after apply)
      + time_maintenance_reboot_due         = (known after apply)

      + agent_config {
          + are_all_plugins_disabled = (known after apply)
          + is_management_disabled   = (known after apply)
          + is_monitoring_disabled   = (known after apply)

          + plugins_config {
              + desired_state = (known after apply)
              + name          = (known after apply)
            }
        }

      + availability_config {
          + is_live_migration_preferred = (known after apply)
          + recovery_action             = (known after apply)
        }

      + create_vnic_details {
          + assign_public_ip       = "true"
          + defined_tags           = (known after apply)
          + display_name           = "primaryvnic"
          + freeform_tags          = (known after apply)
          + hostname_label         = "ampere-a1-freebsd-01"
          + private_ip             = (known after apply)
          + skip_source_dest_check = (known after apply)
          + subnet_id              = (known after apply)
          + vlan_id                = (known after apply)
        }

      + instance_options {
          + are_legacy_imds_endpoints_disabled = (known after apply)
        }

      + launch_options {
          + boot_volume_type                    = (known after apply)
          + firmware                            = (known after apply)
          + is_consistent_volume_naming_enabled = (known after apply)
          + is_pv_encryption_in_transit_enabled = (known after apply)
          + network_type                        = (known after apply)
          + remote_data_volume_type             = (known after apply)
        }

      + platform_config {
          + are_virtual_instructions_enabled               = (known after apply)
          + is_access_control_service_enabled              = (known after apply)
          + is_input_output_memory_management_unit_enabled = (known after apply)
          + is_measured_boot_enabled                       = (known after apply)
          + is_secure_boot_enabled                         = (known after apply)
          + is_symmetric_multi_threading_enabled           = (known after apply)
          + is_trusted_platform_module_enabled             = (known after apply)
          + numa_nodes_per_socket                          = (known after apply)
          + percentage_of_cores_enabled                    = (known after apply)
          + type                                           = (known after apply)
        }

      + preemptible_instance_config {
          + preemption_action {
              + preserve_boot_volume = (known after apply)
              + type                 = (known after apply)
            }
        }

      + shape_config {
          + baseline_ocpu_utilization     = (known after apply)
          + gpu_description               = (known after apply)
          + gpus                          = (known after apply)
          + local_disk_description        = (known after apply)
          + local_disks                   = (known after apply)
          + local_disks_total_size_in_gbs = (known after apply)
          + max_vnic_attachments          = (known after apply)
          + memory_in_gbs                 = 24
          + networking_bandwidth_in_gbps  = (known after apply)
          + nvmes                         = (known after apply)
          + ocpus                         = 4
          + processor_description         = (known after apply)
        }

      + source_details {
          + boot_volume_size_in_gbs = (known after apply)
          + boot_volume_vpus_per_gb = (known after apply)
          + kms_key_id              = (known after apply)
          + source_id               = "ocid1.image.oc1..aaaaaaaayjatgvecms7kciqjx5exbj4dpcs3ympvpggpodwlfuezn7dejdja"
          + source_type             = "image"
        }
    }

  # module.oci-ampere-a1.oci_core_internet_gateway.ampere_internet_gateway will be created
  + resource "oci_core_internet_gateway" "ampere_internet_gateway" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "AmpereInternetGateway"
      + enabled        = true
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_route_table.ampere_route_table will be created
  + resource "oci_core_route_table" "ampere_route_table" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "AmpereRouteTable"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + route_rules {
          + cidr_block        = (known after apply)
          + description       = (known after apply)
          + destination       = "0.0.0.0/0"
          + destination_type  = "CIDR_BLOCK"
          + network_entity_id = (known after apply)
          + route_type        = (known after apply)
        }
    }

  # module.oci-ampere-a1.oci_core_security_list.ampere_security_list will be created
  + resource "oci_core_security_list" "ampere_security_list" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "ampereSecurityList"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + egress_security_rules {
          + description      = (known after apply)
          + destination      = "0.0.0.0/0"
          + destination_type = (known after apply)
          + protocol         = "6"
          + stateless        = (known after apply)
        }

      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 22
              + min = 22
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 3000
              + min = 3000
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 3005
              + min = 3005
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 80
              + min = 80
            }
        }
    }

  # module.oci-ampere-a1.oci_core_subnet.ampere_subnet will be created
  + resource "oci_core_subnet" "ampere_subnet" {
      + availability_domain        = (known after apply)
      + cidr_block                 = "10.2.1.0/24"
      + compartment_id             = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags               = (known after apply)
      + dhcp_options_id            = (known after apply)
      + display_name               = "AmpereSubnet"
      + dns_label                  = "Ampere"
      + freeform_tags              = (known after apply)
      + id                         = (known after apply)
      + ipv6cidr_block             = (known after apply)
      + ipv6cidr_blocks            = (known after apply)
      + ipv6virtual_router_ip      = (known after apply)
      + prohibit_internet_ingress  = (known after apply)
      + prohibit_public_ip_on_vnic = (known after apply)
      + route_table_id             = (known after apply)
      + security_list_ids          = (known after apply)
      + state                      = (known after apply)
      + subnet_domain_name         = (known after apply)
      + time_created               = (known after apply)
      + vcn_id                     = (known after apply)
      + virtual_router_ip          = (known after apply)
      + virtual_router_mac         = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_virtual_network.ampere_vcn will be created
  + resource "oci_core_virtual_network" "ampere_vcn" {
      + byoipv6cidr_blocks               = (known after apply)
      + cidr_block                       = "10.2.0.0/16"
      + cidr_blocks                      = (known after apply)
      + compartment_id                   = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + default_dhcp_options_id          = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_list_id         = (known after apply)
      + defined_tags                     = (known after apply)
      + display_name                     = "AmpereVirtualCoreNetwork"
      + dns_label                        = "amperevcn"
      + freeform_tags                    = (known after apply)
      + id                               = (known after apply)
      + ipv6cidr_blocks                  = (known after apply)
      + ipv6private_cidr_blocks          = (known after apply)
      + is_ipv6enabled                   = (known after apply)
      + is_oracle_gua_allocation_enabled = (known after apply)
      + state                            = (known after apply)
      + time_created                     = (known after apply)
      + vcn_domain_name                  = (known after apply)

      + byoipv6cidr_details {
          + byoipv6range_id = (known after apply)
          + ipv6cidr_block  = (known after apply)
        }
    }

  # module.oci-ampere-a1.oci_marketplace_accepted_agreement.almalinux_8_accepted_agreement will be created
  + resource "oci_marketplace_accepted_agreement" "almalinux_8_accepted_agreement" {
      + agreement_id    = "50511633"
      + compartment_id  = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags    = (known after apply)
      + display_name    = (known after apply)
      + freeform_tags   = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125567282"
      + package_version = "8.6.20220523"
      + signature       = (known after apply)
      + time_accepted   = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_accepted_agreement.freebsd_accepted_agreement will be created
  + resource "oci_marketplace_accepted_agreement" "freebsd_accepted_agreement" {
      + agreement_id    = "50511633"
      + compartment_id  = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags    = (known after apply)
      + display_name    = (known after apply)
      + freeform_tags   = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125980175"
      + package_version = "13.1"
      + signature       = (known after apply)
      + time_accepted   = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_listing_package_agreement.almalinux_8_package_agreement will be created
  + resource "oci_marketplace_listing_package_agreement" "almalinux_8_package_agreement" {
      + agreement_id    = "50511633"
      + author          = (known after apply)
      + compartment_id  = (known after apply)
      + content_url     = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125567282"
      + package_version = "8.6.20220523"
      + prompt          = (known after apply)
      + signature       = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_listing_package_agreement.freebsd_package_agreement will be created
  + resource "oci_marketplace_listing_package_agreement" "freebsd_package_agreement" {
      + agreement_id    = "50511633"
      + author          = (known after apply)
      + compartment_id  = (known after apply)
      + content_url     = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125980175"
      + package_version = "13.1"
      + prompt          = (known after apply)
      + signature       = (known after apply)
    }

  # module.oci-ampere-a1.random_uuid.random_id will be created
  + resource "random_uuid" "random_id" {
      + id     = (known after apply)
      + result = (known after apply)
    }

  # module.oci-ampere-a1.tls_private_key.oci will be created
  + resource "tls_private_key" "oci" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 18 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + oci_ampere_a1_private_ips = [
      + [
          + (known after apply),
        ],
    ]
  + oci_ampere_a1_public_ips  = [
      + [
          + (known after apply),
        ],
    ]

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```

Finally you will execute the 'apply' phase of the terraform exuction sequence.   This will create all the objects, execute all the tasks and display any output that is defined.   Executing the following command from the project directory will automatically execute without requiring any additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform from within the project directory:

```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.oci-ampere-a1.local_file.oci-ssh-privkey will be created
  + resource "local_file" "oci-ssh-privkey" {
      + content              = (sensitive)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "/home/ansible/src/terraform-oci-ampere-a1/examples/freebsd131/oci-id_rsa"
      + id                   = (known after apply)
    }

  # module.oci-ampere-a1.local_file.oci-ssh-pubkey will be created
  + resource "local_file" "oci-ssh-pubkey" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0644"
      + filename             = "/home/ansible/src/terraform-oci-ampere-a1/examples/freebsd131/oci-id_rsa.pub"
      + id                   = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.almalinux_8_app_catalog_listing_resource_version_agreement will be created
  + resource "oci_core_app_catalog_listing_resource_version_agreement" "almalinux_8_app_catalog_listing_resource_version_agreement" {
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaaiayknhrp2gsevmoano5i3253iv65q73pc6qzk4s2lrouoruz6zua"
      + listing_resource_version = "8.6.20220523"
      + oracle_terms_of_use_link = (known after apply)
      + signature                = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement will be created
  + resource "oci_core_app_catalog_listing_resource_version_agreement" "freebsd_app_catalog_listing_resource_version_agreement" {
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a"
      + listing_resource_version = "13.1"
      + oracle_terms_of_use_link = (known after apply)
      + signature                = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_subscription.almalinux_8_app_catalog_subscription will be created
  + resource "oci_core_app_catalog_subscription" "almalinux_8_app_catalog_subscription" {
      + compartment_id           = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + display_name             = (known after apply)
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaaiayknhrp2gsevmoano5i3253iv65q73pc6qzk4s2lrouoruz6zua"
      + listing_resource_id      = (known after apply)
      + listing_resource_version = "8.6.20220523"
      + oracle_terms_of_use_link = (known after apply)
      + publisher_name           = (known after apply)
      + signature                = (known after apply)
      + summary                  = (known after apply)
      + time_created             = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_app_catalog_subscription.freebsd_app_catalog_subscription will be created
  + resource "oci_core_app_catalog_subscription" "freebsd_app_catalog_subscription" {
      + compartment_id           = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + display_name             = (known after apply)
      + eula_link                = (known after apply)
      + id                       = (known after apply)
      + listing_id               = "ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a"
      + listing_resource_id      = (known after apply)
      + listing_resource_version = "13.1"
      + oracle_terms_of_use_link = (known after apply)
      + publisher_name           = (known after apply)
      + signature                = (known after apply)
      + summary                  = (known after apply)
      + time_created             = (known after apply)
      + time_retrieved           = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_instance.ampere_a1[0] will be created
  + resource "oci_core_instance" "ampere_a1" {
      + availability_domain                 = "FFpD:CA-MONTREAL-1-AD-1"
      + boot_volume_id                      = (known after apply)
      + capacity_reservation_id             = (known after apply)
      + compartment_id                      = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + dedicated_vm_host_id                = (known after apply)
      + defined_tags                        = (known after apply)
      + display_name                        = "AmpereA1-0"
      + fault_domain                        = (known after apply)
      + freeform_tags                       = (known after apply)
      + hostname_label                      = (known after apply)
      + id                                  = (known after apply)
      + image                               = (known after apply)
      + ipxe_script                         = (known after apply)
      + is_pv_encryption_in_transit_enabled = (known after apply)
      + launch_mode                         = (known after apply)
      + metadata                            = (known after apply)
      + private_ip                          = (known after apply)
      + public_ip                           = (known after apply)
      + region                              = (known after apply)
      + shape                               = "VM.Standard.A1.Flex"
      + state                               = (known after apply)
      + subnet_id                           = (known after apply)
      + system_tags                         = (known after apply)
      + time_created                        = (known after apply)
      + time_maintenance_reboot_due         = (known after apply)

      + agent_config {
          + are_all_plugins_disabled = (known after apply)
          + is_management_disabled   = (known after apply)
          + is_monitoring_disabled   = (known after apply)

          + plugins_config {
              + desired_state = (known after apply)
              + name          = (known after apply)
            }
        }

      + availability_config {
          + is_live_migration_preferred = (known after apply)
          + recovery_action             = (known after apply)
        }

      + create_vnic_details {
          + assign_public_ip       = "true"
          + defined_tags           = (known after apply)
          + display_name           = "primaryvnic"
          + freeform_tags          = (known after apply)
          + hostname_label         = "ampere-a1-freebsd-01"
          + private_ip             = (known after apply)
          + skip_source_dest_check = (known after apply)
          + subnet_id              = (known after apply)
          + vlan_id                = (known after apply)
        }

      + instance_options {
          + are_legacy_imds_endpoints_disabled = (known after apply)
        }

      + launch_options {
          + boot_volume_type                    = (known after apply)
          + firmware                            = (known after apply)
          + is_consistent_volume_naming_enabled = (known after apply)
          + is_pv_encryption_in_transit_enabled = (known after apply)
          + network_type                        = (known after apply)
          + remote_data_volume_type             = (known after apply)
        }

      + platform_config {
          + are_virtual_instructions_enabled               = (known after apply)
          + is_access_control_service_enabled              = (known after apply)
          + is_input_output_memory_management_unit_enabled = (known after apply)
          + is_measured_boot_enabled                       = (known after apply)
          + is_secure_boot_enabled                         = (known after apply)
          + is_symmetric_multi_threading_enabled           = (known after apply)
          + is_trusted_platform_module_enabled             = (known after apply)
          + numa_nodes_per_socket                          = (known after apply)
          + percentage_of_cores_enabled                    = (known after apply)
          + type                                           = (known after apply)
        }

      + preemptible_instance_config {
          + preemption_action {
              + preserve_boot_volume = (known after apply)
              + type                 = (known after apply)
            }
        }

      + shape_config {
          + baseline_ocpu_utilization     = (known after apply)
          + gpu_description               = (known after apply)
          + gpus                          = (known after apply)
          + local_disk_description        = (known after apply)
          + local_disks                   = (known after apply)
          + local_disks_total_size_in_gbs = (known after apply)
          + max_vnic_attachments          = (known after apply)
          + memory_in_gbs                 = 24
          + networking_bandwidth_in_gbps  = (known after apply)
          + nvmes                         = (known after apply)
          + ocpus                         = 4
          + processor_description         = (known after apply)
        }

      + source_details {
          + boot_volume_size_in_gbs = (known after apply)
          + boot_volume_vpus_per_gb = (known after apply)
          + kms_key_id              = (known after apply)
          + source_id               = "ocid1.image.oc1..aaaaaaaayjatgvecms7kciqjx5exbj4dpcs3ympvpggpodwlfuezn7dejdja"
          + source_type             = "image"
        }
    }

  # module.oci-ampere-a1.oci_core_internet_gateway.ampere_internet_gateway will be created
  + resource "oci_core_internet_gateway" "ampere_internet_gateway" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "AmpereInternetGateway"
      + enabled        = true
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_route_table.ampere_route_table will be created
  + resource "oci_core_route_table" "ampere_route_table" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "AmpereRouteTable"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + route_rules {
          + cidr_block        = (known after apply)
          + description       = (known after apply)
          + destination       = "0.0.0.0/0"
          + destination_type  = "CIDR_BLOCK"
          + network_entity_id = (known after apply)
          + route_type        = (known after apply)
        }
    }

  # module.oci-ampere-a1.oci_core_security_list.ampere_security_list will be created
  + resource "oci_core_security_list" "ampere_security_list" {
      + compartment_id = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags   = (known after apply)
      + display_name   = "ampereSecurityList"
      + freeform_tags  = (known after apply)
      + id             = (known after apply)
      + state          = (known after apply)
      + time_created   = (known after apply)
      + vcn_id         = (known after apply)

      + egress_security_rules {
          + description      = (known after apply)
          + destination      = "0.0.0.0/0"
          + destination_type = (known after apply)
          + protocol         = "6"
          + stateless        = (known after apply)
        }

      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 22
              + min = 22
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 3000
              + min = 3000
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 3005
              + min = 3005
            }
        }
      + ingress_security_rules {
          + description = (known after apply)
          + protocol    = "6"
          + source      = "0.0.0.0/0"
          + source_type = (known after apply)
          + stateless   = false

          + tcp_options {
              + max = 80
              + min = 80
            }
        }
    }

  # module.oci-ampere-a1.oci_core_subnet.ampere_subnet will be created
  + resource "oci_core_subnet" "ampere_subnet" {
      + availability_domain        = (known after apply)
      + cidr_block                 = "10.2.1.0/24"
      + compartment_id             = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags               = (known after apply)
      + dhcp_options_id            = (known after apply)
      + display_name               = "AmpereSubnet"
      + dns_label                  = "Ampere"
      + freeform_tags              = (known after apply)
      + id                         = (known after apply)
      + ipv6cidr_block             = (known after apply)
      + ipv6cidr_blocks            = (known after apply)
      + ipv6virtual_router_ip      = (known after apply)
      + prohibit_internet_ingress  = (known after apply)
      + prohibit_public_ip_on_vnic = (known after apply)
      + route_table_id             = (known after apply)
      + security_list_ids          = (known after apply)
      + state                      = (known after apply)
      + subnet_domain_name         = (known after apply)
      + time_created               = (known after apply)
      + vcn_id                     = (known after apply)
      + virtual_router_ip          = (known after apply)
      + virtual_router_mac         = (known after apply)
    }

  # module.oci-ampere-a1.oci_core_virtual_network.ampere_vcn will be created
  + resource "oci_core_virtual_network" "ampere_vcn" {
      + byoipv6cidr_blocks               = (known after apply)
      + cidr_block                       = "10.2.0.0/16"
      + cidr_blocks                      = (known after apply)
      + compartment_id                   = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + default_dhcp_options_id          = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_list_id         = (known after apply)
      + defined_tags                     = (known after apply)
      + display_name                     = "AmpereVirtualCoreNetwork"
      + dns_label                        = "amperevcn"
      + freeform_tags                    = (known after apply)
      + id                               = (known after apply)
      + ipv6cidr_blocks                  = (known after apply)
      + ipv6private_cidr_blocks          = (known after apply)
      + is_ipv6enabled                   = (known after apply)
      + is_oracle_gua_allocation_enabled = (known after apply)
      + state                            = (known after apply)
      + time_created                     = (known after apply)
      + vcn_domain_name                  = (known after apply)

      + byoipv6cidr_details {
          + byoipv6range_id = (known after apply)
          + ipv6cidr_block  = (known after apply)
        }
    }

  # module.oci-ampere-a1.oci_marketplace_accepted_agreement.almalinux_8_accepted_agreement will be created
  + resource "oci_marketplace_accepted_agreement" "almalinux_8_accepted_agreement" {
      + agreement_id    = "50511633"
      + compartment_id  = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags    = (known after apply)
      + display_name    = (known after apply)
      + freeform_tags   = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125567282"
      + package_version = "8.6.20220523"
      + signature       = (known after apply)
      + time_accepted   = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_accepted_agreement.freebsd_accepted_agreement will be created
  + resource "oci_marketplace_accepted_agreement" "freebsd_accepted_agreement" {
      + agreement_id    = "50511633"
      + compartment_id  = "ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq"
      + defined_tags    = (known after apply)
      + display_name    = (known after apply)
      + freeform_tags   = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125980175"
      + package_version = "13.1"
      + signature       = (known after apply)
      + time_accepted   = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_listing_package_agreement.almalinux_8_package_agreement will be created
  + resource "oci_marketplace_listing_package_agreement" "almalinux_8_package_agreement" {
      + agreement_id    = "50511633"
      + author          = (known after apply)
      + compartment_id  = (known after apply)
      + content_url     = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125567282"
      + package_version = "8.6.20220523"
      + prompt          = (known after apply)
      + signature       = (known after apply)
    }

  # module.oci-ampere-a1.oci_marketplace_listing_package_agreement.freebsd_package_agreement will be created
  + resource "oci_marketplace_listing_package_agreement" "freebsd_package_agreement" {
      + agreement_id    = "50511633"
      + author          = (known after apply)
      + compartment_id  = (known after apply)
      + content_url     = (known after apply)
      + id              = (known after apply)
      + listing_id      = "125980175"
      + package_version = "13.1"
      + prompt          = (known after apply)
      + signature       = (known after apply)
    }

  # module.oci-ampere-a1.random_uuid.random_id will be created
  + resource "random_uuid" "random_id" {
      + id     = (known after apply)
      + result = (known after apply)
    }

  # module.oci-ampere-a1.tls_private_key.oci will be created
  + resource "tls_private_key" "oci" {
      + algorithm                     = "RSA"
      + ecdsa_curve                   = "P224"
      + id                            = (known after apply)
      + private_key_openssh           = (sensitive value)
      + private_key_pem               = (sensitive value)
      + private_key_pem_pkcs8         = (sensitive value)
      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 18 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + oci_ampere_a1_private_ips = [
      + [
          + (known after apply),
        ],
    ]
  + oci_ampere_a1_public_ips  = [
      + [
          + (known after apply),
        ],
    ]
module.oci-ampere-a1.random_uuid.random_id: Creating...
module.oci-ampere-a1.tls_private_key.oci: Creating...
module.oci-ampere-a1.random_uuid.random_id: Creation complete after 0s [id=400ce2ff-e1ce-78b7-937f-c1cc9fa2ea5f]
module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement: Creating...
module.oci-ampere-a1.oci_core_virtual_network.ampere_vcn: Creating...
module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.almalinux_8_app_catalog_listing_resource_version_agreement: Creating...
module.oci-ampere-a1.oci_marketplace_listing_package_agreement.almalinux_8_package_agreement: Creating...
module.oci-ampere-a1.oci_marketplace_listing_package_agreement.freebsd_package_agreement: Creating...
module.oci-ampere-a1.oci_marketplace_listing_package_agreement.freebsd_package_agreement: Creation complete after 0s [id=50511633]
module.oci-ampere-a1.oci_marketplace_listing_package_agreement.almalinux_8_package_agreement: Creation complete after 0s [id=50511633]
module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.freebsd_app_catalog_listing_resource_version_agreement: Creation complete after 0s [id=2022-08-22 14:22:26.366 +0000 UTC]
module.oci-ampere-a1.oci_marketplace_accepted_agreement.freebsd_accepted_agreement: Creating...
module.oci-ampere-a1.oci_marketplace_accepted_agreement.almalinux_8_accepted_agreement: Creating...
module.oci-ampere-a1.oci_core_app_catalog_subscription.freebsd_app_catalog_subscription: Creating...
module.oci-ampere-a1.oci_core_app_catalog_listing_resource_version_agreement.almalinux_8_app_catalog_listing_resource_version_agreement: Creation complete after 1s [id=2022-08-22 14:22:26.589 +0000 UTC]
module.oci-ampere-a1.oci_core_app_catalog_subscription.almalinux_8_app_catalog_subscription: Creating...
module.oci-ampere-a1.oci_marketplace_accepted_agreement.freebsd_accepted_agreement: Creation complete after 0s [id=ocid1.marketplaceacceptedagreement.oc1..aaaaaaaaao6swpfxegh6lkxqrujx54pyskcxxrqgurwz24ntqflrhem7ha7q]
module.oci-ampere-a1.oci_marketplace_accepted_agreement.almalinux_8_accepted_agreement: Creation complete after 0s [id=ocid1.marketplaceacceptedagreement.oc1..aaaaaaaa62bsowyk77vzd4g5xxfzxziv4isf77shyprtlqrfpwykd2wyucpa]
module.oci-ampere-a1.oci_core_app_catalog_subscription.freebsd_app_catalog_subscription: Creation complete after 0s [id=compartmentId/ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq/listingId/ocid1.appcataloglisting.oc1..aaaaaaaa52miob5xfolxu32kuxb2jgmdvtdovkisqvr22uozlr2b5cjwjm7a/listingResourceVersion/13.1]
module.oci-ampere-a1.oci_core_app_catalog_subscription.almalinux_8_app_catalog_subscription: Creation complete after 0s [id=compartmentId/ocid1.tenancy.oc1..aaaaaaaafr3n2emalltus7mfag2qismfdpj5ta63gzgxbqxfb6d5xuq5ocyq/listingId/ocid1.appcataloglisting.oc1..aaaaaaaaiayknhrp2gsevmoano5i3253iv65q73pc6qzk4s2lrouoruz6zua/listingResourceVersion/8.6.20220523]
module.oci-ampere-a1.oci_core_virtual_network.ampere_vcn: Creation complete after 1s [id=ocid1.vcn.oc1.ca-montreal-1.amaaaaaas3ocaxia3uloouwtjazqbhdnl5gw44fqqoy5jsgatxkpxqafporq]
module.oci-ampere-a1.oci_core_internet_gateway.ampere_internet_gateway: Creating...
module.oci-ampere-a1.oci_core_security_list.ampere_security_list: Creating...
module.oci-ampere-a1.oci_core_security_list.ampere_security_list: Creation complete after 0s [id=ocid1.securitylist.oc1.ca-montreal-1.aaaaaaaa35tcslvh366govvirorrmxreohdphi2e3dgh523vx3qhfw736t2q]
module.oci-ampere-a1.oci_core_internet_gateway.ampere_internet_gateway: Creation complete after 1s [id=ocid1.internetgateway.oc1.ca-montreal-1.aaaaaaaajdzpkaqwidkis6xhdd3s2ubccduofjrawifyke446edzsyz4mu2a]
module.oci-ampere-a1.oci_core_route_table.ampere_route_table: Creating...
module.oci-ampere-a1.oci_core_route_table.ampere_route_table: Creation complete after 0s [id=ocid1.routetable.oc1.ca-montreal-1.aaaaaaaavq277xd777677xjzp6y5jb4czrjkkhi3b3f5ygcdtcacdc7eze7q]
module.oci-ampere-a1.oci_core_subnet.ampere_subnet: Creating...
module.oci-ampere-a1.oci_core_subnet.ampere_subnet: Creation complete after 3s [id=ocid1.subnet.oc1.ca-montreal-1.aaaaaaaaaoc6woleuaz3lnoxjtegjxudjvwbdsit5yix6tk53t4wnaxgqs7q]
module.oci-ampere-a1.tls_private_key.oci: Still creating... [10s elapsed]
module.oci-ampere-a1.tls_private_key.oci: Creation complete after 13s [id=5e88bcbd6a6df1fdc61a55f7eb9df59f1e77682e]
module.oci-ampere-a1.local_file.oci-ssh-privkey: Creating...
module.oci-ampere-a1.local_file.oci-ssh-pubkey: Creating...
module.oci-ampere-a1.local_file.oci-ssh-pubkey: Creation complete after 0s [id=49cc8c26d18f56bd98394328b88c7d97c1428db7]
module.oci-ampere-a1.oci_core_instance.ampere_a1[0]: Creating...
module.oci-ampere-a1.local_file.oci-ssh-privkey: Creation complete after 0s [id=d5027921a08671a99244e9c3814b7cbf302aa4b2]
module.oci-ampere-a1.oci_core_instance.ampere_a1[0]: Still creating... [10s elapsed]
module.oci-ampere-a1.oci_core_instance.ampere_a1[0]: Still creating... [20s elapsed]
module.oci-ampere-a1.oci_core_instance.ampere_a1[0]: Still creating... [30s elapsed]
module.oci-ampere-a1.oci_core_instance.ampere_a1[0]: Creation complete after 37s [id=ocid1.instance.oc1.ca-montreal-1.an4xkljrs3ocaxic4eizvijhp2f3qylhxs5dc6lm5yb3zrerk4ufzpnnyhjq]

Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

oci_ampere_a1_private_ips = [
  [
    "10.2.1.31",
  ],
]
oci_ampere_a1_public_ips = [
  [
    "155.248.228.151",
  ],
]
```
### Logging in

To log in take the ip address from the output above and run the following ssh command:

```
ssh -i ./oci-is_rsa freebsd@155.248.228.151
```

You should be automatically logged in and see something similar to the following:

```


Next you'll need to login with the dynamically generated sshkey that will be sitting in your project directory.


```

bwayne@ampere1:~/freebsd$ ssh -i ./oci-id_rsa freebsd@155.248.238.91
hostkeys_find_by_key_hostfile: hostkeys_foreach failed for /etc/ssh/ssh_known_hosts: Permission denied
The authenticity of host '155.248.238.91 (155.248.238.91)' can't be established.
ED25519 key fingerprint is SHA256:ALiotO651cdw2YrFvc4M4UQepVBcmfQPydj/pjbjSws.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '155.248.238.91' (ED25519) to the list of known hosts.
FreeBSD 13.1-RELEASE GENERIC

Welcome to FreeBSD!

Release Notes, Errata: https://www.FreeBSD.org/releases/
Security Advisories:   https://www.FreeBSD.org/security/
FreeBSD Handbook:      https://www.FreeBSD.org/handbook/
FreeBSD FAQ:           https://www.FreeBSD.org/faq/
Questions List: https://lists.FreeBSD.org/mailman/listinfo/freebsd-questions/
FreeBSD Forums:        https://forums.FreeBSD.org/

Documents installed with the system are in the /usr/local/share/doc/freebsd/
directory, or can be installed later with:  pkg install en-freebsd-doc
For other languages, replace "en" with a language code like de or fr.

Show the version of FreeBSD installed:  freebsd-version ; uname -a
Please include that output and any error messages when posting questions.
Introduction to manual pages:  man man
FreeBSD directory layout:      man hier

To change this login announcement, see motd(5).
Before deleting a dataset or snapshot, perform a dry run using the -n
parameter. This is to make sure you really want to delete just that
dataset/snapshot and not any dependent ones. ZFS will display the resulting
action when -n is combined with the -v option without actually performing
it:

zfs destroy -nrv mypool@mysnap

Once you are sure this is exactly what you intend to do, remove the -n
parameter to execute the destroy operation.
                -- Benedict Reuschling <bcr@FreeBSD.org>
freebsd@ampere-a1-freebsd-01:~ %
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
* [https://github.com/oracle-quickstart/oci-freebsd](https://github.com/oracle-quickstart/oci-freebsd)
* [https://klarasystems.com/articles/the-next-level-freebsd-on-arm64-in-the-cloud/](https://klarasystems.com/articles/the-next-level-freebsd-on-arm64-in-the-cloud/)

