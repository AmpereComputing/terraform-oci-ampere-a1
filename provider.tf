provider "oci" {
   tenancy_ocid = var.tenancy_ocid
   user_ocid = var.user_ocid
   fingerprint = var.fingerprint
   private_key_path = var.private_key_path
#  region           = var.region
# Add an alias for the provider and lookup the region
   alias = "home"
   region = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
}
