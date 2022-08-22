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

```
terraform init && terraform plan && terraform apply -auto-approve
```

terraform init

```
[0m[1mInitializing modules...[0m
Downloading git::https://github.com/amperecomputing/terraform-oci-ampere-a1.git for oci-ampere-a1...
- oci-ampere-a1 in .terraform/modules/oci-ampere-a1

[0m[1mInitializing the backend...[0m

[0m[1mInitializing provider plugins...[0m
- Finding latest version of hashicorp/local...
- Finding latest version of hashicorp/random...
- Finding latest version of hashicorp/template...
- Finding latest version of oracle/oci...
- Finding latest version of hashicorp/tls...
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)
- Installing oracle/oci v4.89.0...
- Installed oracle/oci v4.89.0 (signed by a HashiCorp partner, key ID [0m[1m1533A49284137CEB[0m[0m)
- Installing hashicorp/tls v4.0.1...
- Installed hashicorp/tls v4.0.1 (signed by HashiCorp)
- Installing hashicorp/local v2.2.3...
- Installed hashicorp/local v2.2.3 (signed by HashiCorp)
- Installing hashicorp/random v3.3.2...
- Installed hashicorp/random v3.3.2 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.[0m

[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m
[0m[32m
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.[0m
```
### Logging in

To log in take the ip address from the output.  An example of what the terraform looks like is below.

```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

oci_ampere_a1_private_ips = [
  [
    "10.2.1.18",
  ],
]
oci_ampere_a1_public_ips = [
  [
    "155.248.238.91",
  ],
]

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

