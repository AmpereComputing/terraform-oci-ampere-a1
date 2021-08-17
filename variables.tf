# User/Tenant authentication variables
variable "tenancy_ocid" {
    description = "OCI Tenancy ID for Free-Tier Account"
}

variable "user_ocid" {
    description = "OCI User ID for Free-Tier Account"
}
variable "fingerprint" {
    description = "OCI Fingerprint ID for Free-Tier Account"
}

variable "private_key_path" {
    description = "Local path to the OCI private key file"
}

#variable "region" {
#    default = "ca-montreal-1"
#    description = "OCI Region that was chosen during Free-Tier Account creation"
#}

#variable "oci_availability_domain" {
#    default     = "FFpD:CA-MONTREAL-1-AD-1"
#    description = "OCI Availability Domain, default is for CA-Montreal-1"
#}

#variable "compartment_ocid" {
#}


# Api Token
variable "oci_api_token" {
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

# Virtual Machine Configuration Variables
variable "ampere_a1_cpu_core_count" {
    default = "4"
    description = "Default core count for Ampere A1 instances in OCI Free Tier"
    type    = string
}
