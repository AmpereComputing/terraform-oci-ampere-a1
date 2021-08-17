data oci_identity_regions regions {}

data oci_identity_tenancy tenancy {
    tenancy_id = var.tenancy_ocid
}

locals {
    region_map = { for r in data.oci_identity_regions.regions.regions : r.key => r.name }
}

output oci_home_region {
    value = lookup(local.region_map, data.oci_identity_tenancy.tenancy.home_region_key)
}
