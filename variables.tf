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
