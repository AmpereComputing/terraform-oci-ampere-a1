![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# terraform-oci-ampere-a1

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Terraform code to launch a Ampere A1 Shape on Oracle Cloud Infrastructure (OCI) Free-Tier

## Requirements

 * [Terraform](https://www.terraform.io/downloads.html)
 * [Oracle OCI "Always Free" Account](https://www.oracle.com/cloud/free/#always-free)



## What exactly is Terraform doing

The goal of this code is to supply the minimal ammount of information to quickly have working Ampere A1 instances on OCI ["Always Free"](https://www.oracle.com/cloud/free/#always-free).
The root compartment will be used (compartment id and tenancy id are the same) when launching the instance.  

* Dynamically creating sshkeys to use when logging into the instance.
* Dynamically getting region, availability zone and image id..
* Creating necessary core networking configurations for the tenancy
* Rendering metadata to pass into the Ampere A1 instance.
* Launching an Ampere A1 instance with metadata and ssh keys.
* Output information to connect to the instance.

## Configuration with terraform.tfvars

The easiest way to configure is to use a terraform.tfvars in the project directory.  
Please note that Compartment OCID are the same as Tenancy OCID for Root Compartment.
The following is an example of what terraform.tfvars should look like:

```
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopq"
user_ocid = "ocid1.user.oc1..aaaaaaaabcdefghijklmnopqrstuvwxyz0987654321zyxwvustqrponmlkj"
fingerprint = "a1:01:b2:02:c3:03:e4:04:10:11:12:13:14:15:16:17"
```

### Running Terraform

```
terraform init && terraform plan && terraform apply -auto-approve
```

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
