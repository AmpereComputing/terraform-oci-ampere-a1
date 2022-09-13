![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Introducing OpenMandriva in OCI using Ampere A1 and Terraform

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

[OpenMandriva](https://openmandriva.org) is now available for use on Ampere A1 instances within Oracle's Cloud Infrastructure. The roots of the OpenMandriva project are in Mandrake and its traditions. They are a worldwide community of people who are passionate about free software working together and take their technical and strategic decisions in a collaborative manner. They do not just build a Linux distro, they exchange knowledge and make new friends. I have been fortunate to have the pleasure of both working with and then meeting in person members of the team at a [recent event Ampere attended in Europe this Spring](https://amperecomputing.com/blogs/2022-04-15/cloudfest-2022-highlights-the-importance-of-a-sustainable-cloud.html).

Technically speaking [OpenMandriva](https://openmandriva.org) tends to pull changes in quickly from upstream, so you'll have all the latest and greatest packages avaiable.  This also includes the kernel. !!!Spoiler alert!!! They're already testing with Linux kernel 6.0 on Ampere platforms.

For those unfamiliar with [OpenMandriva](https://openmandriva.org) Linux, it uses 'dnf', similar package management tooling to Fedora or Red Hat based distributions and includes and open source software stacks available for installation easily.

[OpenMandriva](https://openmandriva.org) supports the same industry standard metadata interfaces for instance configurations as other Linux distributions, [Cloud-Init](https://cloud-init.io). This allows you to automate your [OpenMandriva](https://openmandriva.org) workloads, in a simlar fashion to other operating system options.  This also meams [OpenMandriva](https://openmandriva.org) is perfectly suitable when using on a cloud platform.

Now personally speaking I have been working with the great team at the [OpenMandriva](https://openmandriva.org) project for some time watching their craftmanship, curating, iterating, and helping achieve the "it just works" experience for Aarch64 and Ampere platforms and customers who choose to build and run solutions on [OpenMandriva](https://openmandriva.org). Recently [OpenMandriva](https://openmandriva.org) became available for use on Ampere A1 shapes within the [Oracle OCI](https://www.oracle.com/cloud/free/#always-free) marketplace.

In this post, we will build upon prevous work to quickly automate using [OpenMandriva](https://openmandriva.org) on Ampere(R) Altra(TM) Arm64 processors within Oracle Cloud Infrastructure using Ampere A1 shapes.

## Requirements

Obviously to begin you will need a couple things.  Personally I'm a big fan of the the DevOPs tools that support lots of api, and different use cases. [Terraform](https://www.terraform.io/downloads.html) is one of those types of tools.  If you have seen my [previous session with some members of the Oracle Cloud Infrastracture team](https://youtu.be/3F5EnHRPCI4), I built a terraform module to quickly get you started using Ampere platforms on OCI.  Today we are going to use that module to launch an [OpenMandriva](Instance) virtual machine while passing in some metadata to configure it.

 * [Terraform](https://www.terraform.io/downloads.html) will need be installed on your system. (If you're using OpenMandriva on your system as well, simply `dnf install terraform`).
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free) and credentials for API use

## Using the oci-ampere-a1 terraform module

The [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module code supplies the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).  It has been updated to include the ability to easily select [OpenMandriva](https://openmandriva.org) as an option.  To keep things simple from an OCI perspective, the root compartment will be used (compartment id and tenancy id are the same) when launching any instances.  Addtional tasks performed by the [oci-ampere-a1](https://github.com/amperecomputing/terraform-oci-ampere-a1) terraform module:

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

### Creating ~/.oci/config

After setting up the [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth), still on the API Keys page in the OCI console, click the 3 dots next to the API key you've created, and select "View Configuration file".

Copy the generated configuration to a file called ~/.oci/config (creating the ~/.oci directory first if necessary), and replace "\<path to your private keyfile\>" with the file name of your private key (`~/.oci/oci_api_key.pem` if you've stayed with the suggestions in the documentation).

### Creating the main.tf

To use the terraform module you must open your favorite text editor and create a file called main.tf.  Copy the following is code to supply a custom cloud-init template:

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

### Creating a cloud init template.

Using your favorite text editor create a file named cloud-init.yaml.tpl in the same directory as the main.tf you previously created. Copy the following content into the text file and save it. (Obviously you can adjust the list of extra packages you want to install. `task-devel` is a metapackage that pulls in C and C++ compilers and headers for some basic libraries.)

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
  - python
  - lib64python-devel
  - python-pip
  - task-devel
  - bzip2
  - screen

groups:
  - ampere
system_info:
  default_user:
    groups: [ampere]

runcmd:
  - echo 'OCI Ampere OpenMandriva Example' >> /etc/motd
```

### Running Terraform

Executing terraform is broken into three commands.   The first you must initialize the terraform project with the modules and necessary plugins to support proper execution.   The following command will do that:

```
terraform init
```

Below is output from a 'terraform init' execution within the project directory.

<script id="asciicast-520010" src="https://asciinema.org/a/520010.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

After 'terraform init' is executed it is necessary to run 'plan' to see the tasks, steps and objects that will be created by interacting with the cloud APIs.
Executing the following from a command line will do so:

```
terraform plan
```

The output from a 'terraform plan' execution in the project directory will look similar to the following:

<script id="asciicast-520011" src="https://asciinema.org/a/520011.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Finally, you will execute the 'apply' phase of the terraform execution sequence.   This will create all the objects, execute all the tasks and display any output that is defined.   Executing the following command from the project directory will automatically execute without requiring any additional interaction:

```
terraform apply -auto-approve
```

The following is an example of output from a 'apply' run of terraform from within the project directory:


<script id="asciicast-520012" src="https://asciinema.org/a/520012.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Logging in

Next you'll need to login with the dynamically generated sshkey that will be sitting in your project directory.  The default user for OpenMandriva instances is 'omv'.  To log in take the ip address from the output above and run the following ssh command:

```
ssh -i ./oci-is_rsa omv@<the.ip.address>
```

You should be automatically logged in after running the the command.  The following is output from sshing into an instance and then running  'sudo cat /var/log/messages' to verify cloud-init execution and package installation:

<script id="asciicast-520014" src="https://asciinema.org/a/520014.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

### Destroying when done

You now should have a fully running and configured OpenMandriva instance.   When finished, you will need to execute the 'destroy' command to remove all created objects in a 'leave no trace' manner.  Execute the following from a command to remove all created objects when finished:

```
terraform destroy -auto-approve
```

The following is example output of the 'terraform destroy' when used on this project.

<script id="asciicast-520015" src="https://asciinema.org/a/520015.js" async data-autoplay="true" data-size="small" data-speed="2"></script>

Modifying the cloud-init file and then performing the same workflow will allow you to get interacting quickly. At this point you should definitely know how to quickly get automating using OpenMandriva with Ampere on the Cloud!  
