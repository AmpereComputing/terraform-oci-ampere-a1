# "RockyLinux 8 OS"
resource "oci_marketplace_accepted_agreement" "rockylinux_8_accepted_agreement" {
  agreement_id    = oci_marketplace_listing_package_agreement.rockylinux_8_package_agreement.agreement_id
  compartment_id  = var.tenancy_ocid
  listing_id      = data.oci_marketplace_listing.rockylinux_8.id
  package_version = data.oci_marketplace_listing.rockylinux_8.default_package_version
  signature       = oci_marketplace_listing_package_agreement.rockylinux_8_package_agreement.signature
}
resource "oci_marketplace_listing_package_agreement" "rockylinux_8_package_agreement" {
  agreement_id    = data.oci_marketplace_listing_package_agreements.rockylinux_8_package_agreements.agreements[0].id
  listing_id      = data.oci_marketplace_listing.rockylinux_8.id
  package_version = data.oci_marketplace_listing.rockylinux_8.default_package_version
}
data "oci_marketplace_listings" "rockylinux_8" {
  pricing        = ["Free"]
  name           = ["Rocky Linux 8 aarch64"]
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package_agreements" "rockylinux_8_package_agreements" {
  listing_id      = data.oci_marketplace_listing.rockylinux_8.id
  package_version = data.oci_marketplace_listing.rockylinux_8.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_package" "rockylinux_8_package" {
  listing_id      = data.oci_marketplace_listing.rockylinux_8.id
  package_version = data.oci_marketplace_listing.rockylinux_8.default_package_version
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing_packages" "rockylinux_8_packages" {
  listing_id     = data.oci_marketplace_listing.rockylinux_8.id
  compartment_id = var.tenancy_ocid
}
data "oci_marketplace_listing" "rockylinux_8" {
  listing_id     = data.oci_marketplace_listings.rockylinux_8.listings[0].id
  compartment_id = var.tenancy_ocid
}
data "oci_core_app_catalog_listing_resource_versions" "rockylinux_8_app_catalog_listing_resource_versions" {
  listing_id     = data.oci_marketplace_listing_package.rockylinux_8_package.app_catalog_listing_id
}
data "oci_core_app_catalog_listing_resource_version" "rockylinux_8_catalog_listing" {
  listing_id       = data.oci_marketplace_listing_package.rockylinux_8_package.app_catalog_listing_id
  resource_version = data.oci_marketplace_listing_package.rockylinux_8_package.app_catalog_listing_resource_version
}
resource "oci_core_app_catalog_listing_resource_version_agreement" "rockylinux_8_app_catalog_listing_resource_version_agreement" {
  listing_id               = data.oci_marketplace_listing_package.rockylinux_8_package.app_catalog_listing_id
  listing_resource_version = data.oci_core_app_catalog_listing_resource_versions.rockylinux_8_app_catalog_listing_resource_versions.app_catalog_listing_resource_versions[0].listing_resource_version
}
resource "oci_core_app_catalog_subscription" "rockylinux_8_app_catalog_subscription" {
  compartment_id           = var.tenancy_ocid
  eula_link                = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.eula_link
  listing_id               = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.listing_id
  listing_resource_version = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.listing_resource_version
  oracle_terms_of_use_link = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.oracle_terms_of_use_link
  signature                = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.signature
  time_retrieved           = oci_core_app_catalog_listing_resource_version_agreement.rockylinux_8_app_catalog_listing_resource_version_agreement.time_retrieved
}

# Output OCI RockyLinux 8 Image ID
output OCI_RockyLinux_8_OS_Image_id {
    sensitive = false
    value   = data.oci_core_app_catalog_listing_resource_version.rockylinux_8_catalog_listing.listing_resource_id
}
