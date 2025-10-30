# terraform-oci-ampere-a1

![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

[![Source Code](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/AmpereComputing/terraform-oci-ampere-a1)
![documentation workflow](https://github.com/AmpereComputing/terraform-oci-ampere-a1/actions/workflows/documentation.yml/badge.svg?label=build&style=flat-square&branch=main)
![release workflow](https://github.com/AmpereComputing/terraform-oci-ampere-a1/actions/workflows/release.yml/badge.svg?label=build&style=flat-square&branch=main)
[![Latest version](https://img.shields.io/github/tag/AmpereComputing/terraform-oci-ampere-a1.svg?label=release&style=flat&maxAge=3600)](https://github.com/AmpereComputing/terraform-oci-ampere-a1/tags)
[![GitHub issues](https://img.shields.io/github/issues/AmpereComputing/terraform-oci-ampere-a1.svg)](https://github.com/AmpereComputing/terraform-oci-ampere-a1/issues)
![Github stars](https://badgen.net/github/stars/AmpereComputing/terraform-oci-ampere-a1?icon=github&label=stars)
![Github last-commit](https://img.shields.io/github/last-commit/AmpereComputing/terraform-oci-ampere-a1)
[![GitHub forks](https://img.shields.io/github/forks/AmpereComputing/terraform-oci-ampere-a1.svg)](https://github.com/AmpereComputing/terraform-oci-ampere-a1/network)
![Github forks](https://badgen.net/github/forks/AmpereComputing/terraform-oci-ampere-a1?icon=github&label=forks)
![GitHub License](https://img.shields.io/github/license/AmpereComputing/terraform-oci-ampere-a1)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![GitHub deployments](https://img.shields.io/github/deployments/AmpereComputing/terraform-oci-ampere-a1/github-pages)
![Website](https://img.shields.io/website?url=https%3A%2F%2Famperecomputing.github.io/terraform-oci-ampere-a1)

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
