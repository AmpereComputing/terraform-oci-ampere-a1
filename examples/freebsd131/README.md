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

Using your favorite text editor create a file named cloud-init.yaml.tpl in the same directory as the main.tf you previously created. Copy the following content into the text file and save it.

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

<script id="asciicast-516707" src="https://asciinema.org/a/516707.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

https://asciinema.org/a/516707

After 'terraform init' is executed it is necessary to run 'plan' to see the tasks, steps and objects. that will be created by interacting with the cloud APIs.
Executing the following from a command line will do so:

```
terraform plan
```

The ouput from a 'terraform plan' execution in the project directy will look similar to the following:

<script id="asciicast-516709" src="https://asciinema.org/a/516709.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

https://asciinema.org/a/516709


Finally you will execute the 'apply' phase of the terraform exuction sequence.   This will create all the objects, execute all the tasks and display any output that is defined.   Executing the following command from the project directory will automatically execute without requiring any additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform from within the project directory:


<script id="asciicast-516711" src="https://asciinema.org/a/516711.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

https://asciinema.org/a/516711


### Logging in

Next you'll need to login with the dynamically generated sshkey that will be sitting in your project directory.
To log in take the ip address from the output above and run the following ssh command:

```
ssh -i ./oci-is_rsa freebsd@155.248.228.151
```

You should be automatically logged in and see something similar to the following:

<script id="asciicast-516713" src="https://asciinema.org/a/516713.js" async data-autoplay="true" data-size="small" data-speed="2"></script>
https://asciinema.org/a/516713


You now should have a fully running and configured FreeBSD instance.   When finished you will need to execute the 'destroy' command to remove all created objects in a 'leave no trace' manner.  Execute the following from a command to remove all created objects when finished:


```
terraform destroy -auto-approve
```

The following is example output of the 'terraform destroy' when used on this project.

<script id="asciicast-516714" src="https://asciinema.org/a/516714.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

https://asciinema.org/a/516714

Modifing the cloud-init file and then performing the same workflow will allow you to get interating quickly. At this point you should definately know how to quickly get automating using FreeBSD with Ampere on the Cloud!  

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

