![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Introducing AlmaLinux 9 in OCI using Ampere A1 and Terraform

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
* [Using the oci-ampere-a1 terraform module](#using-the-oci-ampere-a1-terraform-module)
  * [Configuration with terraform.tfvars](#configuration-with-terraformtfvars)
  * [Creating the main.tf](#creating-the-maintf)
  * [Creating a cloud-init template](#creating-a-cloud-init-template)
  * [Running Terraform](#running-terraform)
  * [Logging in](#logging-in)
  * [Destroying when done](#destroying-done)

## Introduction

[AlmaLinux](https://almalinux.org) is a free open source Linux distribution, created by [CloudLinux](https://www.cloudlinux.com/) to provide a community-supported, production-grade enterprise operating system that is a binary-compatible downstream rebuild of RedHat Enterprise Linux. It's origin, [CloudLinux](https://www.cloudlinux.com/) is a whitelable downstream rebuild of RHEL used by some of the largest web hosting providers. [AlmaLinux](https://almalinux.org) has similarities to RedHat Enterprise Linux, with identical package management tooling and methods, and open source software stacks available for installation easily.

[AlmaLinux](https://almalinux.org) OS 9.0 is based on upstream kernel version 5.14 and contains enhancements around cloud and container development and improvements to the web console (cockpit). Release 9 also delivers enhancements for security and compliance, including additional security profiles, greatly improved SELinux performance and user authentication logs. Other various updates include Python 3.9, GCC 11 and the latest versions of LLVM, Rust and Go compilers to make modernizing the applications faster and easier.

[AlmaLinux](https://almalinux.org) OS 9.0 includes the same industry standard metadata interfaces for instance configurations [Cloud-Init](https://cloud-init.io). This allows you to automate your [AlmaLinux](https://almalinux.org) workloads, in a simlar fashion to other operating system options.  This meams [AlmaLinux](https://almalinux.org) is perfectly suitable when using on a cloud platform.

Now personally speaking I have been working with the great team at the [AlmaLinux](https://almalinux.org) project for some time watching thier craftmanship, curating, iterating, and helping achive the "it just works" experience for Aarch64 and Ampere platforms and customers who choose to build and run solutions on [AlmaLinux](https://almalinux.org). Recently [AlmaLinux](https://almalinux.org) 9 became available for use on Ampere A1 shapes within the [Oracle OCI Marketplace](https://cloudmarketplace.oracle.com/marketplace/en_US/listing/127985893). 

In this post, we will build upon prevous work to quickly start automating using [AlmaLinux](https://almalinux.org) 9 on Ampere(R) Altra(TM) Arm64 processors within Oracle Cloud Infrastructure using Ampere A1 shapes.

## Requirements

Obviously to begin you will need a couple things.  Personally I'm a big fan of the the DevOPs tools that support lots of api, and different use cases. [Terraform](https://www.terraform.io/downloads.html) is one of those types of tools.  If you have seen my [prevous session with some members of the Oracle Cloud Infrastracture team](https://youtu.be/3F5EnHRPCI4), I build a terraform module to quickly get you started using Ampere plaforms on OCI.  Today we are going to use that module to launch a [AlmaLinux](Instance) virtual machine while passing in some metadata to configure it.

 * [Terraform](https://www.terraform.io/downloads.html) will need be installed on your system. 
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free) and credentials for API use

## Using the oci-ampere-a1 terraform module

The [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module code supplies the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).  It has been updated to include the ability to easily select [AlmaLinux](https://almalinux.org) as an option.  To keep things simple from an OCI perspective, the root compartment will be used (compartment id and tenancy id are the same) when launching any instances.  Addtional tasks performed by the [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module.

* Operating system image id discovery in the user region.
* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id.
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance.
* Launch 1 to 4 Ampere A1 instances with metadata and ssh keys.
* Output IP information to connect to the instance.

### Configuration with terraform.tfvars

For the purpose of this we will quickly configure Terraform using a terraform.tfvars in the project directory.  
Please note that Compartment OCID are the same as Tenancy OCID for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
private_key_path = "/home/bwayne/.oci/oracleidentitycloudservice_bwayne-08-09-14-59.pem"
```

For more information regarding how to get your OCI credentials please refer to the following reading material:

* [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm)
* [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five)
* [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth)
* [Instance Principal Authorization](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#instancePrincipalAuth)
* [Security Token Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#securityTokenAuth)
* [How to Generate an API Signing Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)

### Creating the main.tf

To use the terraform module you must open your favorite text editor and create a file called main.tf.  Copy the following is code which will allow you to supply a custom cloud-init template to terraform.

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

### Creating a cloud init template.

Using your favorite text editor create a file named cloud-init.yaml.tpl in the same directory as the main.tf you previously created. To make things slightly more interesting, in this template we are going to update and install some base packages using standard package management, add a group, then install then necessary repositories to install the docker-engine, as well as some additional tools to utilize docker. Once everything is running we will start a container running a container registry on the host.  To get started copy the following content into the text file and save it.

```
#cloud-config

package_update: true
package_upgrade: true

packages:
  - tmux
  - rsync
  - git
  - curl
  - python3
  - python36
  - python36-devel
  - python3-pip-wheel
  - python38
  - python38-devel
  - python38-pip
  - python38-pip-wheel
  - gcc
  - gcc
  - gcc-c++
  - nodejs
  - rust
  - gettext
  - device-mapper-persistent-data
  - lvm2
  - bzip2

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - alternatives --set python /usr/bin/python3.8
  - pip3.8 install -U pip
  - pip3.8 install -U setuptools-rust
  - pip3.8 install -U ansible
  - dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  - dnf update -y
  - dnf install docker-ce docker-ce-cli containerd.io -y
  - curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-aarch64 -o /usr/local/bin/docker-compose-linux-aarch64
  - chmod -x /usr/local/bin/docker-compose-linux-aarch64
  - ln -s /usr/local/bin/docker-compose-linux-aarch64 /usr/bin/docker-compose
  - docker-compose --version
  - pip3.8 install -U docker-compose
  - docker info
  - systemctl enable docker
  - systemctl start docker
  - docker run -d --name registry --restart=always -p 4000:5000  -v registry:/var/lib/registry registry:2
  - docker info
  - echo 'OCI Ampere A1 AlmaLinux 9 Example' >> /etc/motd

```

### Running Terraform

Executing terraform is broken into three commands.   The first you must initialize the terraform project with the modules and necessary plugins to support proper execution.   The following command will do that:

```
terraform init
```

Below is output from a 'terraform init' execution within the project directory.

<script id="asciicast-517195" src="https://asciinema.org/a/517195.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

After 'terraform init' is executed it is necessary to run 'plan' to see the tasks, steps and objects. that will be created by interacting with the cloud APIs.
Executing the following from a command line will do so:

```
terraform plan
```

The ouput from a 'terraform plan' execution in the project directy will look similar to the following:

<script id="asciicast-517194" src="https://asciinema.org/a/517194.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Finally you will execute the 'apply' phase of the terraform exuction sequence.   This will create all the objects, execute all the tasks and display any output that is defined.   Executing the following command from the project directory will automatically execute without requiring any additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform from within the project directory:


<script id="asciicast-517196" src="https://asciinema.org/a/517196.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Logging in

Next you'll need to login with the dynamically generated sshkey that will be sitting in your project directory.
To log in take the ip address from the output above and run the following ssh command:

```
ssh -i ./oci-is_rsa opc@155.248.228.151
```

You should be automatically logged in after running the the command.  The following is output from sshing into an instance and then running  'sudo cat /var/log/messages' to verify cloud-init execution and package installation:

<script id="asciicast-517197" src="https://asciinema.org/a/517197.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Destroying when done

You now should have a fully running and configured AlmaLinux instance.   When finished you will need to execute the 'destroy' command to remove all created objects in a 'leave no trace' manner.  Execute the following from a command to remove all created objects when finished:

```
terraform destroy -auto-approve
```

The following is example output of the 'terraform destroy' when used on this project.

<script id="asciicast-517198" src="https://asciinema.org/a/517198.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Modifing the cloud-init file and then performing the same workflow will allow you to get interating quickly. At this point you should definately know how to quickly get automating using AlmaLinux with Ampere on the Cloud!  
