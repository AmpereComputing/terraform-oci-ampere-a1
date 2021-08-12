# User/Tenant authentication variables
variable "tenancy_ocid" {
}
variable "user_ocid" {
}
variable "fingerprint" {
}
variable "private_key_path" {
}
variable "region" {
    default = "ca-montreal-1"
    description = "OCI Region that was chosen during Free-Tier Account creation"
}
variable "compartment_ocid" {
}
# Api Token
variable "oci_api_token" {
}

# SSH Key
#variable "ssh_public_key" {
#}

# OS Image URI
variable "image_ocid" {
    default     = "ocid1.image.oc1.ca-montreal-1.aaaaaaaad6knjdtt7y55hbsr4o3ckdx2uoj7xg7xqbjrb66nf76i7ijjaeta"
    description = "OCID for OL8 Aarch64 Image in region CA-Montreal-1"
}

# Object Storage Variables
variable "oci_object_storage_namespace" {
}
variable "oci_s3_designated_compartment" {
}
variable "oci_swift_designated_compartment" {
}

# Network Configuration Variables

variable "oci_vcn_cidr_block" {
    default     = "10.2.0.0/16"
    description = "CIDR Address range for OCI Networks"
}

variable "oci_vcn_cidr_subnet" {
    default     = "10.2.1.0/24"
    description = "CIDR Address range for OCI Networks"
}

# This model was used in upstream
variable "ad_region_mapping" {
  type = map(string)

  default = {
    ca-montreal-1 = 1
  }
}


variable "oci_availability_domain" {
    default     = "FFpD:CA-MONTREAL-1-AD-1"
    description = "OCI Availability Domain, default is for CA-Montreal-1"
}

variable "ampere_a1_cpu_core_count" {
    default = "4"
    type    = string
}
